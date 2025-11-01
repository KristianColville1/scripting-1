#!/usr/bin/bash
#===============================================================================
# Module:       products/add.sh
# Description:  Add new product records with validation
#===============================================================================

# Add a new product record
add_product_record() {
  init_products_file
  
  echo -e "\n${CYAN}--- Add New Product ---${NC}\n"
  
  # Product ID validation
  while :; do
    read -r -p "Product ID (or 'exit' to cancel): " id
    check_exit "$id" && return 0
    
    if ! validate_numeric "$id"; then
      display_message "error" "Product ID must be numeric."
      continue
    fi
    
    if grep -E -q "^${id}\|" "$PRODUCTS_FILE"; then
      display_message "error" "Product ID $id already exists."
      continue
    fi
    break
  done
  
  # Product Name
  while :; do
    read -r -p "Product Name (or 'exit' to cancel): " name
    check_exit "$name" && return 0
    validate_not_blank "$name" && break
    display_message "error" "Product Name cannot be blank."
  done
  
  # Category
  while :; do
    read -r -p "Category (or 'exit' to cancel): " category
    check_exit "$category" && return 0
    validate_not_blank "$category" && break
    display_message "error" "Category cannot be blank."
  done
  
  # Price
  while :; do
    read -r -p "Price (e.g., 19.99) (or 'exit' to cancel): " price
    check_exit "$price" && return 0
    if validate_decimal "$price"; then
      break
    else
      display_message "error" "Price must be a valid number."
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
  
  # Supplier Name
  while :; do
    read -r -p "Supplier Name (or 'exit' to cancel): " supplier
    check_exit "$supplier" && return 0
    validate_not_blank "$supplier" && break
    display_message "error" "Supplier Name cannot be blank."
  done
  
  # Supplier Email
  while :; do
    read -r -p "Supplier Email (or 'exit' to cancel): " email
    check_exit "$email" && return 0
    if validate_email "$email"; then
      break
    else
      display_message "error" "Invalid email format."
    fi
  done
  
  # Supplier Phone
  while :; do
    read -r -p "Supplier Phone (or 'exit' to cancel): " phone
    check_exit "$phone" && return 0
    if validate_phone "$phone"; then
      break
    else
      display_message "error" "Invalid phone format (8-15 digits)."
    fi
  done
  
  # Display confirmation
  echo ""
  echo -e "----------------------------------------------------------------"
  echo "You entered:"
  echo "  Product ID:    $id"
  echo "  Name:          $name"
  echo "  Category:      $category"
  echo "  Price:         $price"
  echo "  Quantity:      $quantity"
  echo "  Supplier:      $supplier"
  echo "  Email:         $email"
  echo "  Phone:         $phone"
  echo -e "----------------------------------------------------------------"
  
  if confirm_action "Add this product?"; then
    printf "%s|%s|%s|%s|%s|%s|%s|%s\n" "$id" "$name" "$category" "$price" "$quantity" "$supplier" "$email" "$phone" >> "$PRODUCTS_FILE" \
      && display_message "success" "Product added successfully!" \
      || display_message "error" "Failed to write to products file."
  else
    display_message "info" "Product not added."
  fi
}

