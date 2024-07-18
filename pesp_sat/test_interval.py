# test_interval.py
from pesp_sat.models import Interval

def test_non_periodic_interval():
    interval = Interval(3, 5)
    assert interval.contains(3)
    assert interval.contains(4)
    assert interval.contains(5)
    assert not interval.contains(2)
    assert not interval.contains(6)

def test_periodic_interval():
    interval = Interval(50, 55, 60)
    assert interval.contains(-10)
    assert interval.contains(50)
    assert interval.contains(55)
    assert interval.contains(110)
    assert interval.contains(170)
    assert not interval.contains(56)
    assert not interval.contains(49)

def test_periodic_interval_with_negative_range():
    interval = Interval(-5, 5, 20)
    assert interval.contains(-5)
    assert interval.contains(0)
    assert interval.contains(5)
    assert interval.contains(15)
    assert interval.contains(35)
    assert interval.contains(-25)
    assert not interval.contains(10)

def test_wrap_around_interval():
    interval = Interval(8, 2, 10)
    assert interval.contains(8)
    assert interval.contains(9)
    assert interval.contains(0)
    assert interval.contains(1)
    assert interval.contains(2)
    assert not interval.contains(3)
    assert not interval.contains(7)

def test_string_representation():
    assert str(Interval(3, 5)) == "[3, 5]"
    assert str(Interval(3, 5, 10)) == "[3, 5] period 10"

def test_iterate_range():
    interval = Interval(3, 5)
    assert list(interval.iterate_range()) == [3, 4, 5]

def test_invalid_period():
    interval = Interval(1, 5, -1)
    assert not interval.contains(1)
    assert not interval.contains(3)
    assert not interval.contains(5)