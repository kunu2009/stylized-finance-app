import '../models/finance_models.dart';

class FinanceDataService {
  static final FinanceDataService _instance = FinanceDataService._internal();
  factory FinanceDataService() => _instance;
  FinanceDataService._internal();

  // In-memory data storage (can be replaced with database later)
  List<Transaction> _transactions = [];
  List<Category> _categories = [];
  List<SavingsGoal> _savingsGoals = [];
  List<LendBorrowRecord> _lendBorrowRecords = [];
  
  // Default categories
  final List<Category> _defaultCategories = [
    Category(
      id: '1',
      name: 'Food & Dining',
      icon: '🍽️',
      color: 0xFF8B5CF6,
      budgetAmount: 0.0,
      type: TransactionType.expense,
    ),
    Category(
      id: '2',
      name: 'Shopping',
      icon: '🛍️',
      color: 0xFFFFB800,
      budgetAmount: 0.0,
      type: TransactionType.expense,
    ),
    Category(
      id: '3',
      name: 'Transportation',
      icon: '🚗',
      color: 0xFF06D6A0,
      budgetAmount: 0.0,
      type: TransactionType.expense,
    ),
    Category(
      id: '4',
      name: 'Entertainment',
      icon: '🎬',
      color: 0xFFFF6B9D,
      budgetAmount: 0.0,
      type: TransactionType.expense,
    ),
    Category(
      id: '5',
      name: 'Bills & Utilities',
      icon: '📱',
      color: 0xFFFF4757,
      budgetAmount: 0.0,
      type: TransactionType.expense,
    ),
    Category(
      id: '6',
      name: 'Salary',
      icon: '💼',
      color: 0xFF06D6A0,
      budgetAmount: 0.0,
      type: TransactionType.income,
    ),
    Category(
      id: '7',
      name: 'Freelance',
      icon: '💻',
      color: 0xFF8B5CF6,
      budgetAmount: 0.0,
      type: TransactionType.income,
    ),
    Category(
      id: '8',
      name: 'Investment',
      icon: '📈',
      color: 0xFFFFB800,
      budgetAmount: 0.0,
      type: TransactionType.income,
    ),
  ];

  // Initialize data
  Future<void> initializeData() async {
    if (_categories.isEmpty) {
      _categories = List.from(_defaultCategories);
    }
  }

  // Getters
  List<Transaction> get transactions => List.unmodifiable(_transactions);
  List<Category> get categories => List.unmodifiable(_categories);
  List<SavingsGoal> get savingsGoals => List.unmodifiable(_savingsGoals);
  List<LendBorrowRecord> get lendBorrowRecords => List.unmodifiable(_lendBorrowRecords);

  // Financial Summary
  FinancialSummary getFinancialSummary() {
    double totalIncome = _transactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
    
    double totalExpense = _transactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
    
    double totalLent = _transactions
        .where((t) => t.type == TransactionType.lent)
        .fold(0.0, (sum, t) => sum + t.amount);
    
    double totalBorrowed = _transactions
        .where((t) => t.type == TransactionType.borrowed)
        .fold(0.0, (sum, t) => sum + t.amount);

    double lentReturns = _transactions
        .where((t) => t.type == TransactionType.lentReturn)
        .fold(0.0, (sum, t) => sum + t.amount);
    
    double borrowReturns = _transactions
        .where((t) => t.type == TransactionType.borrowReturn)
        .fold(0.0, (sum, t) => sum + t.amount);

    double pendingLent = totalLent - lentReturns;
    double pendingBorrowed = totalBorrowed - borrowReturns;
    double totalBalance = totalIncome - totalExpense + totalBorrowed - totalLent + lentReturns - borrowReturns;

    return FinancialSummary(
      totalBalance: totalBalance,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      totalLent: totalLent,
      totalBorrowed: totalBorrowed,
      pendingLentAmount: pendingLent,
      pendingBorrowedAmount: pendingBorrowed,
    );
  }

  // Add transaction
  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    _transactions.sort((a, b) => b.date.compareTo(a.date));
  }

  // Update transaction
  void updateTransaction(Transaction updatedTransaction) {
    final index = _transactions.indexWhere((t) => t.id == updatedTransaction.id);
    if (index != -1) {
      _transactions[index] = updatedTransaction;
      _transactions.sort((a, b) => b.date.compareTo(a.date));
    }
  }

  // Delete transaction
  void deleteTransaction(String id) {
    _transactions.removeWhere((t) => t.id == id);
  }

  // Add category
  void addCategory(Category category) {
    _categories.add(category);
  }

  // Delete category
  void deleteCategory(String name) {
    _categories.removeWhere((c) => c.name == name);
  }

  // Add savings goal
  void addSavingsGoal(SavingsGoal goal) {
    _savingsGoals.add(goal);
  }

  // Add lend/borrow record
  void addLendBorrowRecord(LendBorrowRecord record) {
    _lendBorrowRecords.add(record);
  }

  // Get recent transactions
  List<Transaction> getRecentTransactions({int limit = 5}) {
    return _transactions.take(limit).toList();
  }

  // Get transactions by type
  List<Transaction> getTransactionsByType(TransactionType type) {
    return _transactions.where((t) => t.type == type).toList();
  }

  // Get expense categories
  List<Category> getExpenseCategories() {
    return _categories.where((c) => c.type == TransactionType.expense).toList();
  }

  // Get income categories
  List<Category> getIncomeCategories() {
    return _categories.where((c) => c.type == TransactionType.income).toList();
  }

  // Update category spending
  void updateCategorySpending() {
    for (var category in _categories) {
      // Calculate spent amount for each category
      _transactions
          .where((t) => t.category == category.name && t.type == category.type)
          .fold(0.0, (sum, t) => sum + t.amount);
      
      // Note: Category spending update would need a mutable category model
      // For now, we'll handle this in the UI layer
    }
  }

  // Clear all data
  void clearAllData() {
    _transactions.clear();
    _savingsGoals.clear();
    _lendBorrowRecords.clear();
    _categories = List.from(_defaultCategories);
  }
}