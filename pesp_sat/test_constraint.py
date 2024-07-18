import pytest
from pesp_sat.models import Constraint, Interval

def test_constraint_creation():
    c = Constraint(0, 1, Interval(1, 5))
    assert c.i == 0
    assert c.j == 1
    assert c.interval == Interval(1, 5)

def test_constraint_string_representation():
    c = Constraint(0, 1, Interval(1, 5))
    assert str(c) == "a[0] - a[1] in [1, 5]"

def test_constraint_satisfaction():
    c = Constraint(0, 1, Interval(1, 5))
    assert c.is_satisfied([3, 1])  # 3 - 1 = 2, which is in [1, 5]
    assert c.is_satisfied([6, 1])  # 6 - 1 = 5, which is in [1, 5]
    assert not c.is_satisfied([3, 3])  # 3 - 3 = 0, which is not in [1, 5]
    assert not c.is_satisfied([1, 3])  # 1 - 3 = -2, which is not in [1, 5]

def test_constraint_with_periodic_interval():
    c = Constraint(0, 1, Interval(1, 3, 5))
    assert c.is_satisfied([3, 1])     # 3 - 1 = 2, which is in [1, 3] period 5
    assert c.is_satisfied([8, 2])     # 8 - 2 = 6, which is equivalent to 1 in [1, 3] period 5
    assert c.is_satisfied([13, 5])    # 13 - 5 = 8, which is equivalent to 3 in [1, 3] period 5
    assert not c.is_satisfied([6, 1]) # 6 - 1 = 5, which is not in [1, 3] period 5
    assert not c.is_satisfied([3, 3]) # 3 - 3 = 0, which is not in [1, 3] period 5

def test_constraint_with_out_of_range_indices():
    c = Constraint(0, 1, Interval(1, 5))
    with pytest.raises(IndexError):
        c.is_satisfied([1])  # List is too short