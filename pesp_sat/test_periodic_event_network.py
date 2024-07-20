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
        Constraint(0, 1, Interval(1, 5)),
        Constraint(1, 2, Interval(2, 4)),
    ]
    pen = PeriodicEventNetwork(3, constraints, 10)

    assert not pen.is_feasible([1, 3, 5])  # Violates second constraint (sum condition)
    assert not pen.is_feasible([0, 2, 4])  # Violates first constraint (sum condition)
    assert not pen.is_feasible(
        [1, 2, 5]
    )  # Violates second constraint (difference and sum conditions)


def test_periodic_event_network_feasibility_with_periodic_interval():
    constraints = [
        Constraint(0, 1, Interval(1, 3, 5)),
        Constraint(1, 2, Interval(2, 4, 6)),
    ]
    pen = PeriodicEventNetwork(3, constraints, 10)

    assert not pen.is_feasible([0, 2, 4])  # Violates first constraint
    assert not pen.is_feasible([1, 2, 5])  # Violates second constraint


def test_periodic_event_network_get_events():
    constraints = [
        Constraint(0, 1, Interval(1, 5)),
        Constraint(1, 2, Interval(2, 4)),
        Constraint(0, 2, Interval(3, 6)),
    ]
    pen = PeriodicEventNetwork(3, constraints, 10)
    events = pen.get_events()
    assert set(events) == {(0, 1), (1, 2), (0, 2)}


def test_periodic_event_network_invalid_schedule():
    constraints = [Constraint(0, 1, Interval(1, 5))]
    pen = PeriodicEventNetwork(2, constraints, 10)
    with pytest.raises(ValueError):
        pen.is_feasible([0])  # Schedule too short
    with pytest.raises(ValueError):
        pen.is_feasible([0, 1, 2])  # Schedule too long
