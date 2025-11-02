# Kristian's Cool Shop - Stock Control System

## Overview

A comprehensive multi-portal Linux bash shell script management system for stock control, employee management, support tickets, and orders.

## Project Structure

```
assignment2-comp-sys-net/
├── src/
│   ├── main.sh                    # Main entry point
│   ├── RUN.sh                     # Convenience wrapper
│   │
│   ├── modules/                   # Feature modules
│   │   ├── products/
│   │   │   ├── init.sh           # Data initialization
│   │   │   ├── loader.sh         # Module loader
│   │   │   └── functions/
│   │   │       ├── add.sh        # Create operations
│   │   │       ├── search.sh     # Search operations
│   │   │       ├── view.sh       # Display operations
│   │   │       └── remove.sh     # Delete operations
│   │   │
│   │   ├── employees/
│   │   │   ├── init.sh
│   │   │   ├── loader.sh
│   │   │   └── functions/
│   │   │       ├── add.sh
│   │   │       ├── search.sh
│   │   │       ├── view.sh
│   │   │       └── remove.sh
│   │   │
│   │   ├── tickets/
│   │   │   ├── init.sh
│   │   │   ├── loader.sh
│   │   │   └── functions/
│   │   │       ├── add.sh
│   │   │       ├── search.sh
│   │   │       ├── view.sh
│   │   │       └── remove.sh
│   │   │
│   │   └── orders/
│   │       ├── init.sh
│   │       ├── loader.sh
│   │       └── functions/
│   │           ├── add.sh
│   │           ├── search.sh
│   │           ├── view.sh
│   │           └── remove.sh
│   │
│   ├── ui/                       # User interface
│   │   ├── main_menu.sh
│   │   ├── products_menu.sh
│   │   ├── employees_menu.sh
│   │   ├── tickets_menu.sh
│   │   └── orders_menu.sh
│   │
│   ├── utils/                    # Shared utilities
│   │   ├── validation.sh         # Input validation
│   │   ├── messages.sh           # Display utilities
│   │   └── table_formatter.sh   # Generic table formatter
│   │
│   └── data/                     # Data storage (gitignored)
│       ├── products.txt
│       ├── employees.txt
│       ├── tickets.txt
│       └── orders.txt
│
├── docs/                         # Documentation
│   ├── assignment-spec.pdf
│   ├── talk-1.pdf
│   └── talk-2.pdf
│
├── ideas/                        # Project planning
├── example.sh                    # Reference (gitignored)
├── .gitignore
└── README.md

```

## Features

### Products Management Portal ✅

- **Add Product**: Create new product records with validation

  - Product ID (numeric, unique)
  - Product Name (required)
  - Category (required)
  - Price (decimal validation)
  - Quantity (numeric validation)
  - Supplier details (name, email, phone with validation)
- **Search Products**: Multiple search options

  - Search by Product ID
  - Search by Product Name (case-insensitive)
  - Search by Category
  - Search by Supplier
- **Remove Products**: Two removal methods

  - Remove by Product ID
  - View all and remove by line number
- **View All Products**: Display all products with line numbers

### Employee Management Portal 

- **Add Employee**: Create new employee records with validation

  - Employee ID (numeric, unique)
  - Name (required)
  - Role (required)
  - Department (required)
  - Email (format validation, duplicate detection)
  - Phone (format validation)
  - Hire Date (DD/MM/YYYY format)
- **Search Employees**: Multiple search options

  - Search by Employee ID
  - Search by Name (case-insensitive)
  - Search by Role
  - Search by Department
- **Remove Employees**: Two removal methods

  - Remove by Employee ID
  - View all and remove by line number
- **View All Employees**: Display all employees with line numbers

### Support Tickets Portal (Coming Soon)

- Placeholder menu implemented
- Full CRUD functionality to be added

### Orders Management Portal (Coming Soon)

- Placeholder menu implemented
- Full CRUD functionality to be added

## Validation Features

The system includes comprehensive input validation:

- **Email**: Regex pattern matching for proper format
- **Phone**: 8-15 digit validation with flexibility for separators
- **Numeric**: Integer validation
- **Decimal**: Price/currency validation
- **Date**: DD/MM/YYYY format validation
- **Not Blank**: Required field checking
- **Duplicate Detection**: ID and email uniqueness checking

## User Experience Features

- **Color-Coded Output**: Different colors for different message types

  - Red: Errors
  - Green: Success messages
  - Yellow: Warnings
  - Blue: Info messages
  - Cyan: Headers and banners
  - Magenta: Portal menus
- **Confirmation Prompts**: User confirmation before destructive actions
- **Exit Anywhere**: Type 'exit' at any prompt to cancel or exit
- **Clear Navigation**: Easy return to main menu from all portals
- **No Infinite Loops**: Proper loop termination on valid exit commands
- **Error Recovery**: Clear error messages with retry options

## Running the Script

```bash
cd src
bash main.sh
```

Or make it executable:

```bash
chmod +x src/main.sh
./src/main.sh
```

## Technical Implementation

### Tools Used

- **bash**: Main scripting language
- **awk**: Field extraction, data processing, and dynamic width calculation
- **grep**: Pattern matching and searching
- **sed**: Text manipulation for deletions
- **printf**: Formatted output
- **read**: User input capture

### Design Patterns

- **Modular Architecture**: Each module has functions/ subdirectory
- **Generic Table Formatter**: One utility formats all tables dynamically
- **Dynamic Column Widths**: Awk calculates optimal widths from actual data
- **Data Persistence**: Pipe-delimited text files
- **Error Handling**: Comprehensive validation and user feedback
- **Menu Hierarchy**: Nested menu structure for portal navigation

### Generic Table Formatter

The `utils/table_formatter.sh` provides intelligent table formatting:

- Analyzes data file to find longest value per column
- Calculates optimal column widths with padding
- Generates dynamic printf format strings
- Adds retro yellow asterisk borders
- Works with any pipe-delimited file
- No hardcoded widths - fully adaptive

## Assignment Requirements Coverage

### ✓ Core Requirements

- [X] Menu-based interface
- [X] Add new records (Products & Employees)
- [X] Search records with multiple criteria
- [X] Remove records (single and multiple methods)
- [X] View all records
- [X] Exit at any stage

### ✓ Error Handling (35 points)

- [X] Unexpected data validation
- [X] Return to main menu easily
- [X] Blank field handling
- [X] No infinite loops

### ✓ Usability (20 points)

- [X] Correct input format validation
- [X] Duplicate record detection
- [X] Multiple delete options
- [X] Confirmation prompts
- [X] User-friendly UI with colors
- [X] Case-insensitive search
- [X] Clear navigation

### ✓ Code Quality (15 points)

- [X] Comprehensive code comments
- [X] Proper indentation and spacing
- [X] View functionality for all records
- [ ] Video demonstration (to be created)

## Data Format

Records are stored in pipe-delimited format for easy parsing:

**Products:**

```
ID|Name|Category|Price|Quantity|Supplier|Email|Phone
```

**Employees:**

```
ID|Name|Role|Department|Email|Phone|HireDate
```

## Author

Kristian Colville

## License

This is an academic assignment project.
