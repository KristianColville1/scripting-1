#!/usr/bin/bash
#===============================================================================
# Module:       products/remove.sh
# Description:  Remove product records with confirmation
#===============================================================================

# Remove product(s)
remove_product() {
  init_products_file
  
  if [[ ! -s "$PRODUCTS_FILE" ]]; then
    display_message "warning" "No products found in database."
    return 0
  fi
  
  echo -e "\n${CYAN}--- Remove Product(s) ---${NC}\n"
  echo "Remove by:"
  echo "  1) Single Product ID"
  echo "  2) Multiple Product IDs (comma-separated)"
  echo "  3) View all and select line number"
  
  while :; do
    read -r -p "$(echo -e '\nEnter option (1-3) or type 'exit' to cancel: ')" remove_option
    check_exit "$remove_option" && return 0
    
    case "$remove_option" in
      1)
        read -r -p "Enter Product ID to remove: " product_id
        check_exit "$product_id" && return 0
        remove_by_id "$product_id"
        break
        ;;
      2)
        read -r -p "Enter Product IDs (comma-separated, e.g., 1,3,5): " id_list
        check_exit "$id_list" && return 0
        batch_remove_by_ids "$PRODUCTS_FILE" "$id_list"
        break
        ;;
      3)
        view_all_products
        echo ""
        read -r -p "Enter line number to remove (or 'exit'): " line_num
        check_exit "$line_num" && return 0
        remove_by_line "$line_num"
        break
        ;;
      *)
        display_message "error" "Invalid option. Please try again."
        ;;
    esac
  done
}

# Remove product by ID
remove_by_id() {
  local id="$1"
  local temp_file=$(mktemp)
  
  # Show matching records
  local matches=$(awk -F'|' -v id="$id" '$1 == id' "$PRODUCTS_FILE")
  
  if [[ -z "$matches" ]]; then
    display_message "error" "No product found with ID: $id"
    rm -f "$temp_file"
    return 1
  fi
  
  echo ""
  echo "Product to be removed:"
  echo "$matches"
  echo ""
  
  if confirm_action "Remove this product?"; then
    awk -F'|' -v id="$id" '$1 != id' "$PRODUCTS_FILE" > "$temp_file" \
      && mv "$temp_file" "$PRODUCTS_FILE" \
      && display_message "success" "Product removed successfully!" \
      || display_message "error" "Failed to remove product."
  else
    display_message "info" "Product not removed."
    rm -f "$temp_file"
  fi
}

# Remove product by line number
remove_by_line() {
  local line_num="$1"
  
  if ! validate_numeric "$line_num"; then
    display_message "error" "Line number must be numeric."
    return 1
  fi
  
  # Get total lines (excluding header)
  local total_lines=$(tail -n +2 "$PRODUCTS_FILE" | wc -l)
  
  if [[ "$line_num" -lt 1 ]] || [[ "$line_num" -gt "$total_lines" ]]; then
    clear_screen
    display_message "error" "Line number out of range."
    return 1
  fi
  
  # Show the record to be removed
  echo ""
  echo "Product to be removed:"
  local line_to_remove=$((line_num + 1))  # +1 for header
  sed -n "${line_to_remove}p" "$PRODUCTS_FILE"
  echo ""

  if confirm_action "Remove this product?"; then
    clear_screen
    sed -i "${line_to_remove}d" "$PRODUCTS_FILE" \
      && display_message "success" "Product removed successfully!" \
      || display_message "error" "Failed to remove product."
  else
    clear_screen
    display_message "info" "Product not removed."
  fi
}

