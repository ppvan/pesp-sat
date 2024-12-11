package encoding

import (
	"errors"
	"fmt"
	"io"
	"time"

	"github.com/go-air/gini"
	"github.com/ppvan/pesp-sat/internal/models"
)

type CNF [][]int

var ErrUnSatifiable = errors.New("unsat network")

type Statistics struct {
	MaxVar    uint64
	Clause    uint64
	SolveTime time.Duration
}

func (s *Statistics) String() string {

	return fmt.Sprintf("Variables: %v\nClauses: %v\nSolved Time: %v (ms)", s.MaxVar, s.Clause, s.SolveTime.Milliseconds())
}

type Encoding interface {
	Solve(g *gini.Gini) (models.Schedule, error)
	SolveAll() <-chan models.Schedule
	Write(g *gini.Gini, dst io.Writer) error
	Stats() *Statistics
}
