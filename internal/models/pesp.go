package models

import (
	"bufio"
	"errors"
	"fmt"
	"io"
	"strconv"
	"strings"
)

// PeriodicEventNetwork represents a network of periodic events
type PeriodicEventNetwork struct {
	Events      int
	Constraints []Constraint
	Period      int
}

func (pen PeriodicEventNetwork) String() string {
	result := fmt.Sprintf("Periodic Event Network:\nNumber of events: %d\nPeriod: %d\nConstraints:\n", pen.Events, pen.Period)
	for _, c := range pen.Constraints {
		result += c.String() + "\n"
	}
	return result
}

func (pen PeriodicEventNetwork) IsFeasible(schedule Schedule) bool {
	if len(schedule) != pen.Events+1 {
		panic(fmt.Sprintf("Schedule must have exactly %d + 1 events", pen.Events))
	}

	for _, constraint := range pen.Constraints {
		if !constraint.IsSatisfied(schedule) {
			fmt.Println(constraint)
			return false
		}
	}
	return true
}

func (pen *PeriodicEventNetwork) Objective(schedule Schedule) uint64 {

	sum := uint64(0)

	for _, con := range pen.Constraints {
		sum += uint64(con.Weight) * uint64(schedule[con.SecondEvent]-schedule[con.FirstEvent]-con.Interval.Start)
	}

	return sum
}

func ParsePeriodEventNetwork(file io.Reader) (*PeriodicEventNetwork, error) {
	scanner := bufio.NewScanner(file)

	// scan network info from firstline
	scanner.Scan()
	firstLine := strings.Fields(scanner.Text())
	if len(firstLine) < 3 {
		return nil, errors.New("error parse firstline, expect 3 integers")
	}

	events, err := strconv.Atoi(firstLine[1])
	if err != nil {
		return nil, err
	}

	period, err := strconv.Atoi(firstLine[2])
	if err != nil {
		return nil, err
	}

	var constraints []Constraint
	for scanner.Scan() {
		line := scanner.Text()
		if strings.HasPrefix(line, "#") {
			continue
		}

		parts := strings.Split(line, "; ")
		if len(parts) == 6 {
			first, second, start, end, weight, err := parseInts(parts)

			if err != nil {
				return nil, err
			}
			con := Constraint{
				FirstEvent:  first,
				SecondEvent: second,
				Interval: Interval{
					Start:  start,
					End:    end,
					Period: period,
				}.Normalized(),
				Weight: weight,
			}
			constraints = append(constraints, con)
		}
	}

	return &PeriodicEventNetwork{
		Events:      events,
		Constraints: constraints,
		Period:      period,
	}, nil
}

func parseInts(nums []string) (int, int, int, int, int, error) {
	result := make([]int, 6)
	for i, v := range nums {
		if i >= 6 {
			break
		}
		num, err := strconv.Atoi(v)
		if err != nil {
			return 0, 0, 0, 0, 0, err
		}
		result[i] = num
	}
	return result[1], result[2], result[3], result[4], result[5], nil
}
