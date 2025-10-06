import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/salary_model.dart';
import '../models/finance_models.dart';

class SalaryService {
  static const String _salaryKey = 'monthly_salaries';
  static const String _defaultPaymentDayKey = 'default_payment_day';
  
  // Singleton pattern
  static final SalaryService _instance = SalaryService._internal();
  factory SalaryService() => _instance;
  SalaryService._internal();

  List<MonthlySalary> _salaries = [];
  int _defaultPaymentDay = 1;

  // Initialize and load saved salaries
  Future<void> initialize() async {
    await _loadSalaries();
    await _loadDefaultPaymentDay();
  }

  // Load salaries from storage
  Future<void> _loadSalaries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final salariesJson = prefs.getString(_salaryKey);
      
      if (salariesJson != null) {
        final List<dynamic> decoded = json.decode(salariesJson);
        _salaries = decoded.map((json) => MonthlySalary.fromJson(json)).toList();
        
        // Sort by month (newest first)
        _salaries.sort((a, b) => b.month.compareTo(a.month));
      }
    } catch (e) {
      print('Error loading salaries: $e');
      _salaries = [];
    }
  }

  // Save salaries to storage
  Future<void> _saveSalaries() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final salariesJson = json.encode(_salaries.map((s) => s.toJson()).toList());
      await prefs.setString(_salaryKey, salariesJson);
    } catch (e) {
      print('Error saving salaries: $e');
    }
  }

  // Load default payment day
  Future<void> _loadDefaultPaymentDay() async {
    final prefs = await SharedPreferences.getInstance();
    _defaultPaymentDay = prefs.getInt(_defaultPaymentDayKey) ?? 1;
  }

  // Save default payment day
  Future<void> setDefaultPaymentDay(int day) async {
    _defaultPaymentDay = day;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_defaultPaymentDayKey, day);
  }

  int get defaultPaymentDay => _defaultPaymentDay;

  // Add or update salary for a month
  Future<void> setSalary({
    required double amount,
    required int paymentDay,
    DateTime? month,
    String description = '',
  }) async {
    final targetMonth = month ?? DateTime.now();
    final normalizedMonth = DateTime(targetMonth.year, targetMonth.month, 1);
    
    // Check if salary already exists for this month
    final existingIndex = _salaries.indexWhere((s) => 
      s.month.year == normalizedMonth.year && 
      s.month.month == normalizedMonth.month
    );

    if (existingIndex >= 0) {
      // Update existing salary
      _salaries[existingIndex] = _salaries[existingIndex].copyWith(
        amount: amount,
        paymentDay: paymentDay,
        description: description,
      );
    } else {
      // Add new salary
      final salary = MonthlySalary(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        amount: amount,
        paymentDay: paymentDay,
        month: normalizedMonth,
        description: description,
      );
      _salaries.insert(0, salary);
    }

    await _saveSalaries();
  }

  // Get salary for a specific month
  MonthlySalary? getSalaryForMonth(DateTime month) {
    final normalizedMonth = DateTime(month.year, month.month, 1);
    
    try {
      return _salaries.firstWhere((s) => 
        s.month.year == normalizedMonth.year && 
        s.month.month == normalizedMonth.month
      );
    } catch (e) {
      return null;
    }
  }

  // Get current month's salary
  MonthlySalary? getCurrentSalary() {
    return getSalaryForMonth(DateTime.now());
  }

  // Get salary expense tracker for a specific month
  SalaryExpenseTracker? getExpenseTracker(
    DateTime month,
    List<Transaction> allTransactions,
  ) {
    final salary = getSalaryForMonth(month);
    if (salary == null) return null;

    final normalizedMonth = DateTime(month.year, month.month, 1);
    final nextMonth = DateTime(month.year, month.month + 1, 1);

    // Filter transactions for this month
    final monthTransactions = allTransactions.where((t) => 
      t.date.isAfter(normalizedMonth.subtract(const Duration(days: 1))) &&
      t.date.isBefore(nextMonth)
    ).toList();

    // Calculate total expenses (exclude lent/borrowed)
    final expenses = monthTransactions
        .where((t) => t.type == TransactionType.expense)
        .fold<double>(0, (sum, t) => sum + t.amount);

    // Calculate additional income (exclude salary income if marked)
    final additionalIncome = monthTransactions
        .where((t) => t.type == TransactionType.income && !t.title.toLowerCase().contains('salary'))
        .fold<double>(0, (sum, t) => sum + t.amount);

    return SalaryExpenseTracker(
      salary: salary,
      totalExpenses: expenses,
      totalIncome: additionalIncome,
      expenseTransactionIds: monthTransactions
          .where((t) => t.type == TransactionType.expense)
          .map((t) => t.id)
          .toList(),
    );
  }

  // Get current month's expense tracker
  SalaryExpenseTracker? getCurrentExpenseTracker(List<Transaction> allTransactions) {
    return getExpenseTracker(DateTime.now(), allTransactions);
  }

  // Delete salary for a month
  Future<void> deleteSalary(DateTime month) async {
    final normalizedMonth = DateTime(month.year, month.month, 1);
    _salaries.removeWhere((s) => 
      s.month.year == normalizedMonth.year && 
      s.month.month == normalizedMonth.month
    );
    await _saveSalaries();
  }

  // Get all salaries
  List<MonthlySalary> getAllSalaries() {
    return List.unmodifiable(_salaries);
  }

  // Check if salary is set for current month
  bool hasCurrentSalary() {
    return getCurrentSalary() != null;
  }

  // Auto-generate salary for next month based on current/previous
  Future<void> autoGenerateNextMonthSalary() async {
    final now = DateTime.now();
    final nextMonth = DateTime(now.year, now.month + 1, 1);
    
    // Check if next month already has salary
    if (getSalaryForMonth(nextMonth) != null) return;

    // Get current or most recent salary
    final currentSalary = getCurrentSalary();
    if (currentSalary == null && _salaries.isEmpty) return;

    final referenceSalary = currentSalary ?? _salaries.first;

    // Create salary for next month with same amount and payment day
    await setSalary(
      amount: referenceSalary.amount,
      paymentDay: referenceSalary.paymentDay,
      month: nextMonth,
      description: 'Auto-generated from previous month',
    );
  }
}
