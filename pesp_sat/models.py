from typing import NamedTuple, List


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

    def __str__(self) -> str:
        return f"a[{self.i}] - a[{self.j}] in {self.interval}"

    def is_satisfied(self, potentials: List[int]) -> bool:
        """
        Check if the constraint is satisfied for the given list 'a'.
        """
        if self.i >= len(potentials) or self.j >= len(potentials):
            raise IndexError("Constraint indices out of range")

        difference = potentials[self.i] - potentials[self.j]
        return self.interval.contains(difference)


class PespModel:
    pass
