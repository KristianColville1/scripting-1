#!/usr/bin/bash
#===============================================================================
# Module:       employees/add.sh
# Description:  Add new employee records with validation
#===============================================================================

# Add a new employee record
add_employee_record() {
  init_employees_file
  
  echo -e "\n${CYAN}--- Add New Employee ---${NC}\n"
  
  # Employee ID validation
  while :; do
    read -r -p "Employee ID (or 'exit' to cancel): " id
    check_exit "$id" && return 0
    
    if ! validate_numeric "$id"; then
      display_message "error" "Employee ID must be numeric."
      continue
    fi
    
    if grep -E -q "^${id}\|" "$EMPLOYEES_FILE"; then
      display_message "error" "Employee ID $id already exists."
      continue
    fi
    break
  done
  
  # Employee Name
  while :; do
    read -r -p "Employee Name (or 'exit' to cancel): " name
    check_exit "$name" && return 0
    validate_not_blank "$name" && break
    display_message "error" "Employee Name cannot be blank."
  done
  
  # Role
  while :; do
    read -r -p "Role (or 'exit' to cancel): " role
    check_exit "$role" && return 0
    validate_not_blank "$role" && break
    display_message "error" "Role cannot be blank."
  done
  
  # Department
  while :; do
    read -r -p "Department (or 'exit' to cancel): " department
    check_exit "$department" && return 0
    validate_not_blank "$department" && break
    display_message "error" "Department cannot be blank."
  done
  
  # Email
  while :; do
    read -r -p "Email (or 'exit' to cancel): " email
    check_exit "$email" && return 0
    if validate_email "$email"; then
      # Check for duplicate email
      if awk -F'|' -v email="$email" 'NR>1 && $5 == email {found=1; exit} END {exit !found}' "$EMPLOYEES_FILE" 2>/dev/null; then
        display_message "warning" "Email already exists in database."
        read -r -p "Continue anyway? (y/n): " continue_anyway
        [[ "$continue_anyway" =~ ^[yY]$ ]] && break
      else
        break
      fi
    else
      display_message "error" "Invalid email format."
    fi
  done
  
  # Phone
  while :; do
    read -r -p "Phone (or 'exit' to cancel): " phone
    check_exit "$phone" && return 0
    if validate_phone "$phone"; then
      break
    else
      display_message "error" "Invalid phone format (8-15 digits)."
    fi
  done
  
  # Hire Date
  while :; do
    read -r -p "Hire Date (DD/MM/YYYY) (or 'exit' to cancel): " hire_date
    check_exit "$hire_date" && return 0
    if validate_date "$hire_date"; then
      break
    else
      display_message "error" "Invalid date format. Use DD/MM/YYYY"
    fi
  done
  
  # Display confirmation
  echo ""
  echo -e "----------------------------------------------------------------"
  echo "You entered:"
  echo "  Employee ID:  $id"
  echo "  Name:         $name"
  echo "  Role:         $role"
  echo "  Department:   $department"
  echo "  Email:        $email"
  echo "  Phone:        $phone"
  echo "  Hire Date:    $hire_date"
  echo -e "----------------------------------------------------------------"
  
  if confirm_action "Add this employee?"; then
    printf "%s|%s|%s|%s|%s|%s|%s\n" "$id" "$name" "$role" "$department" "$email" "$phone" "$hire_date" >> "$EMPLOYEES_FILE" \
      && display_message "success" "Employee added successfully!" \
      || display_message "error" "Failed to write to employees file."
  else
    display_message "info" "Employee not added."
  fi
}

