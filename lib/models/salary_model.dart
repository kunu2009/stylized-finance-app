class MonthlySalary {
  final String id;
  final double amount;
  final int paymentDay; // Day of month (1-31)
  final DateTime month; // Month and year for this salary
  final String description;
  final DateTime createdAt;

  MonthlySalary({
    required this.id,
    required this.amount,
    required this.paymentDay,
    required this.month,
    this.description = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Get the actual payment date for this month
  DateTime get paymentDate {
    final year = month.year;
    final monthNum = month.month;
    
    // Handle months with fewer days
    final lastDayOfMonth = DateTime(year, monthNum + 1, 0).day;
    final actualDay = paymentDay > lastDayOfMonth ? lastDayOfMonth : paymentDay;
    
    return DateTime(year, monthNum, actualDay);
  }

  // Check if this salary has been paid (payment date has passed)
  bool get isPaid {
    final now = DateTime.now();
    final payment = paymentDate;
    return now.isAfter(payment) || now.isAtSameMomentAs(payment);
  }

  // Get days until payment
  int get daysUntilPayment {
    final now = DateTime.now();
    final payment = paymentDate;
    return payment.difference(now).inDays;
  }

  // Copy with method for updates
  MonthlySalary copyWith({
    String? id,
    double? amount,
    int? paymentDay,
    DateTime? month,
    String? description,
    DateTime? createdAt,
  }) {
    return MonthlySalary(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      paymentDay: paymentDay ?? this.paymentDay,
      month: month ?? this.month,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'paymentDay': paymentDay,
      'month': month.toIso8601String(),
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory MonthlySalary.fromJson(Map<String, dynamic> json) {
    return MonthlySalary(
      id: json['id'],
      amount: json['amount'],
      paymentDay: json['paymentDay'],
      month: DateTime.parse(json['month']),
      description: json['description'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class SalaryExpenseTracker {
  final MonthlySalary salary;
  final double totalExpenses;
  final double totalIncome; // Additional income in this month
  final List<String> expenseTransactionIds;

  SalaryExpenseTracker({
    required this.salary,
    required this.totalExpenses,
    this.totalIncome = 0.0,
    required this.expenseTransactionIds,
  });

  double get remainingAmount => salary.amount + totalIncome - totalExpenses;
  
  double get spentPercentage => salary.amount > 0 
      ? (totalExpenses / salary.amount) * 100 
      : 0;
  
  double get availableAmount => salary.amount + totalIncome;
  
  bool get isOverspent => remainingAmount < 0;
  
  int get daysInMonth {
    final month = salary.month;
    return DateTime(month.year, month.month + 1, 0).day;
  }
  
  int get daysRemaining {
    final now = DateTime.now();
    final month = salary.month;
    final lastDay = DateTime(month.year, month.month + 1, 0);
    
    if (now.isAfter(lastDay)) return 0;
    return lastDay.difference(now).inDays + 1;
  }
  
  double get averageDailySpending => daysInMonth > 0 
      ? totalExpenses / (daysInMonth - daysRemaining + 1)
      : 0;
  
  double get projectedMonthlySpending => averageDailySpending * daysInMonth;
  
  double get recommendedDailyBudget => daysRemaining > 0 
      ? remainingAmount / daysRemaining 
      : 0;
}
