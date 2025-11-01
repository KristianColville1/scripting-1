#!/usr/bin/bash
#===============================================================================
# Module:       products/init.sh
# Description:  Initialize products data file
#===============================================================================

PRODUCTS_FILE="$DATA_DIR/products.txt"

# Ensure products file exists with header
init_products_file() {
  if [[ ! -f "$PRODUCTS_FILE" ]]; then
    echo "ID|Name|Category|Price|Quantity|Supplier|Email|Phone" > "$PRODUCTS_FILE"
  fi
}

