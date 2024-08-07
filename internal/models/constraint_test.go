package models

import (
	"testing"
)

func TestConstraintString(t *testing.T) {
	tests := []struct {
		name       string
		constraint Constraint
		want       string
	}{
		{
			name: "non-periodic interval",
			constraint: Constraint{
				FirstEvent:  1,
				SecondEvent: 2,
				Interval:    Interval{Start: 0, End: 5, Period: 0},
				Symmetry:    false,
			},
			want: "(a[1], a[2]) in [0, 5]",
		},
		{
			name: "periodic interval",
			constraint: Constraint{
				FirstEvent:  3,
				SecondEvent: 4,
				Interval:    Interval{Start: 1, End: 6, Period: 10},
				Symmetry:    true,
			},
			want: "(a[3], a[4]) in [1, 6] period 10",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := tt.constraint.String(); got != tt.want {
				t.Errorf("Constraint.String() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestConstraintIsSatisfied(t *testing.T) {
	tests := []struct {
		name       string
		constraint Constraint
		potentials []int
		want       bool
	}{
		{
			name: "satisfied non-symmetric",
			constraint: Constraint{
				FirstEvent:  0,
				SecondEvent: 1,
				Interval:    Interval{Start: 1, End: 5, Period: 0},
				Symmetry:    false,
			},
			potentials: []int{2, 5},
			want:       true,
		},
		{
			name: "not satisfied non-symmetric",
			constraint: Constraint{
				FirstEvent:  0,
				SecondEvent: 1,
				Interval:    Interval{Start: 1, End: 5, Period: 0},
				Symmetry:    false,
			},
			potentials: []int{2, 8},
			want:       false,
		},
		{
			name: "satisfied symmetric",
			constraint: Constraint{
				FirstEvent:  0,
				SecondEvent: 1,
				Interval:    Interval{Start: 5, End: 10, Period: 0},
				Symmetry:    true,
			},
			potentials: []int{3, 4},
			want:       true,
		},
		{
			name: "not satisfied symmetric",
			constraint: Constraint{
				FirstEvent:  0,
				SecondEvent: 1,
				Interval:    Interval{Start: 5, End: 10, Period: 0},
				Symmetry:    true,
			},
			potentials: []int{3, 8},
			want:       false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := tt.constraint.IsSatisfied(tt.potentials); got != tt.want {
				t.Errorf("Constraint.IsSatisfied() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestConstraintHold(t *testing.T) {
	tests := []struct {
		name       string
		constraint Constraint
		potential  int
		other      int
		want       bool
	}{
		{
			name: "hold non-symmetric",
			constraint: Constraint{
				Interval: Interval{Start: 1, End: 5, Period: 0},
				Symmetry: false,
			},
			potential: 2,
			other:     5,
			want:      true,
		},
		{
			name: "not hold non-symmetric",
			constraint: Constraint{
				Interval: Interval{Start: 1, End: 5, Period: 0},
				Symmetry: false,
			},
			potential: 2,
			other:     8,
			want:      false,
		},
		{
			name: "hold symmetric",
			constraint: Constraint{
				Interval: Interval{Start: 5, End: 10, Period: 0},
				Symmetry: true,
			},
			potential: 3,
			other:     4,
			want:      true,
		},
		{
			name: "not hold symmetric",
			constraint: Constraint{
				Interval: Interval{Start: 5, End: 10, Period: 0},
				Symmetry: true,
			},
			potential: 3,
			other:     8,
			want:      false,
		},
		{
			name: "hold periodic",
			constraint: Constraint{
				Interval: Interval{Start: 1, End: 5, Period: 10},
				Symmetry: false,
			},
			potential: 2,
			other:     14,
			want:      true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := tt.constraint.Hold(tt.potential, tt.other); got != tt.want {
				t.Errorf("Constraint.Hold() = %v, want %v", got, tt.want)
			}
		})
	}
}
