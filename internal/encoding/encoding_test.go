package encoding

import (
	"bytes"
	"errors"
	"io"
	"os"
	"path/filepath"
	"testing"
	"time"

	"github.com/go-air/gini"
	"github.com/ppvan/pesp-sat/internal/models"
)

type PenTestCase struct {
	name string
	pen  *models.PeriodicEventNetwork
}

func loadTestData(t *testing.T, dirPath string) []PenTestCase {

	files, err := os.ReadDir(dirPath)

	if err != nil {
		t.Fatalf("Failed to read directory: %v", err)
	}

	var testCases []PenTestCase

	for _, file := range files {
		if file.IsDir() {
			continue
		}

		filePath := filepath.Join(dirPath, file.Name())

		handle, err := os.Open(filePath)
		if err != nil {
			t.Fatalf("Failed to read file: %v", err)
		}
		defer handle.Close()

		pen, err := models.ParsePeriodEventNetwork(handle)

		if err != nil {
			t.Fatalf("Failed to parse file: %v", err)
		}

		testCases = append(testCases, PenTestCase{name: filePath, pen: pen})

	}

	return testCases
}

// MockEncoding implements the Encoding interface for testing
type MockEncoding struct {
	stats     *Statistics
	schedules []models.Schedule
	shouldErr bool
}

func (m *MockEncoding) Solve(g *gini.Gini) (models.Schedule, error) {
	if m.shouldErr {
		return nil, ErrUnSatifiable
	}
	if len(m.schedules) > 0 {
		return m.schedules[0], nil
	}
	return models.Schedule{0, 1, 2}, nil
}

func (m *MockEncoding) SolveAll() <-chan models.Schedule {
	ch := make(chan models.Schedule)
	go func() {
		defer close(ch)
		for _, schedule := range m.schedules {
			ch <- schedule
		}
	}()
	return ch
}

func (m *MockEncoding) Write(g *gini.Gini, dst io.Writer) error {
	if m.shouldErr {
		return errors.New("mock write error")
	}
	return nil
}

func (m *MockEncoding) Stats() *Statistics {
	return m.stats
}

func TestStatisticsString(t *testing.T) {
	tests := []struct {
		name string
		stat Statistics
		want string
	}{
		{
			name: "zero values",
			stat: Statistics{
				MaxVar:    0,
				Clause:    0,
				SolveTime: 0,
			},
			want: "Variables: 0\nClauses: 0\nSolved Time: 0 (ms)",
		},
		{
			name: "typical values",
			stat: Statistics{
				MaxVar:    100,
				Clause:    500,
				SolveTime: 1500 * time.Millisecond,
			},
			want: "Variables: 100\nClauses: 500\nSolved Time: 1500 (ms)",
		},
		{
			name: "large values",
			stat: Statistics{
				MaxVar:    999999,
				Clause:    888888,
				SolveTime: 2 * time.Second,
			},
			want: "Variables: 999999\nClauses: 888888\nSolved Time: 2000 (ms)",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := tt.stat.String(); got != tt.want {
				t.Errorf("Statistics.String() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestEncodingInterface(t *testing.T) {
	// Setup test data
	g := gini.New()
	stats := &Statistics{
		MaxVar:    100,
		Clause:    500,
		SolveTime: time.Second,
	}
	schedules := []models.Schedule{
		{0, 1, 2},
		{0, 2, 4},
	}

	tests := []struct {
		name      string
		encoding  Encoding
		wantErr   bool
		wantStats *Statistics
	}{
		{
			name: "successful solving",
			encoding: &MockEncoding{
				stats:     stats,
				schedules: schedules,
				shouldErr: false,
			},
			wantErr:   false,
			wantStats: stats,
		},
		{
			name: "unsatisfiable error",
			encoding: &MockEncoding{
				stats:     stats,
				schedules: nil,
				shouldErr: true,
			},
			wantErr:   true,
			wantStats: stats,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			// Test Solve method
			schedule, err := tt.encoding.Solve(g)
			if (err != nil) != tt.wantErr {
				t.Errorf("Encoding.Solve() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !tt.wantErr && len(schedule) == 0 {
				t.Error("Encoding.Solve() returned empty schedule when success expected")
			}

			// Test SolveAll method
			ch := tt.encoding.SolveAll()
			var solutions []models.Schedule
			for s := range ch {
				solutions = append(solutions, s)
			}
			if !tt.wantErr && len(solutions) == 0 {
				t.Error("Encoding.SolveAll() returned no solutions when success expected")
			}

			// Test Write method
			var buf bytes.Buffer
			err = tt.encoding.Write(g, &buf)
			if (err != nil) != tt.wantErr {
				t.Errorf("Encoding.Write() error = %v, wantErr %v", err, tt.wantErr)
			}

			// Test Stats method
			gotStats := tt.encoding.Stats()
			if !tt.wantErr && gotStats != tt.wantStats {
				t.Errorf("Encoding.Stats() = %v, want %v", gotStats, tt.wantStats)
			}
		})
	}
}
