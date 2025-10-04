import '../models/reminder.dart';
import 'finance_data_service.dart';

class ReminderService {
  static final ReminderService _instance = ReminderService._internal();
  factory ReminderService() => _instance;
  ReminderService._internal();

  final FinanceDataService _dataService = FinanceDataService();
  final List<Reminder> _reminders = [];

  List<Reminder> get reminders => List.unmodifiable(_reminders);

  void addReminder(Reminder reminder) {
    _reminders.add(reminder);
    _reminders.sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  void removeReminder(String id) {
    _reminders.removeWhere((r) => r.id == id);
  }

  void updateReminder(Reminder reminder) {
    final index = _reminders.indexWhere((r) => r.id == reminder.id);
    if (index != -1) {
      _reminders[index] = reminder;
      _reminders.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    }
  }

  void markAsCompleted(String id) {
    final index = _reminders.indexWhere((r) => r.id == id);
    if (index != -1) {
      _reminders[index] = _reminders[index].copyWith(isCompleted: true);
    }
  }

  List<Reminder> getOverdueReminders() {
    return _reminders.where((r) => r.isOverdue()).toList();
  }

  List<Reminder> getTodayReminders() {
    return _reminders.where((r) => r.isDueToday()).toList();
  }

  List<Reminder> getUpcomingReminders() {
    return _reminders.where((r) => r.isDueThisWeek() && !r.isDueToday()).toList();
  }

  List<Reminder> getActiveReminders() {
    return _reminders.where((r) => !r.isCompleted).toList();
  }

  int getNotificationCount() {
    return getOverdueReminders().length + getTodayReminders().length;
  }

  // Auto-generate reminders from lend/borrow records
  void generateRemindersFromRecords() {
    final records = _dataService.lendBorrowRecords;
    
    for (final record in records) {
      if (!record.isSettled && record.dueDate != null) {
        // Check if reminder already exists
        final exists = _reminders.any((r) => r.relatedId == record.id);
        if (!exists) {
          final reminder = Reminder(
            id: 'reminder_${record.id}',
            title: record.isLent ? 'Payment Due: ${record.contactName}' : 'Loan Due: ${record.contactName}',
            description: record.isLent 
                ? '${record.contactName} owes you ₹${record.remainingAmount}'
                : 'You owe ${record.contactName} ₹${record.remainingAmount}',
            dueDate: record.dueDate!,
            type: record.isLent ? ReminderType.loanDue : ReminderType.borrowDue,
            relatedId: record.id,
            amount: record.remainingAmount,
          );
          addReminder(reminder);
        }
      }
    }
  }

  // Auto-generate reminders from savings goals
  void generateRemindersFromGoals() {
    final goals = _dataService.savingsGoals;
    
    for (final goal in goals) {
      if (goal.currentAmount < goal.targetAmount) {
        // Check if reminder already exists
        final exists = _reminders.any((r) => r.relatedId == goal.id);
        if (!exists) {
          final reminder = Reminder(
            id: 'reminder_${goal.id}',
            title: 'Savings Goal: ${goal.name}',
            description: 'Target date approaching. ₹${goal.remainingAmount} remaining',
            dueDate: goal.targetDate,
            type: ReminderType.savingsGoal,
            relatedId: goal.id,
            amount: goal.remainingAmount,
          );
          addReminder(reminder);
        }
      }
    }
  }

  void clearAllReminders() {
    _reminders.clear();
  }
}
