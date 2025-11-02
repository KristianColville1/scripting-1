#!/usr/bin/bash
#===============================================================================
# Module:       products/search.sh
# Description:  Search products with formatted tabular output
#===============================================================================

# Search for products with formatted output
search_products_formatted() {
  local field_num="$1"
  local search_term="$2"
  
  # Create temp file with search results
  local temp_file=$(mktemp)
  
  # Get header
  head -n 1 "$PRODUCTS_FILE" > "$temp_file"
  
  # Append matching rows
  awk -F'|' -v field="$field_num" -v term="$search_term" \
    'NR>1 && tolower($field) ~ tolower(term)' \
    "$PRODUCTS_FILE" >> "$temp_file"
  
  # Check if any results found
  if [[ $(wc -l < "$temp_file") -le 1 ]]; then
    rm -f "$temp_file"
    display_message "warning" "No matching products found."
    return 1
  fi
  
  # Use generic formatter
  format_table "$temp_file" "yes"
  
  rm -f "$temp_file"
}

# Search for products
search_products() {
  init_products_file
  
  if [[ ! -s "$PRODUCTS_FILE" ]]; then
    display_message "warning" "No products found in database."
    return 0
  fi
  
  echo -e "\n${CYAN}--- Search Products ---${NC}\n"
  echo "Search by:"
  echo "  1) Product ID"
  echo "  2) Product Name"
  echo "  3) Category"
  echo "  4) Supplier"
  
  while :; do
    read -r -p "$(echo -e '\nEnter search option (1-4) or type 'exit' to cancel: ')" search_option
    check_exit "$search_option" && return 0
    
    case "$search_option" in
      1)
        read -r -p "Enter Product ID: " search_term
        check_exit "$search_term" && return 0
        clear_screen
        echo -e "\n${CYAN}Search Results:${NC}"
        search_products_formatted 1 "$search_term"
        read -r -p "Press Enter to continue..."
        break
        ;;
      2)
        read -r -p "Enter Product Name: " search_term
        check_exit "$search_term" && return 0
        clear_screen
        echo -e "\n${CYAN}Search Results:${NC}"
        search_products_formatted 2 "$search_term"
        read -r -p "Press Enter to continue..."
        break
        ;;
      3)
        read -r -p "Enter Category: " search_term
        check_exit "$search_term" && return 0
        clear_screen
        echo -e "\n${CYAN}Search Results:${NC}"
        search_products_formatted 3 "$search_term"
        read -r -p "Press Enter to continue..."
        break
        ;;
      4)
        read -r -p "Enter Supplier Name: " search_term
        check_exit "$search_term" && return 0
        clear_screen
        echo -e "\n${CYAN}Search Results:${NC}"
        search_products_formatted 6 "$search_term"
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

