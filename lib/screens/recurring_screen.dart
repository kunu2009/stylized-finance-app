import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/recurring_transaction.dart';
import '../services/recurring_service.dart';
import 'add_recurring_screen.dart';

class RecurringScreen extends StatefulWidget {
  const RecurringScreen({super.key});

  @override
  State<RecurringScreen> createState() => _RecurringScreenState();
}

class _RecurringScreenState extends State<RecurringScreen> {
  final RecurringService _recurringService = RecurringService();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final recurringList = _recurringService.getActiveTransactions();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Recurring Transactions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              final processed = await _recurringService.processDueTransactions();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Processed $processed due transactions'),
                    backgroundColor: Colors.green,
                  ),
                );
                setState(() {});
              }
            },
          ),
        ],
      ),
      body: recurringList.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: recurringList.length,
              itemBuilder: (context, index) {
                return _buildRecurringCard(recurringList[index]);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddRecurringScreen(),
            ),
          );
          if (result == true) {
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.repeat, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Recurring Transactions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add monthly bills, subscriptions, etc.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecurringCard(RecurringTransaction recurring) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nextDue = recurring.getNextDueDate();
    final isDue = recurring.isDueToday();

    return Card(
      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isDue ? Colors.orange.withOpacity(0.1) : Colors.purple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.repeat,
            color: isDue ? Colors.orange : Colors.purple,
          ),
        ),
        title: Text(
          recurring.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getFrequencyText(recurring.frequency),
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white60 : Colors.grey[600],
              ),
            ),
            if (nextDue != null)
              Text(
                'Next: ${DateFormat('MMM dd, yyyy').format(nextDue)}',
                style: TextStyle(
                  fontSize: 12,
                  color: isDue ? Colors.orange : (isDark ? Colors.white38 : Colors.grey[500]),
                  fontWeight: isDue ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₹${NumberFormat('#,##0').format(recurring.amount)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: recurring.type.toString().contains('income') 
                    ? Colors.green 
                    : Colors.red,
              ),
            ),
            if (isDue)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'DUE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        onTap: () {
          _showRecurringOptions(recurring);
        },
      ),
    );
  }

  String _getFrequencyText(RecurringFrequency frequency) {
    switch (frequency) {
      case RecurringFrequency.daily:
        return 'Daily';
      case RecurringFrequency.weekly:
        return 'Weekly';
      case RecurringFrequency.monthly:
        return 'Monthly';
      case RecurringFrequency.yearly:
        return 'Yearly';
    }
  }

  void _showRecurringOptions(RecurringTransaction recurring) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.pause, color: Colors.orange),
            title: const Text('Pause'),
            onTap: () {
              Navigator.pop(context);
              _toggleActive(recurring);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text('Delete'),
            onTap: () {
              Navigator.pop(context);
              _deleteRecurring(recurring);
            },
          ),
        ],
      ),
    );
  }

  void _toggleActive(RecurringTransaction recurring) {
    final updated = recurring.copyWith(isActive: !recurring.isActive);
    _recurringService.updateRecurringTransaction(updated);
    setState(() {});
  }

  void _deleteRecurring(RecurringTransaction recurring) {
    _recurringService.removeRecurringTransaction(recurring.id);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Recurring transaction deleted'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
