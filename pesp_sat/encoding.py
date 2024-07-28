from typing import Self, Tuple, List, Dict, TextIO, Set
from pesp_sat.models import PeriodicEventNetwork, Constraint
import collections
import math


CNF = List[List[int]]
Rect = Tuple[Tuple[int, int], Tuple[int, int]]


class IDPool(object):
    def __init__(self, start_from=1):
        """
        Constructor.
        """

        self.restart(start_from=start_from)

    def __repr__(self):
        """
        State reproducible string representaion of object.
        """

        return f"IDPool(start_from={self.top+1}, occupied={self._occupied})"

    def restart(self, start_from=1, occupied=[]):
        """
        Restart the manager from scratch. The arguments replicate those of
        the constructor of :class:`IDPool`.
        """

        # initial ID
        self.top = start_from - 1

        # occupied IDs
        self._occupied = sorted(occupied, key=lambda x: x[0])

        # main dictionary storing the mapping from objects to variable IDs
        self.obj2id = collections.defaultdict(lambda: self._next())

        # mapping back from variable IDs to objects
        # (if for whatever reason necessary)
        self.id2obj = {}

    def id(self, obj=None):
        """
        The method is to be used to assign an integer variable ID for a
        given new object. If the object already has an ID, no new ID is
        created and the old one is returned instead.

        An object can be anything. In some cases it is convenient to use
        string variable names. Note that if the object is not provided,
        the method will return a new id unassigned to any object.

        :param obj: an object to assign an ID to.

        :rtype: int.

        Example:

        .. code-block:: python

            >>> from pysat.formula import IDPool
            >>> vpool = IDPool(occupied=[[12, 18], [3, 10]])
            >>>
            >>> # creating 5 unique variables for the following strings
            >>> for i in range(5):
            ...    print(vpool.id('v{0}'.format(i + 1)))
            1
            2
            11
            19
            20

        In some cases, it makes sense to create an external function for
        accessing IDPool, e.g.:

        .. code-block:: python

            >>> # continuing the previous example
            >>> var = lambda i: vpool.id('var{0}'.format(i))
            >>> var(5)
            20
            >>> var('hello_world!')
            21
        """

        if obj is not None:
            vid = self.obj2id[obj]

            if vid not in self.id2obj:
                self.id2obj[vid] = obj
        else:
            # no object is provided => simply return a new ID
            vid = self._next()

        return vid

    def obj(self, vid):
        """
        The method can be used to map back a given variable identifier to
        the original object labeled by the identifier.

        :param vid: variable identifier.
        :type vid: int

        :return: an object corresponding to the given identifier.

        Example:

        .. code-block:: python

            >>> vpool.obj(21)
            'hello_world!'
        """

        if vid in self.id2obj:
            return self.id2obj[vid]

        return None

    def occupy(self, start, stop):
        """
        Mark a given interval as occupied so that the manager could skip
        the values from ``start`` to ``stop`` (**inclusive**).

        :param start: beginning of the interval.
        :param stop: end of the interval.

        :type start: int
        :type stop: int
        """

        if stop >= start:
            # the following check serves to remove unnecessary interval
            # spawning; since the intervals are sorted, we are checking
            # if the previous interval is a (non-strict) subset of the new one
            if (
                len(self._occupied)
                and self._occupied[-1][0] >= start
                and self._occupied[-1][1] <= stop
            ):
                self._occupied.pop()

            self._occupied.append([start, stop])
            self._occupied.sort(key=lambda x: x[0])

    def _next(self):
        """
        Get next variable ID. Skip occupied intervals if any.
        """

        self.top += 1

        while self._occupied and self.top >= self._occupied[0][0]:
            if self.top <= self._occupied[0][1]:
                self.top = self._occupied[0][1] + 1

            self._occupied.pop(0)

        return self.top


class DirectEncode(object):
    period: int
    pen: PeriodicEventNetwork

    def __init__(self, pen: PeriodicEventNetwork) -> None:
        self.pen = pen
        self.vpool = IDPool()
        self.period = pen.period

        pass

    def _encode_vars(self) -> CNF:
        bound = range(self.period)
        events = self.pen.n
        cnf = []

        for event in range(1, events + 1):
            cnf.append([self.vpool.id(obj=(event, value)) for value in bound])
            for first_value in bound:
                for second_value in bound:
                    if first_value == second_value:
                        continue
                    first_assign = self.vpool.id(obj=(event, first_value))
                    second_assign = self.vpool.id(obj=(event, second_value))
                    cnf.append([-first_assign, -second_assign])

        return cnf

    def _encode_constraints(self) -> CNF:
        cnf = []
        period = self.period

        for contraint in self.pen.constraints:
            unfeasible_pairs = [
                (a, b)
                for a in range(period)
                for b in range(period)
                if not contraint.hold(a, b)
            ]
            for p_i_val, p_j_val in unfeasible_pairs:
                p_i_assign = self.vpool.id(obj=(contraint.i, p_i_val))
                p_j_assign = self.vpool.id(obj=(contraint.j, p_j_val))

                cnf.append([-p_i_assign, -p_j_assign])

        return cnf

    def encode(self) -> CNF:
        return self._encode_constraints() + self._encode_vars()

    def decode(self, model: List[int]) -> Dict[int, int]:
        true_assigns = filter(None, (self.vpool.obj(x) for x in model if x > 0))

        return {name: value for (name, value) in true_assigns}


class OrderEncode(object):
    pen: PeriodicEventNetwork
    period: int
    vpool: IDPool

    def __init__(self, pen: PeriodicEventNetwork) -> None:
        self.pen = pen
        self.period = pen.period
        self.vpool = IDPool()
        pass

    def delta(self, low: int, high: int) -> int:
        return low - high - 1

    def delta_x(self, low: int, high: int) -> int:
        return math.ceil(0.5 * self.delta(low, high)) - 1

    def delta_y(self, low: int, high: int) -> int:
        return math.floor(0.5 * self.delta(low, high))

    def time_phi(self, low: int, high: int) -> Set[Rect]:
        unfeasible_rects = set()

        for y1 in range(-self.delta_y(low, high), self.period):
            x1 = y1 - high - 1 - self.delta_x(low, high)
            if x1 + self.delta_x(low, high) < 0 or x1 > self.period - 1:
                continue
            x2 = x1 + self.delta_x(low, high)
            y2 = y1 + self.delta_y(low, high)
            unfeasible_rects.add(((x1, x2), (y1, y2)))

        return unfeasible_rects

    def symetry_phi(self, low: int, high: int) -> Set[Rect]:
        unfeasible_rects = set()

        for y1 in range(-self.delta_y(low, high), self.period):
            x1 = -y1 + low - 1 - self.delta_x(low, high)
            if x1 + self.delta_x(low, high) < 0 or x1 > self.period - 1:
                continue
            x2 = x1 + self.delta_x(low, high)
            y2 = y1 + self.delta_y(low, high)
            unfeasible_rects.add(((x1, x2), (y1, y2)))

        return unfeasible_rects

    def _time_unfeasible_region(self, cons: Constraint) -> Set[Rect]:
        low = cons.interval.start
        high = cons.interval.end
        k = 0 if 0 in list(range(low, high + 1)) else -1

        regions = set()
        for i in range(k, 2):
            rects = self.time_phi(low + i * self.period, high + (i - 1) * self.period)
            regions = regions.union(regions, rects)

        return regions

    def _symetry_unfeasible_region(self, cons: Constraint) -> Set[Rect]:
        low = cons.interval.start
        high = cons.interval.end
        k = 1 if 0 in list(range(low, high + 1)) else 2

        regions = set()
        for i in range(k + 1):
            rects = self.symetry_phi(
                low + i * self.period, high + (i - 1) * self.period
            )
            regions = regions.union(regions, rects)

        return regions

    def encode_vars(self) -> CNF:
        events = self.pen.n
        period = self.period
        vpool = self.vpool

        cnf = []
        for var in range(1, events + 1):
            for value in range(1, period - 1):
                var_lte_prev_value = vpool.id((var, value - 1))
                var_lte_value = vpool.id((var, value))

                cnf.append([-var_lte_prev_value, var_lte_value])

        return cnf

    def _encode_time_constraint(self, constraint: Constraint) -> CNF:
        x = constraint.i
        y = constraint.j
        cnf = []

        unfeasibles = self._time_unfeasible_region(cons=constraint)

        for rect in unfeasibles:
            ((x1, x2), (y1, y2)) = rect

            # (x, y) not in (x1, x2), (y1, y2), if x1,x2, y1, y2 not in [0, T-1] than no need to include them in clause
            x_lte_x1_prev = self.vpool.id((x, x1 - 1)) if x1 > 0 else 0
            x_lte_x2 = self.vpool.id((x, x2)) if x2 < self.period - 1 else 0
            y_lte_y1_prev = self.vpool.id((y, y1 - 1)) if y1 > 0 else 0
            y_lte_y2 = self.vpool.id((y, y2)) if y2 < self.period - 1 else 0

            clause = list(
                filter(
                    lambda x: x != 0,
                    [-x_lte_x2, x_lte_x1_prev, -y_lte_y2, y_lte_y1_prev],
                )
            )
            cnf.append(clause)

        return cnf

    def _encode_sysmetry_constraint(self, constraint: Constraint) -> CNF:
        x = constraint.i
        y = constraint.j
        cnf = []

        unfeasibles = self._symetry_unfeasible_region(cons=constraint)

        for rect in unfeasibles:
            ((x1, x2), (y1, y2)) = rect

            # (x, y) not in (x1, x2), (y1, y2), if x1,x2, y1, y2 not in [0, T-1] than no need to include them in clause
            x_lte_x1_prev = self.vpool.id((x, x1 - 1)) if x1 > 0 else 0
            x_lte_x2 = self.vpool.id((x, x2)) if x2 < self.period - 1 else 0
            y_lte_y1_prev = self.vpool.id((y, y1 - 1)) if y1 > 0 else 0
            y_lte_y2 = self.vpool.id((y, y2)) if y2 < self.period - 1 else 0

            clause = list(
                filter(
                    lambda x: x != 0,
                    [-x_lte_x2, x_lte_x1_prev, -y_lte_y2, y_lte_y1_prev],
                )
            )
            cnf.append(clause)

        return cnf

    def encode_constraints(self) -> CNF:
        cnf = []
        for con in self.pen.constraints:
            if con.symmetry:
                cnf.extend(self._encode_sysmetry_constraint(con))
            else:
                cnf.extend(self._encode_time_constraint(con))

        return cnf

    def encode(self: Self) -> CNF:
        return self.encode_vars() + self.encode_constraints()

    def decode(self: Self, model: List[int]) -> Dict[int, int]:
        ans = {}
        for lit in model:
            if lit > 0:
                pair: Tuple[int, int] = self.vpool.obj(lit)
                name, value = pair
                if value == 0:
                    ans[name] = value
                    continue

                other = self.vpool.id((name, value - 1))
                if -other in model:
                    ans[name] = value
            else:
                pair: Tuple[int, int] = self.vpool.obj(-lit)
                name, value = pair

                if value == self.period - 2:
                    ans[name] = self.period - 1

        return ans

    pass


def export_cnf(file: TextIO, cnf: CNF):
    clauses = len(cnf)
    variables = max(max(map(abs, clause)) for clause in cnf)

    file.write(f"p cnf {variables} {clauses}\n")
    lines = map(lambda clause: " ".join(map(str, clause)), cnf)
    file.writelines(lines)

    pass
