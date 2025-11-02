#!/usr/bin/bash
#===============================================================================
# Module:       orders/view.sh
# Description:  View and display orders using generic table formatter
#===============================================================================

# View all orders
view_all_orders() {
  init_orders_file
  
  if [[ ! -s "$ORDERS_FILE" ]]; then
    display_message "warning" "No orders found in database."
    sleep 2
    return 0
  fi
  
  clear_screen
  echo -e "\n${CYAN}--- All Orders ---${NC}"
  format_table "$ORDERS_FILE" "yes"
  read -r -p "Press Enter to continue..."
}

