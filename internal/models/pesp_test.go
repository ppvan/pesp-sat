package models

import (
	"reflect"
	"strings"
	"testing"
)

func TestPeriodicEventNetworkString(t *testing.T) {
	pen := PeriodicEventNetwork{
		Events: 3,
		Period: 60,
		Constraints: []Constraint{
			{
				FirstEvent:  1,
				SecondEvent: 2,
				Interval:    Interval{Start: 10, End: 20, Period: 60},
				Weight:      1,
			},
		},
	}

	expected := "Periodic Event Network:\nNumber of events: 3\nPeriod: 60\nConstraints:\n(a[1], a[2]) in [10, 20] period 60\n"
	if got := pen.String(); got != expected {
		t.Errorf("PeriodicEventNetwork.String() = %v, want %v", got, expected)
	}
}

func TestPeriodicEventNetworkIsFeasible(t *testing.T) {
	tests := []struct {
		name      string
		pen       PeriodicEventNetwork
		schedule  Schedule
		want      bool
		wantPanic bool
	}{
		{
			name: "valid schedule",
			pen: PeriodicEventNetwork{
				Events: 2,
				Period: 60,
				Constraints: []Constraint{
					{
						FirstEvent:  1,
						SecondEvent: 2,
						Interval:    Interval{Start: 10, End: 20, Period: 60},
						Weight:      1,
					},
				},
			},
			schedule:  Schedule{0, 0, 15}, // 3 events (including 0)
			want:      true,
			wantPanic: false,
		},
		{
			name: "invalid schedule - constraint not satisfied",
			pen: PeriodicEventNetwork{
				Events: 2,
				Period: 60,
				Constraints: []Constraint{
					{
						FirstEvent:  1,
						SecondEvent: 2,
						Interval:    Interval{Start: 10, End: 20, Period: 60},
						Weight:      1,
					},
				},
			},
			schedule:  Schedule{0, 0, 5}, // difference too small
			want:      false,
			wantPanic: false,
		},
		{
			name: "invalid schedule length",
			pen: PeriodicEventNetwork{
				Events:      2,
				Period:      60,
				Constraints: []Constraint{},
			},
			schedule:  Schedule{0, 0}, // too short
			want:      false,
			wantPanic: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if tt.wantPanic {
				defer func() {
					if r := recover(); r == nil {
						t.Errorf("Expected panic but got none")
					}
				}()
			}

			if got := tt.pen.IsFeasible(tt.schedule); got != tt.want {
				t.Errorf("PeriodicEventNetwork.IsFeasible() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestPeriodicEventNetworkObjective(t *testing.T) {
	pen := PeriodicEventNetwork{
		Events: 2,
		Period: 60,
		Constraints: []Constraint{
			{
				FirstEvent:  1,
				SecondEvent: 2,
				Interval:    Interval{Start: 10, End: 20, Period: 60},
				Weight:      2,
			},
		},
	}

	tests := []struct {
		name     string
		schedule Schedule
		want     uint64
	}{
		{
			name:     "basic calculation",
			schedule: Schedule{0, 5, 20},
			want:     10, // (20 - 5 - 10)
		},
		{
			name:     "zero difference",
			schedule: Schedule{0, 10, 20},
			want:     0, // (20 - 10 - 10)
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := pen.Objective(tt.schedule); got != tt.want {
				t.Errorf("PeriodicEventNetwork.Objective() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestParsePeriodEventNetwork(t *testing.T) {
	tests := []struct {
		name    string
		input   string
		want    *PeriodicEventNetwork
		wantErr bool
	}{
		{
			name: "valid input",
			input: `PESP 2 60
1; 1; 2; 10; 20; 1
`,
			want: &PeriodicEventNetwork{
				Events: 2,
				Period: 60,
				Constraints: []Constraint{
					{
						FirstEvent:  1,
						SecondEvent: 2,
						Interval:    Interval{Start: 10, End: 20, Period: 60},
						Weight:      1,
					},
				},
			},
			wantErr: false,
		},
		{
			name: "invalid first line",
			input: `PESP
1; 1; 2; 10; 20; 1`,
			want:    nil,
			wantErr: true,
		},
		{
			name: "comment lines",
			input: `PESP 2 60
# This is a comment
1; 1; 2; 10; 20; 1
`,
			want: &PeriodicEventNetwork{
				Events: 2,
				Period: 60,
				Constraints: []Constraint{
					{
						FirstEvent:  1,
						SecondEvent: 2,
						Interval:    Interval{Start: 10, End: 20, Period: 60},
						Weight:      1,
					},
				},
			},
			wantErr: false,
		},
		{
			name: "invalid constraint format",
			input: `PESP 2 60
1; 1; 2; invalid; 20; 1`,
			want:    nil,
			wantErr: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			reader := strings.NewReader(tt.input)
			got, err := ParsePeriodEventNetwork(reader)

			if (err != nil) != tt.wantErr {
				t.Errorf("ParsePeriodEventNetwork() error = %v, wantErr %v", err, tt.wantErr)
				return
			}

			if !tt.wantErr && !reflect.DeepEqual(got, tt.want) {
				t.Errorf("ParsePeriodEventNetwork() = %+v, want %+v", got, tt.want)
			}
		})
	}
}

func TestParseInts(t *testing.T) {
	tests := []struct {
		name    string
		input   []string
		want1   int
		want2   int
		want3   int
		want4   int
		want5   int
		wantErr bool
	}{
		{
			name:    "valid input",
			input:   []string{"0", "1", "2", "3", "4", "5"},
			want1:   1,
			want2:   2,
			want3:   3,
			want4:   4,
			want5:   5,
			wantErr: false,
		},
		{
			name:    "invalid number",
			input:   []string{"0", "invalid", "2", "3", "4", "5"},
			wantErr: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got1, got2, got3, got4, got5, err := parseInts(tt.input)
			if (err != nil) != tt.wantErr {
				t.Errorf("parseInts() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !tt.wantErr {
				if got1 != tt.want1 || got2 != tt.want2 || got3 != tt.want3 || got4 != tt.want4 || got5 != tt.want5 {
					t.Errorf("parseInts() = (%v, %v, %v, %v, %v), want (%v, %v, %v, %v, %v)",
						got1, got2, got3, got4, got5,
						tt.want1, tt.want2, tt.want3, tt.want4, tt.want5)
				}
			}
		})
	}
}
