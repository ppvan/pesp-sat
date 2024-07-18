import pytest
from pesp_sat.models import Constraint, Interval


def test_constraint_creation():
    c = Constraint(0, 1, Interval(1, 5))
    assert c.i == 0
    assert c.j == 1
    assert c.interval == Interval(1, 5)

def test_constraint_with_periodic_interval():
    c = Constraint(0, 1, Interval(1, 3, 5))
    assert c.is_satisfied([1, 2])  # 2 - 1 = 1 and 2 + 1 = 3, both in [1, 3] period 5
    assert c.is_satisfied(
        [4, 2]
    )  # 2 - 4 = -2 (equivalent to 3) and 2 + 4 = 6 (equivalent to 1), both in [1, 3] period 5
    assert c.is_satisfied(
        [2, 4]
    )  # 4 - 2 = 2 but 4 + 2 = 6 (equivalent to 1), only difference in [1, 3] period 5
    assert not c.is_satisfied(
        [0, 0]
    )  # 0 - 0 = 0 and 0 + 0 = 0, neither in [1, 3] period 5


def test_constraint_with_out_of_range_indices():
    c = Constraint(0, 1, Interval(1, 5))
    with pytest.raises(IndexError):
        c.is_satisfied([1])  # List is too short
