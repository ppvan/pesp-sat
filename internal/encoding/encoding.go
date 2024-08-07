package encoding

import (
	"io"

	"github.com/go-air/gini"
	"github.com/go-air/gini/z"
	"github.com/ppvan/pesp-sat/internal/models"
)

type CNF [][]int

type Encoding interface {
	Encode(pen *models.PeriodicEventNetwork) CNF
	Decode(pen *models.PeriodicEventNetwork, g *gini.Gini) models.Schedule
	Solve() models.Schedule
	SolveAll() []models.Schedule
	WriteCNF(dst io.Writer) error
}

func MakeMapper(period int) func(int, int) z.Lit {
	return func(index, value int) z.Lit {
		return z.Var((index-1)*period + value + 1).Pos()
	}
}
