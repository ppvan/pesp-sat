package encoding

import (
	"errors"
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

type Encoding interface {
	Solve(g *gini.Gini) (models.Schedule, error)
	SolveAll() <-chan models.Schedule
	Stats() *Statistics
}
