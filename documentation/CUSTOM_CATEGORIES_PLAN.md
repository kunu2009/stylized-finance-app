# Custom Category Management - Implementation Guide

## Feature Request
User wants ability to add custom categories for Income and Expense transactions.

## Current State
- App has predefined categories in `finance_data_service.dart`
- Income categories: Salary, Freelance, Business, Investments
- Expense categories: Food, Transport, Shopping, Bills, Entertainment, etc.
- Lending/Borrowing: Lending, Borrowing

## What Needs to Be Built

### 1. Category Management Screen
**Location**: `lib/screens/manage_categories_screen.dart`

**Features**:
- List all existing categories (Income & Expense separately)
- Add button to create new category
- Delete button for custom categories (can't delete default ones)
- Category icon picker
- Category color picker

### 2. Add Category Dialog/Screen
**Location**: `lib/screens/add_category_screen.dart`

**Fields**:
- Category Name (text input)
- Category Type (Income/Expense dropdown)
- Icon (emoji picker or predefined icons)
- Color (color picker with presets)
- Initial Budget (optional, number input)

### 3. Data Service Updates
**File**: `lib/services/finance_data_service.dart`

**New Methods**:
```dart
void addCustomCategory(Category category)
bool isDefaultCategory(String categoryName)
List<Category> getCustomCategories()
```

### 4. Storage Implementation
**Challenge**: Categories need to persist across app restarts

**Options**:
1. **Shared Preferences** (current approach for settings)
   - Store as JSON array
   - Load on app start
   
2. **Local Database** (better for scalability)
   - Use sqflite package
   - Create categories table

**Recommended**: Shared Preferences for simplicity

### 5. UI Integration Points

**Settings Screen**:
- Add "Manage Categories" button
- Opens CategoryManagementScreen

**Add Transaction Screen**:
- Category dropdown should include custom categories
- Group by type (Income/Expense)

**Budget Screen**:
- Allow setting budgets for custom categories

## Implementation Steps

### Step 1: Create Category Management Screen (30 min)
```dart
// lib/screens/manage_categories_screen.dart
- Display tabs: Income | Expense
- List categories in each tab
- FAB to add new category
- Swipe to delete (custom only)
```

### Step 2: Create Add/Edit Category Screen (20 min)
```dart
// lib/screens/add_category_screen.dart
- Text field for name
- Dropdown for type
- Grid of emoji icons
- Color picker (use flutter_colorpicker package)
- Save button
```

### Step 3: Update Data Service (15 min)
```dart
// Add methods to:
- Save categories to SharedPreferences
- Load categories on init
- Merge default + custom categories
- Validate no duplicates
```

### Step 4: Update Transaction Screen (10 min)
```dart
// lib/screens/add_transaction_screen.dart
- Update category dropdown to include custom
- Group categories by type
- Show custom categories with their icons
```

### Step 5: Add Icon & Color Pickers (25 min)
```dart
// Create picker widgets:
- EmojiIconPicker (grid of emojis)
- ColorPicker (use flutter_colorpicker)
- Return selected value to Add Category screen
```

## Packages Needed

```yaml
# pubspec.yaml
dependencies:
  flutter_colorpicker: ^1.1.0  # For color selection
  # OR
  flex_color_picker: ^3.6.0     # Alternative with better UX
```

## Data Structure

### Category Model (Already exists in finance_models.dart)
```dart
class Category {
  final String name;
  final String icon;
  final int color;  // Store as int (Color.value)
  final double budgetAmount;
  final double spentAmount;
  final double percentage;
  final bool isCustom;  // Add this field
  
  Category({
    required this.name,
    required this.icon,
    required this.color,
    this.budgetAmount = 0,
    this.spentAmount = 0,
    this.percentage = 0,
    this.isCustom = false,  // Default categories = false
  });
}
```

### Storage Format (SharedPreferences)
```json
{
  "custom_categories": [
    {
      "name": "Rent",
      "type": "expense",
      "icon": "🏠",
      "color": 4294901760,
      "budgetAmount": 15000
    },
    {
      "name": "Gift",
      "type": "income",
      "icon": "🎁",
      "color": 4294198070,
      "budgetAmount": 0
    }
  ]
}
```

## Default Categories (Don't Allow Delete)
```dart
final List<String> defaultIncomeCategories = [
  'Salary', 'Freelance', 'Business', 'Investments', 'Other Income'
];

final List<String> defaultExpenseCategories = [
  'Food', 'Transport', 'Shopping', 'Bills', 'Entertainment', 
  'Healthcare', 'Education', 'Other'
];
```

## User Experience Flow

1. **User opens Settings**
2. **Taps "Manage Categories"**
3. **Sees two tabs: Income | Expense**
4. **Taps FAB (+) to add category**
5. **Enters name, selects icon & color**
6. **Saves category**
7. **Category appears in list**
8. **When adding transaction, new category is available**
9. **Can delete custom categories by swiping**

## Validation Rules

- ✅ Category name required
- ✅ Category name must be unique
- ✅ Icon required
- ✅ Color required
- ✅ Can't delete default categories
- ✅ Can't create category with same name as default

## Error Handling

- Show SnackBar on duplicate name
- Show SnackBar on successful creation
- Confirm dialog before deleting category
- Warn if deleting category that has transactions

## Estimated Time: 1.5 - 2 hours

## Priority: HIGH (User explicitly requested this)

---

Would you like me to implement this feature now?
