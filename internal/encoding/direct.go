package encoding

import (
	"github.com/go-air/gini"
	"github.com/go-air/gini/z"
	"github.com/ppvan/pesp-sat/internal/models"
)

type DirectEncoding struct {
	Pen *models.PeriodicEventNetwork
}

func (e *DirectEncoding) Solve(g *gini.Gini) (models.Schedule, error) {

	lit := MakeMapper(e.Pen.Period)

	for event := 1; event <= e.Pen.Events; event++ {
		for val := 0; val < e.Pen.Period; val++ {
			g.Add(lit(event, val))
		}
		g.Add(0)

		for val := 0; val < e.Pen.Period; val++ {
			for otherVal := val + 1; otherVal < e.Pen.Period; otherVal++ {
				g.Add(lit(event, val).Not())
				g.Add(lit(event, otherVal).Not())
				g.Add(0)
			}
		}

	}

	for _, con := range e.Pen.Constraints {
		for val := 0; val < e.Pen.Period; val++ {
			for otherVal := 0; otherVal < e.Pen.Period; otherVal++ {
				if con.Hold(val, otherVal) {
					continue
				}

				g.Add(lit(con.FirstEvent, val).Not())
				g.Add(lit(con.SecondEvent, otherVal).Not())
				g.Add(0)
			}
		}

	}

	if sat := g.Solve(); sat != 1 {
		return nil, ErrUnSatifiable
	}

	schedule := make(models.Schedule, e.Pen.Events+1)

	for event := 1; event <= e.Pen.Events; event++ {
		for value := 0; value < e.Pen.Period; value++ {
			if g.Value(lit(event, value)) {
				schedule[event] = value
				break
			}
		}
	}

	return schedule, nil
}

func (e *DirectEncoding) SolveAll() <-chan models.Schedule {
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

func (e *DirectEncoding) infer(g *gini.Gini) models.Schedule {
	schedule := make(models.Schedule, e.Pen.Events+1)
	lit := func(index, value int) z.Lit {
		return z.Var((index-1)*(e.Pen.Period-1) + value + 1).Pos()
	}
	for event := 1; event <= e.Pen.Events; event++ {
		for value := 0; value < e.Pen.Period; value++ {
			if g.Value(lit(event, value)) {
				schedule[event] = value
				break
			}
		}
	}

	return schedule
}
