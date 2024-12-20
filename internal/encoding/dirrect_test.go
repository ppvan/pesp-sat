package encoding

import (
	"bytes"
	"errors"
	"testing"

	"github.com/go-air/gini"
	"github.com/ppvan/pesp-sat/internal/models"
)

func TestDirectSolveOK(t *testing.T) {
	tests := loadTestData(t, "../../data/test/sat")

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {

			e := DirectEncoding{
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

func TestDirectSolveUnSAT(t *testing.T) {
	tests := loadTestData(t, "../../data/test/unsat")

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {

			e := DirectEncoding{
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

func TestDirectEncoding_SolveAll(t *testing.T) {
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

	e := &DirectEncoding{
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
		t.Error("DirectEncoding.SolveAll() returned no solutions")
	}

	for i, schedule := range solutions {
		if !pen.IsFeasible(schedule) {
			t.Errorf("Solution %d is not feasible: %v", i, schedule)
		}
	}
}

func TestDirectEncoding_Write(t *testing.T) {
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

	e := &DirectEncoding{
		Pen: pen,
	}

	g := gini.New()
	var buf bytes.Buffer
	err := e.Write(g, &buf)
	if err != nil {
		t.Errorf("DirectEncoding.Write() error = %v", err)
	}

	if buf.Len() == 0 {
		t.Error("DirectEncoding.Write() wrote no data")
	}
}
