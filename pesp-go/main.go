package main

import (
	"fmt"
	"log"
	"os"

	"github.com/go-air/gini"
	"github.com/go-air/gini/z"
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

	fmt.Println(pen)

	direct := encoding.DirectEncoding{}

	cnf := direct.Encode(pen)

	fmt.Println(cnf)

	g := gini.New()

	for i := range cnf {
		for j := range cnf[i] {
			g.Add(z.Dimacs2Lit(cnf[i][j]))
		}
		g.Add(0)

	}

	if sat := g.Solve(); sat != 1 {
		fmt.Println(sat)
		log.Fatal("error: unsat")
	}

	ans := direct.Decode(pen, g)

	if pen.IsFeasible(ans) {
		fmt.Println(ans)
	} else {
		fmt.Println("Failed")
	}

}
