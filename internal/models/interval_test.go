package models

import (
	"reflect"
	"testing"
)

func TestIntervalContains(t *testing.T) {
	tests := []struct {
		name     string
		interval Interval
		value    int
		want     bool
	}{
		// Non-periodic intervals
		{"non-periodic, value at start", Interval{Start: 1, End: 5, Period: 0}, 1, true},
		{"non-periodic, value at end", Interval{Start: 1, End: 5, Period: 0}, 5, true},
		{"non-periodic, value just before start", Interval{Start: 1, End: 5, Period: 0}, 0, false},
		{"non-periodic, value just after end", Interval{Start: 1, End: 5, Period: 0}, 6, false},
		{"non-periodic, value in middle", Interval{Start: 1, End: 5, Period: 0}, 3, true},

		// Periodic intervals
		{"periodic, value at start", Interval{Start: 1, End: 5, Period: 10}, 1, true},
		{"periodic, value at end", Interval{Start: 1, End: 5, Period: 10}, 5, true},
		{"periodic, value just before start", Interval{Start: 1, End: 5, Period: 10}, 0, false},
		{"periodic, value just after end", Interval{Start: 1, End: 5, Period: 10}, 6, false},
		{"periodic, value in middle", Interval{Start: 1, End: 5, Period: 10}, 3, true},
		{"periodic, value at start + period", Interval{Start: 1, End: 5, Period: 10}, 11, true},
		{"periodic, value at end + period", Interval{Start: 1, End: 5, Period: 10}, 15, true},
		{"periodic, value just before start + period", Interval{Start: 1, End: 5, Period: 10}, 10, false},
		{"periodic, value just after end + period", Interval{Start: 1, End: 5, Period: 10}, 16, false},

		// Wrapping periodic intervals
		{"wrapping periodic, value at start", Interval{Start: 8, End: 2, Period: 10}, 8, true},
		{"wrapping periodic, value at end", Interval{Start: 8, End: 2, Period: 10}, 2, true},
		{"wrapping periodic, value just before start", Interval{Start: 8, End: 2, Period: 10}, 7, false},
		{"wrapping periodic, value just after end", Interval{Start: 8, End: 2, Period: 10}, 3, false},
		{"wrapping periodic, value in middle (after period)", Interval{Start: 8, End: 2, Period: 10}, 0, true},
		{"wrapping periodic, value at start + period", Interval{Start: 8, End: 2, Period: 10}, 18, true},
		{"wrapping periodic, value at end + period", Interval{Start: 8, End: 2, Period: 10}, 12, true},

		// Edge cases
		{"zero-length interval", Interval{Start: 5, End: 5, Period: 0}, 5, true},
		{"zero-length periodic interval", Interval{Start: 5, End: 5, Period: 10}, 15, true},
		{"full-period interval", Interval{Start: 0, End: 9, Period: 10}, 5, true},
		{"negative period", Interval{Start: 1, End: 5, Period: -10}, 3, false},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := tt.interval.Contains(tt.value); got != tt.want {
				t.Errorf("Interval.Contains() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestIntervalString(t *testing.T) {
	tests := []struct {
		name     string
		interval Interval
		want     string
	}{
		{"non-periodic interval", Interval{Start: 1, End: 5, Period: 0}, "[1, 5]"},
		{"periodic interval", Interval{Start: 1, End: 5, Period: 10}, "[1, 5] period 10"},
		{"zero-length interval", Interval{Start: 5, End: 5, Period: 0}, "[5, 5]"},
		{"zero-length periodic interval", Interval{Start: 5, End: 5, Period: 10}, "[5, 5] period 10"},
		{"negative bounds", Interval{Start: -5, End: -1, Period: 0}, "[-5, -1]"},
		{"negative bounds periodic", Interval{Start: -5, End: -1, Period: 10}, "[-5, -1] period 10"},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := tt.interval.String(); got != tt.want {
				t.Errorf("Interval.String() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestIntervalNormalized(t *testing.T) {
	tests := []struct {
		name     string
		interval Interval
		want     Interval
	}{
		{
			name: "simple interval within period",
			interval: Interval{
				Start:  2,
				End:    5,
				Period: 10,
			},
			want: Interval{
				Start:  2,
				End:    5,
				Period: 10,
			},
		},
		{
			name: "interval exceeding period",
			interval: Interval{
				Start:  12,
				End:    15,
				Period: 10,
			},
			want: Interval{
				Start:  2,
				End:    5,
				Period: 10,
			},
		},

		{
			name: "end less than start after normalization",
			interval: Interval{
				Start:  8,
				End:    2,
				Period: 10,
			},
			want: Interval{
				Start:  -2,
				End:    2,
				Period: 10,
			},
		},
		{
			name: "zero period edge case",
			interval: Interval{
				Start:  5,
				End:    8,
				Period: 1,
			},
			want: Interval{
				Start:  0,
				End:    0,
				Period: 1,
			},
		},
		{
			name: "start and end equal",
			interval: Interval{
				Start:  15,
				End:    15,
				Period: 10,
			},
			want: Interval{
				Start:  5,
				End:    5,
				Period: 10,
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := tt.interval.Normalized()
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("Interval.Normalized() = %+v, want %+v", got, tt.want)
			}

			// Additional validation
			if got.Period != tt.interval.Period {
				t.Errorf("Period was modified: got %d, want %d", got.Period, tt.interval.Period)
			}

			// Validate that normalized values are actually within the period range
			if got.End >= tt.interval.Period {
				t.Errorf("Normalized End value %d is not less than Period %d", got.End, tt.interval.Period)
			}
		})
	}
}
