from typing import Tuple, List, Sequence, Dict, TextIO
from pesp_sat.models import PeriodicEventNetwork, Constraint
import collections


CNF = List[List[int]]

pair_map: Dict[Tuple[int, int], int] = dict()
rev_map: Dict[int, Tuple[int, int]] = dict()
count = 0


def pair(x: int, y: int) -> int:
    if pair_map.get((x, y), 0) != 0:
        return pair_map[(x, y)]

    global count
    count += 1
    pair_map[(x, y)] = count
    rev_map[count] = (x, y)

    return count


def unpair(z: int) -> Tuple[int, int]:
    return rev_map[z]


# Adapt from: https://github.com/pysathq/pysat/blob/db89c1b88fd20eeef0da9fd5a677cab508cf9979/pysat/formula.py
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


def encode_variable(name: str, bound: Sequence[int], vpool=None) -> CNF:
    if not vpool:
        vpool = IDPool()

    bound = sorted(bound)
    cnf = []

    cnf.append([vpool.id(obj=(name, value)) for value in bound])

    for first_value in bound:
        for second_value in bound:
            if first_value == second_value:
                continue
            first_assign = vpool.id(obj=(name, first_value))
            second_assign = vpool.id(obj=(name, second_value))
            cnf.append([-first_assign, -second_assign])

    return cnf


def encode_constraint(contraint: Constraint, vpool=None) -> CNF:
    if not vpool:
        vpool = IDPool()

    period = contraint.interval.period
    unfeasible_pairs = [
        (a, b) for a in range(period) for b in range(period) if not contraint.hold(a, b)
    ]
    cnf = []
    for p_i_val, p_j_val in unfeasible_pairs:
        p_i_assign = vpool.id(obj=(f"p_{contraint.i}", p_i_val))
        p_j_assign = vpool.id(obj=(f"p_{contraint.j}", p_j_val))

        cnf.append([-p_i_assign, -p_j_assign])

    return cnf


def direct_encode(pen: PeriodicEventNetwork) -> Tuple[IDPool, CNF]:
    cnf = []
    pool = IDPool()

    for index in range(pen.n):
        name = f"p_{index + 1}"
        cnf.extend(encode_variable(name=name, bound=range(0, pen.T), vpool=pool))

    for con in pen.constraints:
        cnf.extend(encode_constraint(contraint=con, vpool=pool))

    return pool, cnf


def order_encode(pen: PeriodicEventNetwork) -> CNF:
    return [[1]]


def export_cnf(file: TextIO, cnf: CNF):
    clauses = len(cnf)
    variables = max(max(map(abs, clause)) for clause in cnf)

    file.write(f"p cnf {variables} {clauses}\n")
    lines = map(lambda clause: " ".join(map(str, clause)), cnf)
    file.writelines(lines)

    pass
