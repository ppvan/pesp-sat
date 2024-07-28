import pytest
from pesp_sat.models import Constraint, Interval


def test_constraint_creation():
    c = Constraint(0, 1, Interval(1, 5))
    assert c.i == 0
    assert c.j == 1
    assert c.interval == Interval(1, 5)


def test_constraint_with_periodic_interval():
    c = Constraint(1, 2, Interval(1, 3, 5))
    assert c.is_satisfied({1: 1, 2: 2})
    assert c.is_satisfied({1: 4, 2: 2})
    assert c.is_satisfied({1: 2, 2: 4})
    assert not c.is_satisfied({1: 0, 2: 0})


def test_constraint_with_out_of_range_indices():
    c = Constraint(1, 2, Interval(1, 5))
    with pytest.raises(IndexError):
        c.is_satisfied({1: 1})
