#!/bin/bash

# Exit if no arguments provided
if [ $# -eq 0 ]; then
    echo -e "\033[1;31mERR\033[0m: No arguments supplied"
    exit 1
fi

# Initialize ignore patterns if ignore.txt exists
if [ -f "dat/ignore.txt" ]; then
    # Create array of ignore patterns with 'in/' prefix
    mapfile -t ignore < "dat/ignore.txt"
    ignore_patterns=$(printf "\\|in/%s" "${ignore[@]}" | sed 's/^\\|//')
else
    ignore_patterns=""
fi

# Function to check if path should be ignored
should_ignore() {
    if [ -n "$ignore_patterns" ]; then
        echo "$1" | grep -q "$ignore_patterns" && return 0
    fi
    return 1
}

case "$1" in
    "doc")
        # Find documentation files (.txti, .org, .md, .e.html)
        find "in" -type f \( -name "*.txti" -o -name "*.org" -o -name "*.md" -o -name "*.e.html" \) \
        | grep -v "\.html$" \
        | while read -r file; do
            [ -n "$ignore_patterns" ] && should_ignore "$file" && continue
            printf "%s " "$file"
        done
        ;;
    
    "sass")
        # Find SASS/SCSS files
        find "in" -type f \( -name "*.sass" -o -name "*.scss" \) \
        | while read -r file; do
            [ -n "$ignore_patterns" ] && should_ignore "$file" && continue
            printf "%s " "$file"
        done
        ;;
    
    "dir")
        # Find directories
        find "in" -type d ! -name ".*" \
        | while read -r dir; do
            [ -n "$ignore_patterns" ] && should_ignore "$dir" && continue
            printf "%s " "$dir"
        done
        ;;
    
    "rest")
        # Find all other files
        find "in" -type f ! -name "*.sass" ! -name "*.scss" \
            ! -name "*.txti" ! -name "*.org" ! -name "*.md" ! -name "*.html" \
        | while read -r file; do
            [ -n "$ignore_patterns" ] && should_ignore "$file" && continue
            printf "%s " "$file"
        done
        ;;
    
    *)
        echo -e "\033[1;31mERR\033[0m: Unknown option: $1"
        exit 1
        ;;
esac

# Print newline at the end
echo