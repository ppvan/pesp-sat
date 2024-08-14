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

	for index, value := range schedule {
		if index == 0 {
			continue
		}

		fmt.Printf("%d;%d\n", index, value)
	}

	fmt.Println(encode.Stats())

	return nil
}
