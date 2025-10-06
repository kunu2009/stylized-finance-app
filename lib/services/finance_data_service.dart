import '../models/finance_models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FinanceDataService {
  static final FinanceDataService _instance = FinanceDataService._internal();
  factory FinanceDataService() => _instance;
  FinanceDataService._internal();

  // In-memory data storage (can be replaced with database later)
  final List<Transaction> _transactions = [];
  List<Category> _categories = [];
  List<Category> _customCategories = [];
  final List<SavingsGoal> _savingsGoals = [];
  final List<LendBorrowRecord> _lendBorrowRecords = [];
  
  // Default categories
  final List<Category> _defaultCategories = [
    Category(
      id: '1',
      name: 'Food & Dining',
      icon: '🍽️',
      color: 0xFF8B5CF6,
      budgetAmount: 0.0,
      type: TransactionType.expense,
      isCustom: false,
    ),
    Category(
      id: '2',
      name: 'Shopping',
      icon: '🛍️',
      color: 0xFFFFB800,
      budgetAmount: 0.0,
      type: TransactionType.expense,
      isCustom: false,
    ),
    Category(
      id: '3',
      name: 'Transportation',
      icon: '🚗',
      color: 0xFF06D6A0,
      budgetAmount: 0.0,
      type: TransactionType.expense,
      isCustom: false,
    ),
    Category(
      id: '4',
      name: 'Entertainment',
      icon: '🎬',
      color: 0xFFFF6B9D,
      budgetAmount: 0.0,
      type: TransactionType.expense,
      isCustom: false,
    ),
    Category(
      id: '5',
      name: 'Bills & Utilities',
      icon: '📱',
      color: 0xFFFF4757,
      budgetAmount: 0.0,
      type: TransactionType.expense,
      isCustom: false,
    ),
    Category(
      id: '6',
      name: 'Salary',
      icon: '💼',
      color: 0xFF06D6A0,
      budgetAmount: 0.0,
      type: TransactionType.income,
      isCustom: false,
    ),
    Category(
      id: '7',
      name: 'Freelance',
      icon: '💻',
      color: 0xFF8B5CF6,
      budgetAmount: 0.0,
      type: TransactionType.income,
      isCustom: false,
    ),
    Category(
      id: '8',
      name: 'Investment',
      icon: '📈',
      color: 0xFFFFB800,
      budgetAmount: 0.0,
      type: TransactionType.income,
      isCustom: false,
    ),
  ];

  // Initialize data
  Future<void> initializeData() async {
    if (_categories.isEmpty) {
      _categories = List.from(_defaultCategories);
      await _loadCustomCategories();
      await _loadCategoryBudgets();
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
      totalLentReturned: lentReturns,
      totalBorrowReturned: borrowReturns,
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

  // Update category budget
  Future<void> updateCategoryBudget(String categoryName, double newBudget) async {
    final index = _categories.indexWhere((c) => c.name == categoryName);
    if (index != -1) {
      final category = _categories[index];
      _categories[index] = Category(
        id: category.id,
        name: category.name,
        icon: category.icon,
        color: category.color,
        budgetAmount: newBudget,
        type: category.type,
        isCustom: category.isCustom,
      );
      
      // Save to SharedPreferences for persistence
      try {
        final prefs = await SharedPreferences.getInstance();
        final budgetsMap = <String, double>{};
        
        // Load existing budgets
        final budgetsJson = prefs.getString('category_budgets');
        if (budgetsJson != null) {
          final decoded = json.decode(budgetsJson) as Map<String, dynamic>;
          decoded.forEach((key, value) {
            budgetsMap[key] = value as double;
          });
        }
        
        // Update budget
        budgetsMap[categoryName] = newBudget;
        
        // Save back
        await prefs.setString('category_budgets', json.encode(budgetsMap));
      } catch (e) {
        print('Error saving category budget: $e');
      }
    }
  }

  // Load category budgets from SharedPreferences
  Future<void> _loadCategoryBudgets() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final budgetsJson = prefs.getString('category_budgets');
      
      if (budgetsJson != null) {
        final Map<String, dynamic> budgetsMap = json.decode(budgetsJson);
        
        for (int i = 0; i < _categories.length; i++) {
          final category = _categories[i];
          if (budgetsMap.containsKey(category.name)) {
            _categories[i] = Category(
              id: category.id,
              name: category.name,
              icon: category.icon,
              color: category.color,
              budgetAmount: budgetsMap[category.name] as double,
              type: category.type,
              isCustom: category.isCustom,
            );
          }
        }
      }
    } catch (e) {
      print('Error loading category budgets: $e');
    }
  }

  // Clear all data
  void clearAllData() {
    _transactions.clear();
    _savingsGoals.clear();
    _lendBorrowRecords.clear();
    _categories = List.from(_defaultCategories);
  }

  // ==================== Custom Categories Management ====================

  // Load custom categories from SharedPreferences
  Future<void> _loadCustomCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final customCategoriesJson = prefs.getString('custom_categories');
      
      if (customCategoriesJson != null) {
        final List<dynamic> decoded = json.decode(customCategoriesJson);
        _customCategories = decoded.map((item) {
          return Category(
            id: item['id'],
            name: item['name'],
            icon: item['icon'],
            color: item['color'],
            budgetAmount: item['budgetAmount'] ?? 0.0,
            type: item['type'] == 'income' ? TransactionType.income : TransactionType.expense,
            isCustom: true,
          );
        }).toList();
        
        // Add custom categories to main categories list
        _categories.addAll(_customCategories);
      }
    } catch (e) {
      print('Error loading custom categories: $e');
    }
  }

  // Save custom categories to SharedPreferences
  Future<void> _saveCustomCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final customCategoriesJson = json.encode(
        _customCategories.map((category) {
          return {
            'id': category.id,
            'name': category.name,
            'icon': category.icon,
            'color': category.color,
            'budgetAmount': category.budgetAmount,
            'type': category.type == TransactionType.income ? 'income' : 'expense',
          };
        }).toList(),
      );
      await prefs.setString('custom_categories', customCategoriesJson);
    } catch (e) {
      print('Error saving custom categories: $e');
    }
  }

  // Add custom category
  Future<void> addCustomCategory(Category category) async {
    _customCategories.add(category);
    _categories.add(category);
    await _saveCustomCategories();
  }

  // Update custom category
  Future<void> updateCustomCategory(Category updatedCategory) async {
    // Remove old version from both lists
    _customCategories.removeWhere((c) => c.id == updatedCategory.id);
    _categories.removeWhere((c) => c.id == updatedCategory.id);
    
    // Add updated version
    _customCategories.add(updatedCategory);
    _categories.add(updatedCategory);
    
    await _saveCustomCategories();
  }

  // Delete category (updated to handle both default check and type)
  void deleteCategory(String name, TransactionType type) {
    // Don't allow deleting default categories
    if (isDefaultCategory(name, type)) {
      return;
    }
    
    _customCategories.removeWhere((c) => c.name == name);
    _categories.removeWhere((c) => c.name == name);
    _saveCustomCategories();
  }

  // Check if category is a default category
  bool isDefaultCategory(String name, TransactionType type) {
    return _defaultCategories.any((c) => c.name == name && c.type == type);
  }

  // Get all custom categories
  List<Category> getCustomCategories() {
    return List.unmodifiable(_customCategories);
  }

  // Get custom categories by type
  List<Category> getCustomCategoriesByType(TransactionType type) {
    return _customCategories.where((c) => c.type == type).toList();
  }
}