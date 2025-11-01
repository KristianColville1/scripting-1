#!/usr/bin/bash
#===============================================================================
# File:         validation.sh
# Description:  Validation utility functions for input checking
#===============================================================================

# Validate email format
validate_email() {
  local email="$1"
  # Basic email regex pattern
  if [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    return 0
  else
    return 1
  fi
}

# Validate phone number (allows digits, spaces, dashes, parentheses)
validate_phone() {
  local phone="$1"
  # Remove common phone separators for validation
  local cleaned="${phone//[[:space:]-()]/}"
  if [[ "$cleaned" =~ ^[0-9]{8,15}$ ]]; then
    return 0
  else
    return 1
  fi
}

# Validate numeric input
validate_numeric() {
  local value="$1"
  if [[ "$value" =~ ^[0-9]+$ ]]; then
    return 0
  else
    return 1
  fi
}

# Validate decimal input
validate_decimal() {
  local value="$1"
  if [[ "$value" =~ ^[0-9]+\.?[0-9]*$ ]]; then
    return 0
  else
    return 1
  fi
}

# Check if field is not blank
validate_not_blank() {
  local field="$1"
  [[ -n "$field" ]] && return 0 || return 1
}

# Validate date format (DD/MM/YYYY)
validate_date() {
  local date="$1"
  if [[ "$date" =~ ^[0-9]{2}/[0-9]{2}/[0-9]{4}$ ]]; then
    return 0
  else
    return 1
  fi
}

# Confirm with user before proceeding
confirm_action() {
  local message="$1"
  read -r -p "$message (y/n): " confirm
  [[ "$confirm" =~ ^[yY]$ ]] && return 0 || return 1
}

# Check if exit was requested
check_exit() {
  local input="$1"
  [[ "$input" =~ ^[Ee][Xx][Ii][Tt]$ ]] && return 0 || return 1
}

# Search by specific field (generic function for use across all modules)
search_by_field() {
  local file="$1"
  local field_num="$2"
  local search_term="$3"
  
  # Case-insensitive search
  local results=$(awk -F'|' -v term="$search_term" "NR>1 && tolower(\$$field_num) ~ tolower(term) {print NR-1 \") \" \$0}" "$file")
  
  if [[ -n "$results" ]]; then
    echo ""
    echo "Search Results:"
    echo "$results"
  else
    display_message "warning" "No matching records found."
  fi
}

