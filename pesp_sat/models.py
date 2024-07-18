from typing import NamedTuple, List, Tuple, TextIO, Dict

PERIOD = 60


class Interval(NamedTuple):
    start: int
    end: int
    period: int = 0

    def contains(self, value: int) -> bool:
        if self.period == 0:
            return self.start <= value <= self.end

        if self.period > 0:
            normalized_value = value % self.period
            normalized_start = self.start % self.period
            normalized_end = self.end % self.period

            if normalized_start <= normalized_end:
                return normalized_start <= normalized_value <= normalized_end
            else:
                return (
                    normalized_value >= normalized_start
                    or normalized_value <= normalized_end
                )
        else:
            return False

    def __str__(self) -> str:
        if self.period == 0:
            return f"[{self.start}, {self.end}]"
        return f"[{self.start}, {self.end}] period {self.period}"

    def iterate_range(self):
        return range(self.start, self.end + 1)


class Constraint(NamedTuple):
    i: int
    j: int
    interval: Interval
    symmetry: bool = False

    def __str__(self) -> str:
        return f"(a[{self.i}], a[{self.j}]) in {self.interval}"

    def is_satisfied(self, potentials: Dict[int, int]) -> bool:
        """
        Check if the constraint is satisfied for the given list 'a'.
        """
        if self.i not in potentials.keys() or self.j not in potentials.keys():
            raise IndexError("Constraint indices out of range")

        return self.hold(potentials[self.i], potentials[self.j])

    def hold(self, potential: int, other: int):
        difference = other - potential
        sum_of_potentials = other + potential

        time_hold = self.interval.contains(difference)
        symmetry_hold = self.interval.contains(sum_of_potentials)

        return time_hold and (not self.symmetry or symmetry_hold)


class PeriodicEventNetwork:
    def __init__(self, n: int, constraints: List[Constraint], T: int):
        self.n = n  # number of events
        self.constraints = constraints
        self.T = T  # period

    def __str__(self):
        constraints_str = "\n".join(str(c) for c in self.constraints)
        return (
            f"Periodic Event Network:\n"
            f"Number of events: {self.n}\n"
            f"Period: {self.T}\n"
            f"Constraints:\n{constraints_str}"
        )

    def is_feasible(self, schedule: Dict[int, int]) -> bool:
        """
        Check if a given schedule satisfies all constraints.

        :param schedule: A list of n integers representing the timing of each event
        :return: True if the schedule satisfies all constraints, False otherwise
        """
        if len(schedule) != self.n:
            raise ValueError(f"Schedule must have exactly {self.n} events")

        return all(constraint.is_satisfied(schedule) for constraint in self.constraints)

    def get_events(self) -> List[Tuple[int, int]]:
        """
        Return a list of all event pairs (i, j) mentioned in the constraints.
        """
        events = set()
        for constraint in self.constraints:
            events.add((constraint.i, constraint.j))
        return list(events)

    @staticmethod
    def parse(file: TextIO) -> "PeriodicEventNetwork":
        firstline = file.readline().strip().split(" ")

        _contraint_len, potentials_len, period = (int(x) for x in firstline)

        constraints = []
        for line in file:
            if line.startswith("#"):
                continue

            parts = line.strip().split(";")
            if len(parts) == 6:
                parts = list(map(int, parts))
                _id, i, j, start, end, _weight = parts
                con = Constraint(
                    i=i, j=j, interval=Interval(start=start, end=end, period=period)
                )

                constraints.append(con)

        pen = PeriodicEventNetwork(T=PERIOD, constraints=constraints, n=potentials_len)

        return pen
