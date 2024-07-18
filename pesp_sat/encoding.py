from typing import Tuple, List, Sequence, Dict
import math
from pesp_sat.models import PeriodicEventNetwork, Constraint

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


def encode_variable(index: int, bound: Sequence[int]) -> CNF:
    bound = sorted(bound)
    cnf = []
    cnf.append([pair(index, value) for value in bound])

    for first_value in bound:
        for second_value in bound:
            if first_value == second_value:
                continue
            cnf.append([-pair(index, first_value), -pair(index, second_value)])


    return cnf


def encode_constraint(contraint: Constraint) -> CNF:
    period = contraint.interval.period
    unfeasible_pairs = [
        (a, b) for a in range(period) for b in range(period) if not contraint.hold(a, b)
    ]
    cnf = []
    for p_i_val, p_j_val in unfeasible_pairs:

        cnf.append([-pair(contraint.i, p_i_val), -pair(contraint.j, p_j_val)])

    return cnf


def direct_encode(pen: PeriodicEventNetwork) -> CNF:
    cnf = []

    for val in range(1, pen.T):
        cnf.append([pair(0, val)])

    for index in range(pen.n):
        cnf.extend(encode_variable(index=index + 1, bound=range(0, pen.T)))

    for con in pen.constraints:
        cnf.extend(encode_constraint(contraint=con))

    return cnf


def order_encode(pen: PeriodicEventNetwork) -> CNF:
    return [[1]]
