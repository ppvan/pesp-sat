package models

import "fmt"

type Interval struct {
	Start  int
	End    int
	Period int
}

func (i Interval) Contains(value int) bool {
	if i.Period == 0 {
		return i.Start <= value && value <= i.End
	}

	if i.Period > 0 {
		normalizedValue := (value%i.Period + i.Period*i.Period) % i.Period
		normalizedStart := (i.Start%i.Period + i.Period) % i.Period
		normalizedEnd := (i.End%i.Period + i.Period) % i.Period

		if normalizedStart <= normalizedEnd {
			return normalizedStart <= normalizedValue && normalizedValue <= normalizedEnd
		} else {
			return normalizedValue >= normalizedStart || normalizedValue <= normalizedEnd
		}
	}

	return false
}

func (i Interval) String() string {
	if i.Period == 0 {
		return fmt.Sprintf("[%d, %d]", i.Start, i.End)
	}
	return fmt.Sprintf("[%d, %d] period %d", i.Start, i.End, i.Period)
}
