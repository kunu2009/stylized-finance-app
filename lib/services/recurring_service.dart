import '../models/finance_models.dart';
import '../models/recurring_transaction.dart';
import 'finance_data_service.dart';

class RecurringService {
  static final RecurringService _instance = RecurringService._internal();
  factory RecurringService() => _instance;
  RecurringService._internal();

  final FinanceDataService _dataService = FinanceDataService();
  final List<RecurringTransaction> _recurringTransactions = [];

  List<RecurringTransaction> get recurringTransactions => 
      List.unmodifiable(_recurringTransactions);

  void addRecurringTransaction(RecurringTransaction recurring) {
    _recurringTransactions.add(recurring);
  }

  void removeRecurringTransaction(String id) {
    _recurringTransactions.removeWhere((r) => r.id == id);
  }

  void updateRecurringTransaction(RecurringTransaction recurring) {
    final index = _recurringTransactions.indexWhere((r) => r.id == recurring.id);
    if (index != -1) {
      _recurringTransactions[index] = recurring;
    }
  }

  List<RecurringTransaction> getDueTransactions() {
    return _recurringTransactions.where((r) => r.isDueToday()).toList();
  }

  List<RecurringTransaction> getActiveTransactions() {
    return _recurringTransactions.where((r) => r.isActive).toList();
  }

  // Process all due recurring transactions
  Future<int> processDueTransactions() async {
    final dueTransactions = getDueTransactions();
    int processedCount = 0;

    for (final recurring in dueTransactions) {
      // Create actual transaction
      final transaction = Transaction(
        id: '${DateTime.now().millisecondsSinceEpoch}_${recurring.id}',
        title: recurring.title,
        amount: recurring.amount,
        category: recurring.category,
        date: DateTime.now(),
        type: recurring.type,
        description: '${recurring.description} (Recurring)',
      );

      _dataService.addTransaction(transaction);

      // Update last processed date
      final updated = recurring.copyWith(lastProcessed: DateTime.now());
      updateRecurringTransaction(updated);
      
      processedCount++;
    }

    return processedCount;
  }

  void clearAllRecurring() {
    _recurringTransactions.clear();
  }
}
