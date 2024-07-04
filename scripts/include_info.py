import os
import argparse


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


def rewrite_file(filename, constraints, distinct_events, data_lines):
    temp_filename = filename + ".temp"

    with open(temp_filename, "w") as temp_file:
        temp_file.write(f"{constraints} {distinct_events} 60\n")
        temp_file.writelines(data_lines)

    os.replace(temp_filename, filename)


def main():
    parser = argparse.ArgumentParser(
        description="Parse and update a file with constraint information."
    )
    parser.add_argument("input_file", help="Path to the input file")
    args = parser.parse_args()

    filename = args.input_file

    if not os.path.exists(filename):
        print(f"Error: The file '{filename}' does not exist.")
        return

    constraints, distinct_events, data_lines = parse_file(filename)
    rewrite_file(filename, constraints, distinct_events, data_lines)
    print(f"File '{filename}' has been successfully updated.")


if __name__ == "__main__":
    main()
