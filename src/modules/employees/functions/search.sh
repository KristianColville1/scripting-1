#!/usr/bin/bash
#===============================================================================
# Module:       employees/search.sh
# Description:  Search employees with formatted tabular output
#===============================================================================

# Search for employees with formatted output
search_employees_formatted() {
  local field_num="$1"
  local search_term="$2"
  
  # Create temp file with search results
  local temp_file=$(mktemp)
  
  # Get header
  head -n 1 "$EMPLOYEES_FILE" > "$temp_file"
  
  # Append matching rows
  awk -F'|' -v field="$field_num" -v term="$search_term" \
    'NR>1 && tolower($field) ~ tolower(term)' \
    "$EMPLOYEES_FILE" >> "$temp_file"
  
  # Check if any results found
  if [[ $(wc -l < "$temp_file") -le 1 ]]; then
    rm -f "$temp_file"
    display_message "warning" "No matching employees found."
    return 1
  fi
  
  # Use generic formatter
  format_table "$temp_file" "yes"
  
  rm -f "$temp_file"
}

# Search for employees
search_employees() {
  init_employees_file
  
  if [[ ! -s "$EMPLOYEES_FILE" ]]; then
    display_message "warning" "No employees found in database."
    return 0
  fi
  
  echo -e "\n${CYAN}--- Search Employees ---${NC}\n"
  echo "Search by:"
  echo "  1) Employee ID"
  echo "  2) Employee Name"
  echo "  3) Role"
  echo "  4) Department"
  
  while :; do
    read -r -p "$(echo -e '\nEnter search option (1-4) or type 'exit' to cancel: ')" search_option
    check_exit "$search_option" && return 0
    
    case "$search_option" in
      1)
        read -r -p "Enter Employee ID: " search_term
        check_exit "$search_term" && return 0
        echo -e "\n${CYAN}Search Results:${NC}"
        search_employees_formatted 1 "$search_term"
        break
        ;;
      2)
        read -r -p "Enter Employee Name: " search_term
        check_exit "$search_term" && return 0
        echo -e "\n${CYAN}Search Results:${NC}"
        search_employees_formatted 2 "$search_term"
        break
        ;;
      3)
        read -r -p "Enter Role: " search_term
        check_exit "$search_term" && return 0
        echo -e "\n${CYAN}Search Results:${NC}"
        search_employees_formatted 3 "$search_term"
        break
        ;;
      4)
        read -r -p "Enter Department: " search_term
        check_exit "$search_term" && return 0
        echo -e "\n${CYAN}Search Results:${NC}"
        search_employees_formatted 4 "$search_term"
        break
        ;;
      *)
        display_message "error" "Invalid option. Please try again."
        ;;
    esac
  done
}

