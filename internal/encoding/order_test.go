package encoding

import (
	"errors"
	"testing"

	"github.com/go-air/gini"
)

func TestOrderSolveOK(t *testing.T) {
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

func TestOrderSolveUnSAT(t *testing.T) {
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
