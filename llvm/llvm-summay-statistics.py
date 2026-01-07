#!/bin/python3
import re
import sys
from collections import Counter

# Define the synonym map where key is the standard term and values are its synonyms
synonym_map = {
    "aarch64": {"aarch64", "arm64"},
    "riscv": {"riscv", "risc-v"},
}

# Define the exclude map where key is the standard term and values are its synonyms
exclude_map = {
    "docs": {"docs", "document", "documentation", "clang-doc"},
    "nfc": {"nfc"},
}

# Function to normalize terms using the synonym map
def normalize_term(term):
    """
    Normalize the term using the synonym map. If the term is in the synonym map,
    it will be replaced by its standard representation (the first key).
    :param term: The term to be normalized
    :return: The normalized term
    """
    # Convert the term to lowercase
    term = term.lower()
    # Check if the term is in the synonym map, and return the standard term
    for standard_term, synonyms in synonym_map.items():
        if term in synonyms:
            return standard_term
    # If not found in the map, return the term as is
    return term

# Function to check if a term is in the exclude map
def is_excluded(term):
    """
    Check if the term is in the exclude map or its synonyms.
    :param term: The term to check
    :return: True if the term should be excluded, False otherwise
    """
    term = term.lower()
    for excluded_term, synonyms in exclude_map.items():
        if term in synonyms:
            return True
    return False

# Function to count the occurrences of each term inside single square brackets (excluding nested brackets)
# Converts all terms to lowercase before counting
def count_square_bracket_terms(commit_log):
    """
    Count occurrences of each term inside square brackets in the commit log.
    Only terms within single square brackets (not nested) will be counted.
    All terms are normalized using the synonym map before counting.
    Terms in the exclude map are not counted.
    :param commit_log: Commit log string
    :return: A sorted list of tuples (term, count) in descending order
    """
    terms = []
    for line in commit_log.strip().split('\n'):
        # Use regex to find terms inside single square brackets (excluding nested ones)
        found_terms = re.findall(r'(?<!\[)\[([^\[\]]+)\](?!\])', line)
        # Normalize each term using the synonym map and check if it should be excluded
        for term in found_terms:
            normalized_term = normalize_term(term)
            if not is_excluded(normalized_term):  # Only count terms not in the exclude map
                terms.append(normalized_term)

    return Counter(terms)

# Function to filter commits containing a given term and count remaining square bracket terms (excluding nested brackets)
# Converts filter term and results to lowercase for case-insensitive comparison
def filter_and_count(commit_log, filter_term):
    """
    Filter commits containing a given term and count occurrences of terms in square brackets in these commits.
    Only terms within single square brackets (not nested) will be counted.
    All terms are normalized using the synonym map before counting.
    Terms in the exclude map are not counted.
    :param commit_log: Commit log string
    :param filter_term: Term to filter commits by
    :return: A sorted list of tuples (term, count) in descending order
    """
    filtered_terms = []
    filter_term = normalize_term(filter_term)  # Normalize filter term using the synonym map

    for line in commit_log.strip().split('\n'):
        # Check if the filter_term appears in the square brackets of the line (case insensitive)
        if any(filter_term in normalize_term(part) for part in re.findall(r'\[([^\[\]]+)\]', line)):
            # Collect all other square bracket terms (excluding nested ones) and normalize them
            for term in re.findall(r'(?<!\[)\[([^\[\]]+)\](?!\])', line):
                normalized_term = normalize_term(term)
                if not is_excluded(normalized_term):  # Only count terms not in the exclude map
                    filtered_terms.append(normalized_term)

    return Counter(filtered_terms)

# Main function to run the script
def main():
    # Step 1: Get the file path from the first command-line argument
    if len(sys.argv) < 2:
        print("Usage: python script.py <file_path> [filter_term]")
        sys.exit(1)

    file_path = sys.argv[1]

    # Step 2: Read the commit log file
    try:
        with open(file_path, 'r') as file:
            commit_log = file.read()
    except FileNotFoundError:
        print(f"Error: File '{file_path}' not found.")
        sys.exit(1)

    # 3. Count occurrences of all terms inside square brackets (first type of statistic)
    overall_counts = count_square_bracket_terms(commit_log)
    sorted_overall_counts = overall_counts.most_common()

    print("\nOverall count of terms inside square brackets (case-insensitive, normalized, excluding specified terms):")
    for term, count in sorted_overall_counts:
        print(f"{term}: {count}")

    # Step 4: Check if a second argument (filter_term) is provided
    if len(sys.argv) == 3:
        filter_term = sys.argv[2].strip()  # Get the second argument as filter term
        # 5. If a filter term is provided, filter and count terms based on it (second type of statistic)
        filtered_counts = filter_and_count(commit_log, filter_term)
        sorted_filtered_counts = filtered_counts.most_common()

        print(f"\nFiltered count of terms for commits containing '{filter_term}' (case-insensitive, normalized, excluding specified terms):")
        for term, count in sorted_filtered_counts:
            print(f"{term}: {count}")

if __name__ == "__main__":
    main()
