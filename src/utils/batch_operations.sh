#!/usr/bin/bash
#===============================================================================
# File:         batch_operations.sh
# Description:  Batch operations utility for removing multiple records
#===============================================================================

# Batch remove records by comma-separated IDs
# Usage: batch_remove_by_ids <data_file> <id_list>
batch_remove_by_ids() {
  local data_file="$1"
  local id_list="$2"
  
  # Convert comma-separated list to array
  IFS=',' read -ra id_array <<< "$id_list"
  
  # Remove whitespace from IDs
  local clean_ids=()
  for id in "${id_array[@]}"; do
    clean_ids+=("$(echo "$id" | xargs)")
  done
  
  # Display warning
  display_message "warning" "IDs not found will be skipped."
  echo ""
  
  # Find matching records
  local temp_display=$(mktemp)
  local found_ids=()
  local not_found_ids=()
  
  for id in "${clean_ids[@]}"; do
    local match=$(awk -F'|' -v id="$id" '$1 == id' "$data_file")
    if [[ -n "$match" ]]; then
      echo "$match" >> "$temp_display"
      found_ids+=("$id")
    else
      not_found_ids+=("$id")
    fi
  done
  
  # Show results
  if [[ ${#not_found_ids[@]} -gt 0 ]]; then
    echo -e "${RED}IDs not found (will skip): ${not_found_ids[*]}${NC}"
    echo ""
  fi
  
  if [[ ${#found_ids[@]} -eq 0 ]]; then
    display_message "error" "No matching records found."
    rm -f "$temp_display"
    return 1
  fi
  
  # Show records to be deleted
  echo "Records to be deleted:"
  echo ""
  cat "$temp_display"
  echo ""
  echo "Total: ${#found_ids[@]} record(s) will be removed."
  echo ""
  
  rm -f "$temp_display"
  
  # Confirm deletion
  if confirm_action "Delete these ${#found_ids[@]} record(s)?"; then
    local temp_file=$(mktemp)
    
    # Build awk condition to exclude all IDs
    local awk_condition='$1 != "'${found_ids[0]}'"'
    for ((i=1; i<${#found_ids[@]}; i++)); do
      awk_condition="$awk_condition && \$1 != \"${found_ids[$i]}\""
    done
    
    # Remove all matching IDs
    awk -F'|' "$awk_condition" "$data_file" > "$temp_file" \
      && mv "$temp_file" "$data_file" \
      && display_message "success" "${#found_ids[@]} record(s) removed successfully!" \
      || { display_message "error" "Failed to remove records."; rm -f "$temp_file"; return 1; }
  else
    display_message "info" "No records removed."
  fi
}

