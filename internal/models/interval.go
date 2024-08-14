package models

import "fmt"

type Interval struct {
	Start  int
	End    int
	Period int
}

func (i Interval) Normalized() Interval {
	normalizedStart := (i.Start%i.Period + i.Period) % i.Period
	normalizedEnd := (i.End%i.Period + i.Period) % i.Period

	// Since we only search in [0, T - 1], so if interval is out of this range, normalize and infer new range.
	// Need more investigation
	if normalizedEnd < normalizedStart {
		normalizedStart -= i.Period
	}

	// if normalizedStart < 0 {
	// 	normalizedStart = 0
	// }

	return Interval{
		Start:  normalizedStart,
		End:    normalizedEnd,
		Period: i.Period,
	}

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
