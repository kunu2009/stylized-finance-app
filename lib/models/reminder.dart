enum ReminderType {
  loanDue,
  borrowDue,
  savingsGoal,
  billPayment,
  custom,
}

class Reminder {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final ReminderType type;
  final bool isCompleted;
  final String? relatedId; // ID of related transaction, goal, or record
  final double? amount;

  Reminder({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.type,
    this.isCompleted = false,
    this.relatedId,
    this.amount,
  });

  bool isOverdue() {
    return !isCompleted && DateTime.now().isAfter(dueDate);
  }

  bool isDueToday() {
    final now = DateTime.now();
    return !isCompleted &&
        dueDate.year == now.year &&
        dueDate.month == now.month &&
        dueDate.day == now.day;
  }

  bool isDueThisWeek() {
    final now = DateTime.now();
    final weekFromNow = now.add(const Duration(days: 7));
    return !isCompleted && dueDate.isAfter(now) && dueDate.isBefore(weekFromNow);
  }

  Reminder copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    ReminderType? type,
    bool? isCompleted,
    String? relatedId,
    double? amount,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      type: type ?? this.type,
      isCompleted: isCompleted ?? this.isCompleted,
      relatedId: relatedId ?? this.relatedId,
      amount: amount ?? this.amount,
    );
  }
}
