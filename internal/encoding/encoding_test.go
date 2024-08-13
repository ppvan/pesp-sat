package encoding

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/go-air/gini/z"
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

func TestMakeMapper(t *testing.T) {
	// Test cases
	testCases := []struct {
		period   int
		index    int
		value    int
		expected z.Lit
	}{
		{3, 1, 0, z.Lit(2)},
		{3, 1, 1, z.Lit(3)},
		{3, 1, 2, z.Lit(4)},
		{3, 2, 0, z.Lit(5)},
		{3, 2, 1, z.Lit(6)},
		{3, 2, 2, z.Lit(7)},
		{5, 1, 0, z.Lit(2)},
		{5, 1, 4, z.Lit(6)},
		{5, 2, 0, z.Lit(7)},
		{5, 2, 4, z.Lit(11)},
	}

	for _, tc := range testCases {
		mapper := MakeMapper(tc.period)
		result := mapper(tc.index, tc.value)

		if result != tc.expected {
			t.Errorf("MakeMapper(%d)(%d, %d) = %v; want %v",
				tc.period, tc.index, tc.value, result, tc.expected)
		}
	}
}
