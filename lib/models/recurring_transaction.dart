import 'finance_models.dart';

enum RecurringFrequency {
  daily,
  weekly,
  monthly,
  yearly,
}

class RecurringTransaction {
  final String id;
  final String title;
  final double amount;
  final String category;
  final TransactionType type;
  final String description;
  final RecurringFrequency frequency;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  final DateTime? lastProcessed;

  RecurringTransaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.type,
    required this.description,
    required this.frequency,
    required this.startDate,
    this.endDate,
    this.isActive = true,
    this.lastProcessed,
  });

  DateTime? getNextDueDate() {
    if (!isActive) return null;
    
    final baseDate = lastProcessed ?? startDate;
    DateTime nextDate;

    switch (frequency) {
      case RecurringFrequency.daily:
        nextDate = baseDate.add(const Duration(days: 1));
        break;
      case RecurringFrequency.weekly:
        nextDate = baseDate.add(const Duration(days: 7));
        break;
      case RecurringFrequency.monthly:
        nextDate = DateTime(baseDate.year, baseDate.month + 1, baseDate.day);
        break;
      case RecurringFrequency.yearly:
        nextDate = DateTime(baseDate.year + 1, baseDate.month, baseDate.day);
        break;
    }

    // Check if past end date
    if (endDate != null && nextDate.isAfter(endDate!)) {
      return null;
    }

    return nextDate;
  }

  bool isDueToday() {
    final nextDue = getNextDueDate();
    if (nextDue == null) return false;
    
    final now = DateTime.now();
    return nextDue.year == now.year && 
           nextDue.month == now.month && 
           nextDue.day == now.day;
  }

  RecurringTransaction copyWith({
    String? id,
    String? title,
    double? amount,
    String? category,
    TransactionType? type,
    String? description,
    RecurringFrequency? frequency,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    DateTime? lastProcessed,
  }) {
    return RecurringTransaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      type: type ?? this.type,
      description: description ?? this.description,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      lastProcessed: lastProcessed ?? this.lastProcessed,
    );
  }
}
