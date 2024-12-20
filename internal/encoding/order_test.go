package encoding

import (
	"bytes"
	"errors"
	"reflect"
	"testing"
	"time"

	"github.com/go-air/gini"
	"github.com/ppvan/pesp-sat/internal/models"
)

func TestOrderSolveOK(t *testing.T) {
	tests := loadTestData(t, "../../data/test/sat")

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {

			e := OrderEncoding{
				Pen: tt.pen,
			}

			schedule, err := e.Solve(gini.New())

			if err != nil {
				t.Errorf("Expect schedule, got unsatable")
			}

			if !e.Pen.IsFeasible(schedule) {
				t.Errorf("Schdule %v not valid", schedule)
			}
		})
	}
}

func TestOrderSolveUnSAT(t *testing.T) {
	tests := loadTestData(t, "../../data/test/unsat")

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {

			e := OrderEncoding{
				Pen: tt.pen,
			}

			_, err := e.Solve(gini.New())

			if err == nil {
				t.Errorf("Expect unsatable, got solveable prolem")
			}

			if !errors.Is(ErrUnSatifiable, err) {
				t.Errorf("Expect unsatable error, got %v", err)
			}
		})
	}
}

func TestDeltaX(t *testing.T) {
	tests := []struct {
		name string
		l    int
		u    int
		want int
	}{
		{
			name: "simple case",
			l:    10,
			u:    5,
			want: 1,
		},
		{
			name: "equal values",
			l:    5,
			u:    5,
			want: -1,
		},
		{
			name: "negative difference",
			l:    5,
			u:    10,
			want: -4,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := deltaX(tt.l, tt.u); got != tt.want {
				t.Errorf("deltaX() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestDeltaY(t *testing.T) {
	tests := []struct {
		name string
		l    int
		u    int
		want int
	}{
		{
			name: "simple case",
			l:    10,
			u:    5,
			want: 2,
		},
		{
			name: "equal values",
			l:    5,
			u:    5,
			want: -1,
		},
		{
			name: "negative difference",
			l:    5,
			u:    10,
			want: -3,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := deltaY(tt.l, tt.u); got != tt.want {
				t.Errorf("deltaY() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestTimePhi(t *testing.T) {
	tests := []struct {
		name   string
		l      int
		u      int
		period int
		want   []Rect
	}{
		{
			name:   "simple case",
			l:      10,
			u:      5,
			period: 15,
			want: []Rect{
				{-1, 0, 6, 8},
				{0, 1, 7, 9},
				{1, 2, 8, 10},
				{2, 3, 9, 11},
				{3, 4, 10, 12},
				{4, 5, 11, 13},
				{5, 6, 12, 14},
				{6, 7, 13, 15},
				{7, 8, 14, 16},
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := timePhi(tt.l, tt.u, tt.period)
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("timePhi() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestUnfeasibleRegion(t *testing.T) {
	tests := []struct {
		name       string
		constraint models.Constraint
		want       []Rect
	}{
		{
			name: "simple constraint",
			constraint: models.Constraint{
				FirstEvent:  1,
				SecondEvent: 2,
				Interval: models.Interval{
					Start:  10,
					End:    20,
					Period: 60,
				},
				Weight: 1,
			},
			want: []Rect{
				{51, 75, -24, 0},
				{52, 76, -23, 1},
				{53, 77, -22, 2},
				{54, 78, -21, 3},
				{55, 79, -20, 4},
				{56, 80, -19, 5},
				{57, 81, -18, 6},
				{58, 82, -17, 7},
				{59, 83, -16, 8},
				{-9, 15, -24, 0},
				{-8, 16, -23, 1},
				{-7, 17, -22, 2},
				{-6, 18, -21, 3},
				{-5, 19, -20, 4},
				{-4, 20, -19, 5},
				{-3, 21, -18, 6},
				{-2, 22, -17, 7},
				{-1, 23, -16, 8},
				{0, 24, -15, 9},
				{1, 25, -14, 10},
				{2, 26, -13, 11},
				{3, 27, -12, 12},
				{4, 28, -11, 13},
				{5, 29, -10, 14},
				{6, 30, -9, 15},
				{7, 31, -8, 16},
				{8, 32, -7, 17},
				{9, 33, -6, 18},
				{10, 34, -5, 19},
				{11, 35, -4, 20},
				{12, 36, -3, 21},
				{13, 37, -2, 22},
				{14, 38, -1, 23},
				{15, 39, 0, 24},
				{16, 40, 1, 25},
				{17, 41, 2, 26},
				{18, 42, 3, 27},
				{19, 43, 4, 28},
				{20, 44, 5, 29},
				{21, 45, 6, 30},
				{22, 46, 7, 31},
				{23, 47, 8, 32},
				{24, 48, 9, 33},
				{25, 49, 10, 34},
				{26, 50, 11, 35},
				{27, 51, 12, 36},
				{28, 52, 13, 37},
				{29, 53, 14, 38},
				{30, 54, 15, 39},
				{31, 55, 16, 40},
				{32, 56, 17, 41},
				{33, 57, 18, 42},
				{34, 58, 19, 43},
				{35, 59, 20, 44},
				{36, 60, 21, 45},
				{37, 61, 22, 46},
				{38, 62, 23, 47},
				{39, 63, 24, 48},
				{40, 64, 25, 49},
				{41, 65, 26, 50},
				{42, 66, 27, 51},
				{43, 67, 28, 52},
				{44, 68, 29, 53},
				{45, 69, 30, 54},
				{46, 70, 31, 55},
				{47, 71, 32, 56},
				{48, 72, 33, 57},
				{49, 73, 34, 58},
				{50, 74, 35, 59},
				{51, 75, 36, 60},
				{52, 76, 37, 61},
				{53, 77, 38, 62},
				{54, 78, 39, 63},
				{55, 79, 40, 64},
				{56, 80, 41, 65},
				{57, 81, 42, 66},
				{58, 82, 43, 67},
				{59, 83, 44, 68},
				{-24, 0, 21, 45},
				{-23, 1, 22, 46},
				{-22, 2, 23, 47},
				{-21, 3, 24, 48},
				{-20, 4, 25, 49},
				{-19, 5, 26, 50},
				{-18, 6, 27, 51},
				{-17, 7, 28, 52},
				{-16, 8, 29, 53},
				{-15, 9, 30, 54},
				{-14, 10, 31, 55},
				{-13, 11, 32, 56},
				{-12, 12, 33, 57},
				{-11, 13, 34, 58},
				{-10, 14, 35, 59},
				{-9, 15, 36, 60},
				{-8, 16, 37, 61},
				{-7, 17, 38, 62},
				{-6, 18, 39, 63},
				{-5, 19, 40, 64},
				{-4, 20, 41, 65},
				{-3, 21, 42, 66},
				{-2, 22, 43, 67},
				{-1, 23, 44, 68},
				{0, 24, 45, 69},
				{1, 25, 46, 70},
				{2, 26, 47, 71},
				{3, 27, 48, 72},
				{4, 28, 49, 73},
				{5, 29, 50, 74},
				{6, 30, 51, 75},
				{7, 31, 52, 76},
				{8, 32, 53, 77},
				{9, 33, 54, 78},
				{10, 34, 55, 79},
				{11, 35, 56, 80},
				{12, 36, 57, 81},
				{13, 37, 58, 82},
				{14, 38, 59, 83},
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := unfeasibleRegion(tt.constraint)
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("unfeasibleRegion() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestOrderEncoding_Solve(t *testing.T) {
	pen := &models.PeriodicEventNetwork{
		Events: 2,
		Period: 60,
		Constraints: []models.Constraint{
			{
				FirstEvent:  1,
				SecondEvent: 2,
				Interval: models.Interval{
					Start:  10,
					End:    20,
					Period: 60,
				},
				Weight: 1,
			},
		},
	}

	tests := []struct {
		name    string
		pen     *models.PeriodicEventNetwork
		wantErr bool
	}{
		{
			name:    "satisfiable network",
			pen:     pen,
			wantErr: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			e := &OrderEncoding{
				Pen: tt.pen,
			}
			g := gini.New()
			got, err := e.Solve(g)
			if (err != nil) != tt.wantErr {
				t.Errorf("OrderEncoding.Solve() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !tt.wantErr {
				if len(got) != tt.pen.Events+1 {
					t.Errorf("OrderEncoding.Solve() returned schedule of length %v, want %v", len(got), tt.pen.Events+1)
				}
				if !tt.pen.IsFeasible(got) {
					t.Errorf("OrderEncoding.Solve() returned infeasible schedule %v", got)
				}
			}
		})
	}
}

func TestOrderEncoding_SolveAll(t *testing.T) {
	pen := &models.PeriodicEventNetwork{
		Events: 2,
		Period: 60,
		Constraints: []models.Constraint{
			{
				FirstEvent:  1,
				SecondEvent: 2,
				Interval: models.Interval{
					Start:  10,
					End:    20,
					Period: 60,
				},
				Weight: 1,
			},
		},
	}

	e := &OrderEncoding{
		Pen: pen,
	}

	solutions := make([]models.Schedule, 0)
	for schedule := range e.SolveAll() {
		solutions = append(solutions, schedule)
		if len(solutions) >= 5 { // Limit to first 5 solutions for testing
			break
		}
	}

	if len(solutions) == 0 {
		t.Error("OrderEncoding.SolveAll() returned no solutions")
	}

	for i, schedule := range solutions {
		if !pen.IsFeasible(schedule) {
			t.Errorf("Solution %d is not feasible: %v", i, schedule)
		}
	}
}

func TestOrderEncoding_Write(t *testing.T) {
	pen := &models.PeriodicEventNetwork{
		Events: 2,
		Period: 60,
		Constraints: []models.Constraint{
			{
				FirstEvent:  1,
				SecondEvent: 2,
				Interval: models.Interval{
					Start:  10,
					End:    20,
					Period: 60,
				},
				Weight: 1,
			},
		},
	}

	e := &OrderEncoding{
		Pen: pen,
	}

	g := gini.New()
	var buf bytes.Buffer
	err := e.Write(g, &buf)
	if err != nil {
		t.Errorf("OrderEncoding.Write() error = %v", err)
	}

	if buf.Len() == 0 {
		t.Error("OrderEncoding.Write() wrote no data")
	}
}

func TestOrderEncoding_Stats(t *testing.T) {
	e := &OrderEncoding{
		maxVar:    100,
		clause:    500,
		solveTime: time.Second,
	}

	stats := e.Stats()
	if stats.MaxVar != 100 || stats.Clause != 500 || stats.SolveTime != time.Second {
		t.Errorf("OrderEncoding.Stats() = %+v, want {MaxVar:100, Clause:500, SolveTime:1s}", stats)
	}
}
