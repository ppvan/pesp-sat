package encoding

import (
	"errors"
	"math"

	"github.com/go-air/gini"
	"github.com/go-air/gini/z"
	"github.com/ppvan/pesp-sat/pesp-go/models"
)

type Rect [4]int

type OrderEncoding struct {
	Pen *models.PeriodicEventNetwork
}

func (e *OrderEncoding) Solve(g *gini.Gini) (models.Schedule, error) {

	lit := func(index, value int) z.Lit {
		return z.Var((index-1)*(e.Pen.Period-1) + value + 1).Pos()
	}

	for event := 1; event <= e.Pen.Events; event++ {
		for value := 1; value < e.Pen.Period-1; value++ {
			g.Add(lit(event, value-1).Not())
			g.Add(lit(event, value))
			g.Add(0)
		}
	}

	if sat := g.Solve(); sat != 1 {
		return nil, errors.New("unsat network")
	}

	schedule := make(models.Schedule, e.Pen.Events+1)

	for event := 1; event <= e.Pen.Events; event++ {
		schedule[event] = 0
		for value := e.Pen.Period - 2; value >= 0; value-- {
			if !g.Value(lit(event, value)) {
				schedule[event] = value + 1
				break
			}
		}
	}

	return schedule, nil
}

func (e *OrderEncoding) SolveAll() <-chan models.Schedule {
	g := gini.New()
	schedules := make(chan models.Schedule)

	go func() {
		schedule, err := e.Solve(g)
		if err != nil {
			close(schedules)
			return
		}
		schedules <- schedule

		for {
			max := g.MaxVar()
			for axiom := z.Var(1); axiom <= max; axiom++ {
				if g.Value(axiom.Pos()) {
					g.Add(axiom.Neg())
				} else {
					g.Add(axiom.Pos())
				}
			}
			g.Add(0)
			if sat := g.Solve(); sat != 1 {
				close(schedules)
				return
			}

			schedule := e.infer(g)
			schedules <- schedule
		}
	}()

	return schedules
}

func deltaX(l, u int) int {
	return int(math.Ceil(float64(0.5)*float64(l-u-1))) - 1
}

func deltaY(l, u int) int {
	return int(math.Floor(float64(0.5) * float64(l-u-1)))
}

func timePhi(l, u, period int) []Rect {
	delta_x := deltaX(l, u)
	delta_y := deltaY(l, u)
	u_plus_1 := u + 1

	rects := make([]Rect, 1)

	for y1 := -delta_y; y1 < period; y1++ {
		x1 := y1 - u_plus_1 - delta_x
		if x1+delta_x >= 0 && x1 < period {
			rects = append(rects, Rect{x1, x1 + delta_x, y1, y1 + delta_y})
		}
	}

	return rects
}

func (e *OrderEncoding) infer(g *gini.Gini) models.Schedule {
	schedule := make(models.Schedule, e.Pen.Events+1)
	lit := func(index, value int) z.Lit {
		return z.Var((index-1)*(e.Pen.Period-1) + value + 1).Pos()
	}
	for event := 1; event <= e.Pen.Events; event++ {
		schedule[event] = 0
		for value := e.Pen.Period - 2; value >= 0; value-- {
			if !g.Value(lit(event, value)) {
				schedule[event] = value + 1
				break
			}
		}
	}

	return schedule
}
