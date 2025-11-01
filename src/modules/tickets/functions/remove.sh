#!/usr/bin/bash
#===============================================================================
# Module:       tickets/remove.sh
# Description:  Remove ticket records with confirmation
#===============================================================================

# Remove ticket(s)
remove_ticket() {
  init_tickets_file
  
  if [[ ! -s "$TICKETS_FILE" ]]; then
    display_message "warning" "No tickets found in database."
    return 0
  fi
  
  echo -e "\n${CYAN}--- Remove Support Ticket(s) ---${NC}\n"
  echo "Remove by:"
  echo "  1) Single Ticket ID"
  echo "  2) Multiple Ticket IDs (comma-separated)"
  echo "  3) View all and select line number"
  
  while :; do
    read -r -p "$(echo -e '\nEnter option (1-3) or type 'exit' to cancel: ')" remove_option
    check_exit "$remove_option" && return 0
    
    case "$remove_option" in
      1)
        read -r -p "Enter Ticket ID to remove: " ticket_id
        check_exit "$ticket_id" && return 0
        remove_ticket_by_id "$ticket_id"
        break
        ;;
      2)
        read -r -p "Enter Ticket IDs (comma-separated, e.g., 1,3,5): " id_list
        check_exit "$id_list" && return 0
        batch_remove_by_ids "$TICKETS_FILE" "$id_list"
        break
        ;;
      3)
        view_all_tickets
        echo ""
        read -r -p "Enter line number to remove (or 'exit'): " line_num
        check_exit "$line_num" && return 0
        remove_ticket_by_line "$line_num"
        break
        ;;
      *)
        display_message "error" "Invalid option. Please try again."
        ;;
    esac
  done
}

# Remove ticket by ID
remove_ticket_by_id() {
  local id="$1"
  local temp_file=$(mktemp)
  
  # Show matching records
  local matches=$(awk -F'|' -v id="$id" '$1 == id' "$TICKETS_FILE")
  
  if [[ -z "$matches" ]]; then
    display_message "error" "No ticket found with ID: $id"
    rm -f "$temp_file"
    return 1
  fi
  
  echo ""
  echo "Ticket to be removed:"
  echo "$matches"
  echo ""
  
  if confirm_action "Remove this ticket?"; then
    awk -F'|' -v id="$id" '$1 != id' "$TICKETS_FILE" > "$temp_file" \
      && mv "$temp_file" "$TICKETS_FILE" \
      && display_message "success" "Ticket removed successfully!" \
      || display_message "error" "Failed to remove ticket."
  else
    display_message "info" "Ticket not removed."
    rm -f "$temp_file"
  fi
}

# Remove ticket by line number
remove_ticket_by_line() {
  local line_num="$1"
  
  if ! validate_numeric "$line_num"; then
    display_message "error" "Line number must be numeric."
    return 1
  fi
  
  # Get total lines (excluding header)
  local total_lines=$(tail -n +2 "$TICKETS_FILE" | wc -l)
  
  if [[ "$line_num" -lt 1 ]] || [[ "$line_num" -gt "$total_lines" ]]; then
    display_message "error" "Line number out of range."
    return 1
  fi
  
  # Show the record to be removed
  echo ""
  echo "Ticket to be removed:"
  local line_to_remove=$((line_num + 1))  # +1 for header
  sed -n "${line_to_remove}p" "$TICKETS_FILE"
  echo ""
  
  if confirm_action "Remove this ticket?"; then
    sed -i "${line_to_remove}d" "$TICKETS_FILE" \
      && display_message "success" "Ticket removed successfully!" \
      || display_message "error" "Failed to remove ticket."
  else
    display_message "info" "Ticket not removed."
  fi
}

