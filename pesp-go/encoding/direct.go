package encoding

import (
	"github.com/go-air/gini"
	"github.com/go-air/gini/z"
	"github.com/ppvan/pesp-sat/pesp-go/models"
)

type DirectEncoding struct {
}

func (e *DirectEncoding) Encode(pen *models.PeriodicEventNetwork) CNF {
	lit := MakeMapper(pen.Period)
	cnf := make(CNF, 0, pen.Events*(1+pen.Period*(pen.Period+1)/2))

	// encode event potentials
	for event := 1; event <= pen.Events; event++ {
		alo := make([]int, pen.Period)
		for val := 0; val < pen.Period; val++ {
			alo[val] = lit(event, val)
		}
		cnf = append(cnf, alo)

		for val := 0; val < pen.Period; val++ {
			for otherVal := val + 1; otherVal < pen.Period; otherVal++ {
				cnf = append(cnf, []int{-lit(event, val), -lit(event, otherVal)})
			}
		}

	}

	// encode constraints

	for _, con := range pen.Constraints {
		for val := 0; val < pen.Period; val++ {
			for otherVal := 0; otherVal < pen.Period; otherVal++ {
				if con.Hold(val, otherVal) {
					continue
				}

				cnf = append(cnf, []int{-lit(con.FirstEvent, val), -lit(con.SecondEvent, otherVal)})
			}
		}

	}

	return cnf
}

func (e *DirectEncoding) Decode(pen *models.PeriodicEventNetwork, g *gini.Gini) []int {
	lit := MakeMapper(pen.Period)
	potentials := make([]int, pen.Events+1)

	for event := 1; event <= pen.Events; event++ {
		for value := 0; value < pen.Period; value++ {
			if g.Value(z.Dimacs2Lit(lit(event, value))) {
				potentials[event] = value
				break
			}
		}
	}

	return potentials
}
