package main

import (
	"fmt"
	"log"
	"os"
	"time"

	"github.com/urfave/cli/v2"
)

func main() {

	app := cli.App{
		Name:     "pesp-sat",
		Usage:    "Run test and benmark PESP",
		Version:  "v0.1.0",
		Compiled: time.Now(),
		Authors: []*cli.Author{
			{
				Name:  "ppvan",
				Email: "phuclaplace@gmail.com",
			},
		},
		EnableBashCompletion: true,
		Commands: []*cli.Command{
			{
				Name:    "solve",
				Aliases: []string{"s"},
				Usage:   "Solve a PESP instance file",
				Flags: []cli.Flag{
					&cli.StringFlag{
						Name:    "encoding",
						Aliases: []string{"d"},
						Usage:   "Specify encoding to use",
						Value:   "order",
						Action: func(ctx *cli.Context, s string) error {
							if s != "order" && s != "direct" {
								return fmt.Errorf("flag encoding unsupported encoding, expect [order, direct] got %v", s)
							}

							return nil
						},
					},
				},
				Action: solve,
			},
			{
				Name:  "benmark",
				Usage: "Solve a PESP instance and output statistics",
			},
		},
	}

	if err := app.Run(os.Args); err != nil {
		log.Fatal(err)
	}

}
