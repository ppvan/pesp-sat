Certainly. I'll update the README with the GPLv3 license and include the example you provided. Here's the revised README:

# Pesp SAT

> Try to solve PESP (Periodic Event Scheduling Problem) in SAT.

## Description

Pesp SAT is a command-line tool designed to solve and benchmark instances of the Periodic Event Scheduling Problem (PESP) using SAT (Boolean Satisfiability) techniques.

## Installation

### Option 1: Download pre-compiled binary

1. Go to the [Releases](https://github.com/yourusername/pesp-sat/releases) page.
2. Download the appropriate binary for your operating system and architecture.
3. Rename the binary to `pesp-sat` (or `pesp-sat.exe` for Windows).
4. Move the binary to a directory in your system's PATH.

### Option 2: Install using Go

If you have Go installed on your system, you can install PESP-SAT directly:

```sh
go install github.com/ppvan/pesp-sat@latest
```

## Usage

```
pesp-sat [global options] command [command options] [arguments...]
```

### Commands:

- `solve`, `s`: Solve a PESP instance file
- `benmark`: Solve a PESP instance and output statistics

### Global Options:

[List any global options here]

## Examples

To solve a PESP instance file:

```
$ pesp-sat solve data/simple/test3.txt
1;1
2;4
```



## Version

v0.1.0
