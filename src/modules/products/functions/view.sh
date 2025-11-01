#!/usr/bin/bash
#===============================================================================
# Module:       products/view.sh
# Description:  View and display products using generic table formatter
#===============================================================================

# View all products
view_all_products() {
  init_products_file
  
  if [[ ! -s "$PRODUCTS_FILE" ]]; then
    display_message "warning" "No products found in database."
    return 0
  fi
  
  echo -e "\n${CYAN}--- All Products ---${NC}"
  format_table "$PRODUCTS_FILE" "yes"
}

