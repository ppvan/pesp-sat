package models

import "fmt"

type Constraint struct {
	FirstEvent  int
	SecondEvent int
	Interval    Interval
	Symmetry    bool
}

func (c Constraint) String() string {
	return fmt.Sprintf("(a[%d], a[%d]) in %s", c.FirstEvent, c.SecondEvent, c.Interval)
}

func (c Constraint) IsSatisfied(potentials []int) bool {
	firstPotential := potentials[c.FirstEvent]
	secondPotential := potentials[c.SecondEvent]

	return c.Hold(firstPotential, secondPotential)
}

func (c Constraint) Hold(potential, other int) bool {
	difference := other - potential
	sum := other + potential

	timeHold := c.Interval.Contains(difference)
	symmetryHold := c.Interval.Contains(sum)

	return (c.Symmetry || timeHold) && (!c.Symmetry || symmetryHold)
}
