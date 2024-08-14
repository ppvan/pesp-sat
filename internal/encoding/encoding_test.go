package encoding

import (
	"os"
	"path/filepath"
	"testing"

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
