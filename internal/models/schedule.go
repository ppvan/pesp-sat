package models

import (
	"fmt"
	"strings"
)

type Schedule []int

func (s Schedule) String() string {

	var buffer strings.Builder

	for index, value := range s {
		if index == 0 {
			continue
		}

		line := fmt.Sprintf("%v;%v\n", index, value)
		buffer.WriteString(line)
	}

	return buffer.String()
}
