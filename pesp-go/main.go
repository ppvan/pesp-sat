package main

import (
	"fmt"
	"log"
	"os"

	"github.com/ppvan/pesp-sat/pesp-go/encoding"
	"github.com/ppvan/pesp-sat/pesp-go/models"
)

func main() {

	file, err := os.Open("../data/simple/test3.txt")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	pen, err := models.ParsePeriodEventNetwork(file)
	if err != nil {
		log.Fatal(err)
	}

	order := encoding.OrderEncoding{
		Pen: pen,
	}

	for ans := range order.SolveAll() {
		fmt.Println(ans, pen.IsFeasible(ans))
	}

}
