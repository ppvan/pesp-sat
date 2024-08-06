package encoding

import (
	"errors"

	"github.com/go-air/gini"
	"github.com/ppvan/pesp-sat/pesp-go/models"
)

type DirectEncoding struct {
	Pen *models.PeriodicEventNetwork
}

func (e *DirectEncoding) Solve(pen *models.PeriodicEventNetwork) (models.Schedule, error) {
	lit := MakeMapper(pen.Period)
	g := gini.New()

	for event := 1; event <= pen.Events; event++ {
		for val := 0; val < pen.Period; val++ {
			g.Add(lit(event, val))
		}
		g.Add(0)

		for val := 0; val < pen.Period; val++ {
			for otherVal := val + 1; otherVal < pen.Period; otherVal++ {
				g.Add(lit(event, val).Not())
				g.Add(lit(event, otherVal).Not())
				g.Add(0)
			}
		}

	}

	for _, con := range pen.Constraints {
		for val := 0; val < pen.Period; val++ {
			for otherVal := 0; otherVal < pen.Period; otherVal++ {
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
		return nil, errors.New("unsat network")
	}

	schedule := make(models.Schedule, pen.Events+1)

	for event := 1; event <= pen.Events; event++ {
		for value := 0; value < pen.Period; value++ {
			if g.Value(lit(event, value)) {
				schedule[event] = value
				break
			}
		}
	}

	return schedule, nil
}
