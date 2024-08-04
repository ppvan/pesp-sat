package encoding

import (
	"github.com/go-air/gini"
	"github.com/ppvan/pesp-sat/pesp-go/models"
)

type CNF [][]int

type Encoding interface {
	Encode(pen *models.PeriodicEventNetwork) CNF
	Decode(pen *models.PeriodicEventNetwork, g *gini.Gini) []int
}

func MakeMapper(period int) func(int, int) int {
	return func(index, value int) int {
		return (index-1)*period + value + 1
	}
}
