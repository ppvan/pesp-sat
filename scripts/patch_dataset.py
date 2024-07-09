import os
import argparse
from pathlib import Path


def parse_file(filename):
    constraints = 0
    origins = set()
    destinations = set()
    data_lines = []

    with open(filename, "r") as file:
        # Skip the first line (comment)
        file.readline()

        for line in file:
            parts = line.strip().split(";")
            if len(parts) == 6:
                constraints += 1
                origins.add(int(parts[1]))
                destinations.add(int(parts[2]))
                data_lines.append(line)

    return constraints, len(origins.union(destinations)), data_lines


def rewrite_file(filename: Path, constraints, distinct_events, data_lines):
    temp_filename = filename.name + ".temp"
    temp_filepath = filename.parent / temp_filename

    with open(temp_filepath, "w") as temp_file:
        temp_file.write(f"{constraints} {distinct_events} 60\n")
        temp_file.writelines(data_lines)

    os.replace(temp_filepath, filename)


def main():
    parser = argparse.ArgumentParser(
        description="Parse and update a file with constraint information."
    )
    parser.add_argument("path", help="Path to find input file")
    args = parser.parse_args()

    filename = args.path

    dir_path = Path(filename).resolve()

    if not dir_path.exists():
        print(f"Error: The directory '{dir_path}' does not exist.")

    for filename in dir_path.glob("**/*.txt"):
        constraints, distinct_events, data_lines = parse_file(filename)
        rewrite_file(filename, constraints, distinct_events, data_lines)
        print(f"File '{filename}' has been successfully updated.")


if __name__ == "__main__":
    main()
