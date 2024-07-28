# test_interval.py
from pesp_sat.models import Interval

def test_non_periodic_interval():
    interval = Interval(3, 5)
    assert 3 in interval
    assert 4 in interval
    assert 5 in interval
    assert 2 not in interval
    assert 6 not in interval

def test_periodic_interval():
    interval = Interval(50, 55, 60)
    assert -10 in interval
    assert 50 in interval
    assert 55 in interval
    assert 110 in interval
    assert 170 in interval
    assert 56 not in interval
    assert 49 not in interval

def test_periodic_interval_with_negative_range():
    interval = Interval(-5, 5, 20)
    assert -5 in interval
    assert 0 in interval
    assert 5 in interval
    assert 15 in interval
    assert 35 in interval
    assert -25 in interval
    assert 10 not in interval

def test_wrap_around_interval():
    interval = Interval(8, 2, 10)
    assert 8 in interval
    assert 9 in interval
    assert 0 in interval
    assert 1 in interval
    assert 2 in interval
    assert 3 not in interval
    assert 7 not in interval

def test_string_representation():
    assert str(Interval(3, 5)) == "[3, 5]"
    assert str(Interval(3, 5, 10)) == "[3, 5] period 10"

def test_iterate_range():
    interval = Interval(3, 5)
    assert list(interval.iterate_range()) == [3, 4, 5]

def test_invalid_period():
    interval = Interval(1, 5, -1)
    assert 1 not in interval
    assert 3 not in interval
    assert 5 not in interval