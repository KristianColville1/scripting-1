#!/usr/bin/bash
#===============================================================================
# File:         messages.sh
# Description:  Message display utilities with color coding
#===============================================================================

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Display colored messages
display_message() {
  local type="$1"
  local message="$2"
  
  case "$type" in
    "error")
      echo -e "${RED}[ERROR]${NC} $message"
      ;;
    "success")
      echo -e "${GREEN}[SUCCESS]${NC} $message"
      ;;
    "warning")
      echo -e "${YELLOW}[WARNING]${NC} $message"
      ;;
    "info")
      echo -e "${BLUE}[INFO]${NC} $message"
      ;;
    *)
      echo "$message"
      ;;
  esac
}

# Clear screen utility
clear_screen() {
  clear
}

# Display welcome banner
display_welcome_banner() {
  clear
  echo -e "${CYAN}========================================${NC}"
  echo -e "${CYAN}   Kristian's Cool Shop${NC}"
  echo -e "${CYAN}   Stock Control System${NC}"
  echo -e "${CYAN}========================================${NC}"
  echo ""
}

