class Transaction {
  final String id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final TransactionType type;
  final String description;
  final String? contactName; // For lending/borrowing

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
    this.description = '',
    this.contactName,
  });
}

enum TransactionType {
  income,
  expense,
  lent,
  borrowed,
  lentReturn, // When someone returns money to you
  borrowReturn, // When you return borrowed money
}

class Category {
  final String id;
  final String name;
  final String icon;
  final int color;
  final double budgetAmount;
  final double spentAmount;
  final TransactionType type;
  final bool isCustom;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.budgetAmount,
    this.spentAmount = 0.0,
    this.type = TransactionType.expense,
    this.isCustom = false,
  });

  double get percentage => budgetAmount > 0 ? (spentAmount / budgetAmount) * 100 : 0;
  double get remainingAmount => budgetAmount - spentAmount;
  double? get budget => budgetAmount > 0 ? budgetAmount : null;
}

class SavingsGoal {
  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime targetDate;
  final int color;

  SavingsGoal({
    required this.id,
    required this.name,
    required this.targetAmount,
    required this.currentAmount,
    required this.targetDate,
    required this.color,
  });

  double get percentage => targetAmount > 0 ? (currentAmount / targetAmount) * 100 : 0;
  double get remainingAmount => targetAmount - currentAmount;
}

class LendBorrowRecord {
  final String id;
  final String contactName;
  final double amount;
  final double remainingAmount;
  final DateTime date;
  final DateTime? dueDate;
  final bool isLent; // true for lent, false for borrowed
  final String description;
  final bool isSettled;

  LendBorrowRecord({
    required this.id,
    required this.contactName,
    required this.amount,
    required this.remainingAmount,
    required this.date,
    this.dueDate,
    required this.isLent,
    this.description = '',
    this.isSettled = false,
  });
}

class FinancialSummary {
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;
  final double totalLent;
  final double totalBorrowed;
  final double totalLentReturned;
  final double totalBorrowReturned;
  final double pendingLentAmount;
  final double pendingBorrowedAmount;

  FinancialSummary({
    this.totalBalance = 0.0,
    this.totalIncome = 0.0,
    this.totalExpense = 0.0,
    this.totalLent = 0.0,
    this.totalBorrowed = 0.0,
    this.totalLentReturned = 0.0,
    this.totalBorrowReturned = 0.0,
    this.pendingLentAmount = 0.0,
    this.pendingBorrowedAmount = 0.0,
  });

  double get netWorth => totalBalance + pendingLentAmount - pendingBorrowedAmount;
}