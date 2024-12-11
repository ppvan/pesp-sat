#!/bin/bash

# Check if source directory is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <source_directory>"
    exit 1
fi

# Source directory
SOURCE_DIR="$1"

# Output CSV file
OUTPUT_CSV="dimacs_benchmark_$(date +"%Y%m%d_%H%M%S").csv"

# Write CSV header
echo "File,Pesp-Sat Time (ms),Kissat Time (ms)" > "$OUTPUT_CSV"

# Find and process all .dimacs files
find "$SOURCE_DIR" -type f -name "*.dimacs" | while read -r file; do
    # Escape special characters in filename for safe output
    escaped_file=$(printf '%q' "$file")
    
    # Time pesp-sat command in milliseconds
    pesp_start=$(date +%s%N)
    ./../bin/pesp-sat dimacs "$file" > /dev/null 2>&1
    pesp_end=$(date +%s%N)
    pesp_time=$(( (pesp_end - pesp_start) / 1000000 ))
    
    # Time kissat command in milliseconds
    kissat_start=$(date +%s%N)
    kissat -q -n "$file" > /dev/null 2>&1
    kissat_end=$(date +%s%N)
    kissat_time=$(( (kissat_end - kissat_start) / 1000000 ))
    
    # Write results to CSV
    echo "$escaped_file,$pesp_time,$kissat_time" >> "$OUTPUT_CSV"
    
    # Print progress to console
    echo "Processed: $file"
done

# Print location of output CSV
echo "Benchmark results saved to $OUTPUT_CSV"