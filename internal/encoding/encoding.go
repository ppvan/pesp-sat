package encoding

import (
	"errors"

	"github.com/go-air/gini"
	"github.com/go-air/gini/z"
	"github.com/ppvan/pesp-sat/internal/models"
)

type CNF [][]int

var ErrUnSatifiable = errors.New("unsat network")

type Encoding interface {
	Solve(g *gini.Gini) (models.Schedule, error)
	SolveAll() <-chan models.Schedule
}

func MakeMapper(period int) func(int, int) z.Lit {
	return func(index, value int) z.Lit {
		return z.Var((index-1)*period + value + 1).Pos()
	}
}
