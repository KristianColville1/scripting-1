#!/usr/bin/bash
#===============================================================================
# Module:       tickets/view.sh
# Description:  View and display tickets using generic table formatter
#===============================================================================

# View all tickets
view_all_tickets() {
  init_tickets_file
  
  if [[ ! -s "$TICKETS_FILE" ]]; then
    display_message "warning" "No tickets found in database."
    sleep 2
    return 0
  fi
  
  clear_screen
  echo -e "\n${CYAN}--- All Support Tickets ---${NC}"
  format_table "$TICKETS_FILE" "yes"
  read -r -p "Press Enter to continue..."
}

