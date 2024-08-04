from typing import Tuple


class IDPool(object):
    def __init__(self, n_events=None, period=None):
        """
        Constructor.
        """
        self.n_events = n_events
        self.period = period

    def id(self, obj: Tuple[int, int]) -> int:
        index, value = obj
        return (index - 1) * self.period + value + 1

    def obj(self, vid) -> Tuple[int, int]:
        index = ((vid - 1) // self.period) + 1
        value = (vid - 1) % self.period

        return index, value
