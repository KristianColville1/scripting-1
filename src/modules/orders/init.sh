#!/usr/bin/bash
#===============================================================================
# Module:       orders/init.sh
# Description:  Initialize orders data file
#===============================================================================

ORDERS_FILE="$DATA_DIR/orders.txt"

# Ensure orders file exists with header
init_orders_file() {
  if [[ ! -f "$ORDERS_FILE" ]]; then
    echo "ID|Product|Customer|Email|Phone|Quantity|Total|Date" > "$ORDERS_FILE"
  fi
}

