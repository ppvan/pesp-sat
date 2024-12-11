package main

import (
	"errors"
	"fmt"
	"os"

	"github.com/go-air/gini"
	"github.com/ppvan/pesp-sat/internal/encoding"
	"github.com/ppvan/pesp-sat/internal/models"
	"github.com/urfave/cli/v2"
)

func solve(ctx *cli.Context) error {
	if ctx.NArg() == 0 {
		return fmt.Errorf("please provide a file path")
	}

	path := ctx.Args().Get(0)

	file, err := os.Open(path)
	if os.IsNotExist(err) {
		return fmt.Errorf("file does not exist: %s", path)
	}

	defer file.Close()

	pen, err := models.ParsePeriodEventNetwork(file)
	if err != nil {
		return err
	}
	g := gini.New()

	var encode encoding.Encoding

	if ctx.String("encoding") == "order" {
		encode = &encoding.OrderEncoding{
			Pen: pen,
		}
	} else if ctx.String("encoding") == "direct" {
		encode = &encoding.DirectEncoding{
			Pen: pen,
		}
	}

	schedule, err := encode.Solve(g)
	if err != nil {
		return err
	}

	if !pen.IsFeasible(schedule) {
		return errors.New("verification failed, solver made a mistake")
	}

	fmt.Print(schedule)

	return nil
}

func benmark(ctx *cli.Context) error {
	if ctx.NArg() == 0 {
		return fmt.Errorf("please provide a file path")
	}

	path := ctx.Args().Get(0)

	file, err := os.Open(path)
	if os.IsNotExist(err) {
		return fmt.Errorf("file does not exist: %s", path)
	}

	defer file.Close()

	pen, err := models.ParsePeriodEventNetwork(file)
	if err != nil {
		return err
	}
	g := gini.New()

	var encode encoding.Encoding

	if ctx.String("encoding") == "order" {
		encode = &encoding.OrderEncoding{
			Pen: pen,
		}
	} else if ctx.String("encoding") == "direct" {
		encode = &encoding.DirectEncoding{
			Pen: pen,
		}
	}

	schedule, err := encode.Solve(g)
	if err != nil {
		return err
	}

	if !pen.IsFeasible(schedule) {
		return errors.New("verification failed, solver made a mistake")
	}

	fmt.Print(encode.Stats())
	return nil
}

func encode(ctx *cli.Context) error {
	if ctx.NArg() == 0 {
		return fmt.Errorf("please provide a file path")
	}

	path := ctx.Args().Get(0)

	file, err := os.Open(path)
	if os.IsNotExist(err) {
		return fmt.Errorf("file does not exist: %s", path)
	}

	defer file.Close()

	pen, err := models.ParsePeriodEventNetwork(file)
	if err != nil {
		return err
	}
	g := gini.New()

	var encode encoding.Encoding

	if ctx.String("encoding") == "order" {
		encode = &encoding.OrderEncoding{
			Pen: pen,
		}
	} else if ctx.String("encoding") == "direct" {
		encode = &encoding.DirectEncoding{
			Pen: pen,
		}
	}

	return encode.Write(g, os.Stdout)
}

func dimacs(ctx *cli.Context) error {
	if ctx.NArg() == 0 {
		return fmt.Errorf("please provide a file path")
	}

	path := ctx.Args().Get(0)

	file, err := os.Open(path)
	if os.IsNotExist(err) {
		return fmt.Errorf("file does not exist: %s", path)
	}

	defer file.Close()

	g, err := gini.NewDimacs(file)

	if err != nil {
		return err
	}

	sat := g.Solve()

	if sat == 1 {
		fmt.Println("SAT")
	} else {
		fmt.Println("UNSAT")
	}

	return nil
}
