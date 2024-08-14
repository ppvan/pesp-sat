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
		Usage:    "Solve PESP instance file",
		Version:  "v0.1.0",
		Compiled: time.Now(),
		Authors: []*cli.Author{
			{
				Name: "ppvan",
			},
		},
		EnableBashCompletion: true,
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
			&cli.BoolFlag{
				Name:    "stats",
				Aliases: []string{"s"},
				Usage:   "Statistics mode, output only statistics (not solution)",
				Value:   false,
			},
		},
		Action: solve,
	}

	if err := app.Run(os.Args); err != nil {
		log.Fatal(err)
	}

}
