#!/usr/bin/bash
#===============================================================================
# File:         table_formatter.sh
# Description:  Generic table formatter with dynamic column widths
#===============================================================================

# Format and display data in tabular format with yellow asterisk borders
# Usage: format_table <data_file> <show_line_numbers>
format_table() {
  local data_file="$1"
  local show_line_numbers="${2:-yes}"
  
  # Check if file exists and has content
  if [[ ! -f "$data_file" ]] || [[ ! -s "$data_file" ]]; then
    return 1
  fi
  
  # Calculate column widths dynamically
  local widths=$(awk -F'|' '
    {
      for (i=1; i<=NF; i++) {
        len = length($i)
        if (len > max[i]) max[i] = len
      }
    }
    END {
      for (i=1; i<=NF; i++) {
        # Add padding (minimum 4, add 2 for spacing)
        width = max[i] < 4 ? 6 : max[i] + 2
        printf "%d ", width
      }
    }
  ' "$data_file")
  
  # Convert widths to array
  read -ra width_array <<< "$widths"
  
  # Build format string for printf
  local format_string=""
  local header_sep=""
  local total_width=4  # Start with line number column
  
  # Add line number column if needed
  if [[ "$show_line_numbers" == "yes" ]]; then
    format_string="%-4s "
    header_sep="---- "
    total_width=$((total_width + 5))
  fi
  
  # Build format for data columns
  local col_count=${#width_array[@]}
  for width in "${width_array[@]}"; do
    format_string="${format_string}%-${width}s "
    header_sep="${header_sep}$(printf '%.0s-' $(seq 1 $width)) "
    total_width=$((total_width + width + 1))
  done
  
  # Get headers
  local headers=$(head -n 1 "$data_file")
  IFS='|' read -ra header_array <<< "$headers"
  
  # Print top border
  echo ""
  echo -e "${YELLOW}$(printf '%.0s*' $(seq 1 $total_width))${NC}"
  
  # Print header
  if [[ "$show_line_numbers" == "yes" ]]; then
    printf "$format_string\n" "#" "${header_array[@]}"
    echo "$header_sep"
  else
    printf "$format_string\n" "${header_array[@]}"
    echo "$header_sep"
  fi
  
  # Print data rows
  awk -F'|' -v format="$format_string" -v show_nums="$show_line_numbers" -v widths="$widths" '
    BEGIN {
      split(widths, w, " ")
    }
    NR > 1 {
      if (show_nums == "yes") {
        line_num = NR-1")"
        printf "%-4s ", line_num
      }
      for (i=1; i<=NF; i++) {
        printf "%-" w[i] "s ", substr($i, 1, w[i])
      }
      printf "\n"
    }
  ' "$data_file"
  
  # Print bottom border
  echo -e "${YELLOW}$(printf '%.0s*' $(seq 1 $total_width))${NC}"
  echo ""
}

