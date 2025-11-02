#!/usr/bin/bash
#===============================================================================
# Module:       tickets/add.sh
# Description:  Add new ticket records with validation
#===============================================================================

# Add a new ticket record
add_ticket_record() {
  init_tickets_file
  
  echo -e "\n${CYAN}--- Add New Support Ticket ---${NC}\n"
  
  # Ticket ID validation
  while :; do
    read -r -p "Ticket ID (or 'exit' to cancel): " id
    check_exit "$id" && return 0
    
    if ! validate_numeric "$id"; then
      clear_screen
      display_message "error" "Ticket ID must be numeric."
      continue
    fi
    
    if grep -E -q "^${id}\|" "$TICKETS_FILE"; then
      clear_screen
      display_message "error" "Ticket ID $id already exists."
      continue
    fi
    break
  done
  
  # Title
  while :; do
    read -r -p "Ticket Title (or 'exit' to cancel): " title
    check_exit "$title" && return 0
    validate_not_blank "$title" && break
    clear_screen
    display_message "error" "Title cannot be blank."
  done
  
  # Customer Name
  while :; do
    read -r -p "Customer Name (or 'exit' to cancel): " customer
    check_exit "$customer" && return 0
    validate_not_blank "$customer" && break
    clear_screen
    display_message "error" "Customer Name cannot be blank."
  done
  
  # Email
  while :; do
    read -r -p "Email (or 'exit' to cancel): " email
    check_exit "$email" && return 0
    if validate_email "$email"; then
      break
    else
      clear_screen
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
      clear_screen
      display_message "error" "Invalid phone format (8-15 digits)."
    fi
  done
  
  # Status
  echo ""
  echo "Status options: Open, In Progress, Resolved, Closed"
  while :; do
    read -r -p "Status (or 'exit' to cancel): " status
    check_exit "$status" && return 0
    validate_not_blank "$status" && break
    clear_screen
    display_message "error" "Status cannot be blank."
  done
  
  # Priority
  echo ""
  echo "Priority options: Low, Medium, High, Critical"
  while :; do
    read -r -p "Priority (or 'exit' to cancel): " priority
    check_exit "$priority" && return 0
    validate_not_blank "$priority" && break
    clear_screen
    display_message "error" "Priority cannot be blank."
  done
  
  # Date
  while :; do
    read -r -p "Date (DD/MM/YYYY) (or 'exit' to cancel): " date
    check_exit "$date" && return 0
    if validate_date "$date"; then
      break
    else
      clear_screen
      display_message "error" "Invalid date format. Use DD/MM/YYYY"
    fi
  done
  
  # Display confirmation
  echo ""
  echo -e "----------------------------------------------------------------"
  echo "You entered:"
  echo "  Ticket ID:    $id"
  echo "  Title:        $title"
  echo "  Customer:     $customer"
  echo "  Email:        $email"
  echo "  Phone:        $phone"
  echo "  Status:       $status"
  echo "  Priority:     $priority"
  echo "  Date:         $date"
  echo -e "----------------------------------------------------------------"
  
  if confirm_action "Add this ticket?"; then
    clear_screen
    printf "%s|%s|%s|%s|%s|%s|%s|%s\n" "$id" "$title" "$customer" "$email" "$phone" "$status" "$priority" "$date" >> "$TICKETS_FILE" \
      && display_message "success" "Ticket added successfully!" \
      || display_message "error" "Failed to write to tickets file."
  else
    clear_screen
    display_message "info" "Ticket not added."
  fi
}

