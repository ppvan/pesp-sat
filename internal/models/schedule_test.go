package models

import (
	"strings"
	"testing"
)

func TestScheduleString(t *testing.T) {
	tests := []struct {
		name     string
		schedule Schedule
		want     string
	}{
		{
			name:     "empty schedule",
			schedule: Schedule{},
			want:     "",
		},
		{
			name:     "schedule with single zero element",
			schedule: Schedule{0},
			want:     "",
		},
		{
			name:     "schedule with multiple elements",
			schedule: Schedule{0, 10, 20, 30},
			want:     "1;10\n2;20\n3;30\n",
		},
		{
			name:     "schedule with zero values after index 0",
			schedule: Schedule{0, 0, 0, 0},
			want:     "1;0\n2;0\n3;0\n",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := tt.schedule.String()
			if got != tt.want {
				t.Errorf("Schedule.String() = %q, want %q", got, tt.want)
			}

			// Additional check for no trailing whitespace
			if strings.TrimSpace(got) != strings.TrimSpace(tt.want) {
				t.Errorf("Schedule.String() contains unexpected whitespace")
			}
		})
	}
}
