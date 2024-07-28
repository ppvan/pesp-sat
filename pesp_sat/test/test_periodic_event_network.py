import pytest
from pesp_sat.models import Constraint, PeriodicEventNetwork, Interval

def test_periodic_event_network_creation():
    constraints = [
        Constraint(0, 1, Interval(1, 5)),
        Constraint(1, 2, Interval(2, 4)),
    ]
    pen = PeriodicEventNetwork(3, constraints, 10)
    assert pen.n == 3
    assert pen.period == 10
    assert len(pen.constraints) == 2

def test_periodic_event_network_feasibility():
    constraints = [
        Constraint(1, 2, Interval(1, 5), symmetry=True),
        Constraint(2, 3, Interval(2, 4)),
    ]
    pen = PeriodicEventNetwork(3, constraints, 10)
    assert pen.is_feasible({1:1, 2:3, 3:5})
    assert pen.is_feasible({1:0, 2:2, 3:4})
    assert pen.is_feasible({1:1, 2:2, 3:5})

def test_periodic_event_network_feasibility_with_periodic_interval():
    constraints = [
        Constraint(1, 2, Interval(1, 3, 10)),
        Constraint(2, 3, Interval(2, 4, 10)),
    ]
    pen = PeriodicEventNetwork(3, constraints, 10)
    assert pen.is_feasible({1: 0, 2: 2, 3: 4})
    assert not pen.is_feasible({1: 1, 2: 10, 3: 5})

def test_periodic_event_network_get_events():
    constraints = [
        Constraint(1, 2, Interval(1, 5)),
        Constraint(2, 3, Interval(2, 4)),
        Constraint(1, 3, Interval(3, 6)),
    ]
    pen = PeriodicEventNetwork(3, constraints, 10)
    events = pen.get_events()
    assert set(events) == {(1, 2), (2, 3), (1, 3)}

def test_periodic_event_network_invalid_schedule():
    constraints = [Constraint(0, 1, Interval(1, 5))]
    pen = PeriodicEventNetwork(2, constraints, 10)
    with pytest.raises(ValueError):
        pen.is_feasible({1: 0})  # Schedule too short
    with pytest.raises(ValueError):
        pen.is_feasible({1:0, 2:1, 3:2})  # Schedule too long