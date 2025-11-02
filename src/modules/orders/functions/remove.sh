#!/usr/bin/bash
#===============================================================================
# Module:       orders/remove.sh
# Description:  Remove order records with confirmation
#===============================================================================

# Remove order(s)
remove_order() {
  init_orders_file
  
  if [[ ! -s "$ORDERS_FILE" ]]; then
    display_message "warning" "No orders found in database."
    return 0
  fi
  
  echo -e "\n${CYAN}--- Remove Order(s) ---${NC}\n"
  echo "Remove by:"
  echo "  1) Single Order ID"
  echo "  2) Multiple Order IDs (comma-separated)"
  echo "  3) View all and select line number"
  
  while :; do
    read -r -p "$(echo -e '\nEnter option (1-3) or type 'exit' to cancel: ')" remove_option
    check_exit "$remove_option" && return 0
    
    case "$remove_option" in
      1)
        read -r -p "Enter Order ID to remove: " order_id
        check_exit "$order_id" && return 0
        remove_order_by_id "$order_id"
        break
        ;;
      2)
        read -r -p "Enter Order IDs (comma-separated, e.g., 1,3,5): " id_list
        check_exit "$id_list" && return 0
        batch_remove_by_ids "$ORDERS_FILE" "$id_list"
        break
        ;;
      3)
        view_all_orders
        echo ""
        read -r -p "Enter line number to remove (or 'exit'): " line_num
        check_exit "$line_num" && return 0
        remove_order_by_line "$line_num"
        break
        ;;
      *)
        clear_screen
        display_message "error" "Invalid option. Please try again."
        ;;
    esac
  done
}

# Remove order by ID
remove_order_by_id() {
  local id="$1"
  local temp_file=$(mktemp)
  
  # Show matching records
  local matches=$(awk -F'|' -v id="$id" '$1 == id' "$ORDERS_FILE")
  
  if [[ -z "$matches" ]]; then
    display_message "error" "No order found with ID: $id"
    rm -f "$temp_file"
    return 1
  fi
  
  echo ""
  echo "Order to be removed:"
  echo "$matches"
  echo ""
  
  if confirm_action "Remove this order?"; then
    clear_screen
    awk -F'|' -v id="$id" '$1 != id' "$ORDERS_FILE" > "$temp_file" \
      && mv "$temp_file" "$ORDERS_FILE" \
      && display_message "success" "Order removed successfully!" \
      || display_message "error" "Failed to remove order."
  else
    clear_screen
    display_message "info" "Order not removed."
    rm -f "$temp_file"
  fi
}

# Remove order by line number
remove_order_by_line() {
  local line_num="$1"
  
  if ! validate_numeric "$line_num"; then
    clear_screen
    display_message "error" "Line number must be numeric."
    return 1
  fi
  
  # Get total lines (excluding header)
  local total_lines=$(tail -n +2 "$ORDERS_FILE" | wc -l)
  
  if [[ "$line_num" -lt 1 ]] || [[ "$line_num" -gt "$total_lines" ]]; then
    clear_screen
    display_message "error" "Line number out of range."
    return 1
  fi
  
  # Show the record to be removed
  echo ""
  echo "Order to be removed:"
  local line_to_remove=$((line_num + 1))  # +1 for header
  sed -n "${line_to_remove}p" "$ORDERS_FILE"
  echo ""
  
  if confirm_action "Remove this order?"; then
    clear_screen
    sed -i "${line_to_remove}d" "$ORDERS_FILE" \
      && display_message "success" "Order removed successfully!" \
      || display_message "error" "Failed to remove order."
  else
    display_message "info" "Order not removed."
  fi
}

