#!/usr/bin/bash
#===============================================================================
# Module:       orders/add.sh
# Description:  Add new order records with validation
#===============================================================================

# Add a new order record
add_order_record() {
  init_orders_file
  
  echo -e "\n${CYAN}--- Add New Order ---${NC}\n"
  
  # Order ID validation
  while :; do
    read -r -p "Order ID (or 'exit' to cancel): " id
    check_exit "$id" && return 0
    
    if ! validate_numeric "$id"; then
      display_message "error" "Order ID must be numeric."
      continue
    fi
    
    if grep -E -q "^${id}\|" "$ORDERS_FILE"; then
      display_message "error" "Order ID $id already exists."
      continue
    fi
    break
  done
  
  # Product Name
  while :; do
    read -r -p "Product Name (or 'exit' to cancel): " product
    check_exit "$product" && return 0
    validate_not_blank "$product" && break
    display_message "error" "Product Name cannot be blank."
  done
  
  # Customer Name
  while :; do
    read -r -p "Customer Name (or 'exit' to cancel): " customer
    check_exit "$customer" && return 0
    validate_not_blank "$customer" && break
    display_message "error" "Customer Name cannot be blank."
  done
  
  # Email
  while :; do
    read -r -p "Email (or 'exit' to cancel): " email
    check_exit "$email" && return 0
    if validate_email "$email"; then
      break
    else
      display_message "error" "Invalid email format."
    fi
  done
  
  # Phone
  while :; do
    read -r -p "Phone (or 'exit' to cancel): " phone
    check_exit "$phone" && return 0
    if validate_phone "$phone"; then
      break
    else
      display_message "error" "Invalid phone format (8-15 digits)."
    fi
  done
  
  # Quantity
  while :; do
    read -r -p "Quantity (or 'exit' to cancel): " quantity
    check_exit "$quantity" && return 0
    if validate_numeric "$quantity"; then
      break
    else
      display_message "error" "Quantity must be numeric."
    fi
  done
  
  # Total
  while :; do
    read -r -p "Total (e.g., 199.99) (or 'exit' to cancel): " total
    check_exit "$total" && return 0
    if validate_decimal "$total"; then
      break
    else
      display_message "error" "Total must be a valid number."
    fi
  done
  
  # Date
  while :; do
    read -r -p "Order Date (DD/MM/YYYY) (or 'exit' to cancel): " date
    check_exit "$date" && return 0
    if validate_date "$date"; then
      break
    else
      display_message "error" "Invalid date format. Use DD/MM/YYYY"
    fi
  done
  
  # Display confirmation
  echo ""
  echo -e "----------------------------------------------------------------"
  echo "You entered:"
  echo "  Order ID:     $id"
  echo "  Product:      $product"
  echo "  Customer:     $customer"
  echo "  Email:        $email"
  echo "  Phone:        $phone"
  echo "  Quantity:     $quantity"
  echo "  Total:        €$total"
  echo "  Date:         $date"
  echo -e "----------------------------------------------------------------"
  
  if confirm_action "Add this order?"; then
    printf "%s|%s|%s|%s|%s|%s|%s|%s\n" "$id" "$product" "$customer" "$email" "$phone" "$quantity" "$total" "$date" >> "$ORDERS_FILE" \
      && display_message "success" "Order added successfully!" \
      || display_message "error" "Failed to write to orders file."
  else
    display_message "info" "Order not added."
  fi
}
