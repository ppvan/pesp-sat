from typing import Self, Tuple, List, Dict, TextIO, Set
from pesp_sat.models import PeriodicEventNetwork, Constraint
import math
from pesp_sat.mappers import IDPool
from abc import ABC, abstractmethod


CNF = List[List[int]]
Rect = Tuple[Tuple[int, int], Tuple[int, int]]


class Encoder(ABC):
    @abstractmethod
    def encode(self, pen: PeriodicEventNetwork) -> CNF:
        pass

    @abstractmethod
    def decode(self, model: List[int]) -> CNF:
        pass


class DirectEncode(Encoder):
    period: int
    pen: PeriodicEventNetwork

    def __init__(self, pen: PeriodicEventNetwork) -> None:
        self.pen = pen
        self.vpool = IDPool(n_events=pen.n, period=pen.period)
        self.period = pen.period

    def _encode_vars(self) -> CNF:
        bound = range(self.period)
        events = self.pen.n
        cnf = []

        for event in range(1, events + 1):
            cnf.append([self.vpool.id(obj=(event, value)) for value in bound])
            for first_value in bound:
                for second_value in bound:
                    if first_value >= second_value:
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
        return self._encode_vars() + self._encode_constraints()

    def decode(self, model: List[int]) -> Dict[int, int]:
        true_assigns = filter(None, (self.vpool.obj(x) for x in model if x > 0))

        return {name: value for (name, value) in true_assigns}


class OrderEncode(Encoder):
    pen: PeriodicEventNetwork
    period: int
    vpool: IDPool

    def __init__(self, pen: PeriodicEventNetwork) -> None:
        self.pen = pen
        self.period = pen.period
        self.vpool = IDPool(n_events=pen.n, period=pen.period)

    def delta_x(self, low: int, high: int) -> int:
        return math.ceil(0.5 * (low - high - 1)) - 1

    def delta_y(self, low: int, high: int) -> int:
        return math.floor(0.5 * (low - high - 1))

    def time_phi(self, low: int, high: int) -> List[Rect]:
        print("-", low, high)
        delta_x = self.delta_x(low, high)
        delta_y = self.delta_y(low, high)
        period = self.period
        high_plus_1 = high + 1
        period_minus_1 = period - 1

        return [
            ((x1, x1 + delta_x), (y1, y1 + delta_y))
            for y1 in range(-delta_y, period)
            if (x1 := y1 - high_plus_1 - delta_x) + delta_x >= 0
            and x1 <= period_minus_1
        ]

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

    def _time_unfeasible_region(self, cons: Constraint) -> List[Rect]:
        low, high, period = cons.interval.start, cons.interval.end, self.period
        k = 0 if low * (high + 1) < 0 else -1

        def generate_regions():
            for i in range(k, 2):
                yield from self.time_phi(low + i * period, high + (i - 1) * period)

        return list(generate_regions())

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
        x, y = constraint.i, constraint.j
        period = self.period
        period_minus_one = period - 1
        cnf = []
        unfeasibles = self._time_unfeasible_region(cons=constraint)

        for (x1, x2), (y1, y2) in unfeasibles:
            print(f"[{x1} {x2} {y1} {y2}]")
            x_lte_x1_prev = self.vpool.id((x, x1 - 1)) if x1 > 0 else 0
            x_lte_x2 = self.vpool.id((x, x2)) if x2 < period_minus_one else 0
            y_lte_y1_prev = self.vpool.id((y, y1 - 1)) if y1 > 0 else 0
            y_lte_y2 = self.vpool.id((y, y2)) if y2 < period_minus_one else 0

            clause = [-x_lte_x2, x_lte_x1_prev, -y_lte_y2, y_lte_y1_prev]
            cnf.append([term for term in clause if term != 0])

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
        frozen_model = frozenset(model)
        for lit in model:
            if lit > 0:
                pair: Tuple[int, int] = self.vpool.obj(lit)
                name, value = pair
                if value == 0:
                    ans[name] = value
                    continue

                other = self.vpool.id((name, value - 1))
                if -other in frozen_model:
                    ans[name] = value
            else:
                pair: Tuple[int, int] = self.vpool.obj(-lit)
                name, value = pair

                if value == self.period - 2:
                    ans[name] = self.period - 1

        return ans

    def export_cnf(file: TextIO, cnf: CNF):
        clauses = len(cnf)
        variables = max(max(map(abs, clause)) for clause in cnf)

        file.write(f"p cnf {variables} {clauses}\n")
        lines = map(lambda clause: " ".join(map(str, clause)), cnf)
        file.writelines(lines)
