# Finance Tracker App

A comprehensive Flutter finance tracker application with modern UI/UX design, featuring automatic recurring transactions, smart reminders, and dark mode support.

## ✨ Features

### Core Features
- **Dashboard**: View total balance, statistics, savings goals, and recent transactions
- **Budget Management**: Track spending across different categories with visual charts
- **Statistics**: Analyze expenses and income with interactive bar charts
- **Transaction Management**: Income, expense, lending, borrowing with full workflow
- **Beautiful UI**: Modern design with gradient cards, smooth animations, and intuitive navigation

### New Advanced Features ✅
- **🔄 Recurring Transactions**: Automate monthly bills, subscriptions, salary (daily/weekly/monthly/yearly)
- **🔔 Smart Reminders**: Get notified about bill due dates, loan payments, savings goals
- **🌙 Dark Mode**: Toggle between light and dark themes for comfortable viewing
- **📊 Import/Export**: Backup and restore your data with JSON files
- **💰 Lending & Borrowing**: Track money lent/borrowed with contact names and due dates

## Screenshots

The app includes three main screens:
1. **Dashboard**: Shows balance card, income/expense statistics, savings goals, and recent transactions
2. **Budget Management**: Displays budget allocation with pie charts and category breakdowns  
3. **Statistics**: Provides detailed expense/income analysis with weekly charts

All amounts are displayed in Indian Rupees (₹).

## 🎯 What's New (October 2, 2025)

Just implemented major new features based on research and competitive analysis:

- **🔄 Recurring Transactions**: Never forget a bill or subscription again! Set daily, weekly, monthly, or yearly auto-transactions
- **🔔 Smart Reminders**: Automatic reminders for loan due dates and savings goals, plus create custom reminders
- **🌙 Dark Mode**: Easy on the eyes with full dark theme support
- **🔍 Advanced Search**: Find any transaction instantly with powerful filters by type, category, and date range
- **📊 Better Analytics**: Enhanced dashboard with notification badges and real-time updates

## Technologies Used

- **Flutter**: Cross-platform mobile development framework
- **fl_chart**: Beautiful charts and graphs for budget visualization
- **intl**: Internationalization and Indian Rupee (₹) formatting
- **percent_indicator**: Progress indicators for savings goals
- **In-memory storage**: Fast and responsive (database coming soon!)

## Getting Started

### Prerequisites
- Flutter SDK installed
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd finance_tracker_app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## 📂 Project Structure

```
lib/
├── main.dart                          # App entry point with theme support
├── models/
│   ├── finance_models.dart            # Core data models
│   ├── recurring_transaction.dart     # ✨ NEW: Recurring transactions
│   └── reminder.dart                  # ✨ NEW: Reminders
├── services/
│   ├── finance_data_service.dart      # Main data management
│   ├── recurring_service.dart         # ✨ NEW: Recurring logic
│   ├── reminder_service.dart          # ✨ NEW: Reminder logic
│   ├── theme_service.dart             # ✨ NEW: Dark mode
│   └── import_export_service.dart     # JSON backup/restore
├── screens/
│   ├── main_screen.dart               # Navigation with search FAB
│   ├── dashboard_screen.dart          # Overview with notification badge
│   ├── budget_screen.dart             # Budget management
│   ├── statistics_screen.dart         # Analytics
│   ├── settings_screen.dart           # Settings hub
│   ├── recurring_screen.dart          # ✨ NEW: Recurring management
│   ├── reminders_screen.dart          # ✨ NEW: Reminder management
│   ├── search_screen.dart             # ✨ NEW: Advanced search
│   └── add_transaction_screen.dart    # Transaction entry
├── widgets/
│   ├── balance_card.dart              # Balance display
│   ├── statistics_card.dart           # Income/expense cards
│   ├── savings_goal_card.dart         # Goal progress
│   ├── transaction_item.dart          # Transaction display
│   └── category_budget_card.dart      # Category cards
└── utils/
    └── data_preloader.dart            # Sample data loader

documentation/
├── RESEARCH.md                        # Competitive analysis
├── FEATURES.md                        # Feature roadmap
└── IMPLEMENTATION_SUMMARY.md          # What was built today
```

## 📋 Features Overview

### 🏠 Dashboard Screen
- Real-time balance display with gradient card
- Monthly income and expense statistics  
- Savings goals progress tracking
- Recent transactions list
- **NEW:** Notification badge for pending reminders
- **NEW:** Search button for quick access

### 💰 Budget Management Screen
- Interactive pie chart showing expense distribution
- Category-wise spending with progress bars
- Dynamic budget allocation
- Visual spending indicators

### 📊 Statistics Screen
- Toggle between expense and income views
- Weekly bar chart visualization
- Weekly summary cards
- Detailed transaction history with filtering

### 🔄 Recurring Transactions (NEW!)
- Set up automatic transactions
- Multiple frequencies: daily, weekly, monthly, yearly
- Auto-processing on app startup
- Pause/resume functionality
- "DUE" badges for pending items

### 🔔 Smart Reminders (NEW!)
- Custom reminders for any purpose
- Auto-generated from loans and goals
- Color-coded by urgency (overdue/today/upcoming)
- Notification count on dashboard
- Mark as completed

### 🔍 Advanced Search (NEW!)
- Real-time search across all transactions
- Filter by transaction type
- Filter by date range
- Active filter chips
- Empty state and no results handling

### ⚙️ Settings & More
- **NEW:** Dark mode toggle
- Import/export JSON data
- Load sample data
- Access to all feature screens
- Clear all data option

## Color Scheme

- Primary Purple: `#4C1D95` and `#7C3AED`
- Accent Gold: `#FFD700` and `#FFA500`
- Success Green: `#06D6A0`
- Warning Pink: `#FF6B9D`
- Background: Light gray `#F9FAFB`

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
