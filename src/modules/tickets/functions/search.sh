#!/usr/bin/bash
#===============================================================================
# Module:       tickets/search.sh
# Description:  Search tickets with formatted tabular output
#===============================================================================

# Search for tickets with formatted output
search_tickets_formatted() {
  local field_num="$1"
  local search_term="$2"
  
  # Create temp file with search results
  local temp_file=$(mktemp)
  
  # Get header
  head -n 1 "$TICKETS_FILE" > "$temp_file"
  
  # Append matching rows
  awk -F'|' -v field="$field_num" -v term="$search_term" \
    'NR>1 && tolower($field) ~ tolower(term)' \
    "$TICKETS_FILE" >> "$temp_file"
  
  # Check if any results found
  if [[ $(wc -l < "$temp_file") -le 1 ]]; then
    rm -f "$temp_file"
    display_message "warning" "No matching tickets found."
    return 1
  fi
  
  # Use generic formatter
  format_table "$temp_file" "yes"
  
  rm -f "$temp_file"
}

# Search for tickets
search_tickets() {
  init_tickets_file
  
  if [[ ! -s "$TICKETS_FILE" ]]; then
    display_message "warning" "No tickets found in database."
    return 0
  fi
  
  echo -e "\n${CYAN}--- Search Support Tickets ---${NC}\n"
  echo "Search by:"
  echo "  1) Ticket ID"
  echo "  2) Title"
  echo "  3) Customer Name"
  echo "  4) Status"
  
  while :; do
    read -r -p "$(echo -e '\nEnter search option (1-4) or type 'exit' to cancel: ')" search_option
    check_exit "$search_option" && return 0
    
    case "$search_option" in
      1)
        read -r -p "Enter Ticket ID: " search_term
        check_exit "$search_term" && return 0
        clear_screen
        echo -e "\n${CYAN}Search Results:${NC}"
        search_tickets_formatted 1 "$search_term"
        read -r -p "Press Enter to continue..."
        break
        ;;
      2)
        read -r -p "Enter Title: " search_term
        check_exit "$search_term" && return 0
        clear_screen
        echo -e "\n${CYAN}Search Results:${NC}"
        search_tickets_formatted 2 "$search_term"
        read -r -p "Press Enter to continue..."
        break
        ;;
      3)
        read -r -p "Enter Customer Name: " search_term
        check_exit "$search_term" && return 0
        clear_screen
        echo -e "\n${CYAN}Search Results:${NC}"
        search_tickets_formatted 3 "$search_term"
        read -r -p "Press Enter to continue..."
        break
        ;;
      4)
        read -r -p "Enter Status: " search_term
        check_exit "$search_term" && return 0
        clear_screen
        echo -e "\n${CYAN}Search Results:${NC}"
        search_tickets_formatted 6 "$search_term"
        read -r -p "Press Enter to continue..."
        break
        ;;
      *)
        display_message "error" "Invalid option. Please try again."
        sleep 1
        ;;
    esac
  done
}

