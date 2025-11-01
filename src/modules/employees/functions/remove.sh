#!/usr/bin/bash
#===============================================================================
# Module:       employees/remove.sh
# Description:  Remove employee records with confirmation
#===============================================================================

# Remove employee(s)
remove_employee() {
  init_employees_file
  
  if [[ ! -s "$EMPLOYEES_FILE" ]]; then
    display_message "warning" "No employees found in database."
    return 0
  fi
  
  echo -e "\n${CYAN}--- Remove Employee(s) ---${NC}\n"
  echo "Remove by:"
  echo "  1) Single Employee ID"
  echo "  2) Multiple Employee IDs (comma-separated)"
  echo "  3) View all and select line number"
  
  while :; do
    read -r -p "$(echo -e '\nEnter option (1-3) or type 'exit' to cancel: ')" remove_option
    check_exit "$remove_option" && return 0
    
    case "$remove_option" in
      1)
        read -r -p "Enter Employee ID to remove: " emp_id
        check_exit "$emp_id" && return 0
        remove_emp_by_id "$emp_id"
        break
        ;;
      2)
        read -r -p "Enter Employee IDs (comma-separated, e.g., 1,3,5): " id_list
        check_exit "$id_list" && return 0
        batch_remove_by_ids "$EMPLOYEES_FILE" "$id_list"
        break
        ;;
      3)
        view_all_employees
        echo ""
        read -r -p "Enter line number to remove (or 'exit'): " line_num
        check_exit "$line_num" && return 0
        remove_emp_by_line "$line_num"
        break
        ;;
      *)
        display_message "error" "Invalid option. Please try again."
        ;;
    esac
  done
}

# Remove employee by ID
remove_emp_by_id() {
  local id="$1"
  local temp_file=$(mktemp)
  
  # Show matching records
  local matches=$(awk -F'|' -v id="$id" '$1 == id' "$EMPLOYEES_FILE")
  
  if [[ -z "$matches" ]]; then
    display_message "error" "No employee found with ID: $id"
    rm -f "$temp_file"
    return 1
  fi
  
  echo ""
  echo "Employee to be removed:"
  echo "$matches"
  echo ""
  
  if confirm_action "Remove this employee?"; then
    awk -F'|' -v id="$id" '$1 != id' "$EMPLOYEES_FILE" > "$temp_file" \
      && mv "$temp_file" "$EMPLOYEES_FILE" \
      && display_message "success" "Employee removed successfully!" \
      || display_message "error" "Failed to remove employee."
  else
    display_message "info" "Employee not removed."
    rm -f "$temp_file"
  fi
}

# Remove employee by line number
remove_emp_by_line() {
  local line_num="$1"
  
  if ! validate_numeric "$line_num"; then
    display_message "error" "Line number must be numeric."
    return 1
  fi
  
  # Get total lines (excluding header)
  local total_lines=$(tail -n +2 "$EMPLOYEES_FILE" | wc -l)
  
  if [[ "$line_num" -lt 1 ]] || [[ "$line_num" -gt "$total_lines" ]]; then
    display_message "error" "Line number out of range."
    return 1
  fi
  
  # Show the record to be removed
  echo ""
  echo "Employee to be removed:"
  local line_to_remove=$((line_num + 1))  # +1 for header
  sed -n "${line_to_remove}p" "$EMPLOYEES_FILE"
  echo ""
  
  if confirm_action "Remove this employee?"; then
    sed -i "${line_to_remove}d" "$EMPLOYEES_FILE" \
      && display_message "success" "Employee removed successfully!" \
      || display_message "error" "Failed to remove employee."
  else
    display_message "info" "Employee not removed."
  fi
}

