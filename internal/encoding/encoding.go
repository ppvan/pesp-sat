package encoding

import (
	"errors"
	"io"

	"github.com/go-air/gini/z"
	"github.com/ppvan/pesp-sat/internal/models"
)

type CNF [][]int

var ErrUnSatifiable = errors.New("unsat network")

type Encoding interface {
	Solve() models.Schedule
	SolveAll() []models.Schedule
	WriteCNF(dst io.Writer) error
}

func MakeMapper(period int) func(int, int) z.Lit {
	return func(index, value int) z.Lit {
		return z.Var((index-1)*period + value + 1).Pos()
	}
}
