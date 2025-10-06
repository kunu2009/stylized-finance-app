import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/finance_models.dart';
import '../models/salary_model.dart';
import '../services/finance_data_service.dart';
import '../services/reminder_service.dart';
import '../services/salary_service.dart';
import '../widgets/balance_card.dart';
import '../widgets/statistics_card.dart';
import '../widgets/savings_goal_card.dart';
import '../widgets/transaction_item.dart';
import 'add_transaction_screen.dart';
import 'edit_transaction_screen.dart';
import 'reminders_screen.dart';
import 'search_screen.dart';
import 'all_transactions_screen.dart';
import 'lending_manager_screen.dart';
import 'salary_management_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FinanceDataService _dataService = FinanceDataService();
  final ReminderService _reminderService = ReminderService();
  final SalaryService _salaryService = SalaryService();
  FinancialSummary _summary = FinancialSummary();
  List<Transaction> _recentTransactions = [];
  List<SavingsGoal> _savingsGoals = [];
  SalaryExpenseTracker? _salaryTracker;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _dataService.initializeData();
    await _salaryService.initialize();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _summary = _dataService.getFinancialSummary();
      _recentTransactions = _dataService.getRecentTransactions();
      _savingsGoals = _dataService.savingsGoals;
      _salaryTracker = _salaryService.getCurrentExpenseTracker(
        _dataService.transactions.toList(),
      );
    });
  }

  Future<void> _navigateToAddTransaction() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
    );
    
    if (result == true) {
      _refreshData();
    }
  }

  Future<void> _deleteTransaction(Transaction transaction) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Transaction'),
        content: const Text('Are you sure you want to delete this transaction?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _dataService.deleteTransaction(transaction.id);
      _refreshData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transaction deleted'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }

  Future<void> _editTransaction(Transaction transaction) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTransactionScreen(transaction: transaction),
      ),
    );

    if (result == true) {
      _refreshData();
    }
  }

  void _showTransactionOptions(Transaction transaction) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: Icon(Icons.edit, color: isDark ? Colors.white : Colors.black),
              title: Text('Edit', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
              onTap: () {
                Navigator.pop(context);
                _editTransaction(transaction);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _deleteTransaction(transaction);
              },
            ),
            ListTile(
              leading: Icon(Icons.close, color: isDark ? Colors.white : Colors.black),
              title: Text('Cancel', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: const Color(0xFF4C1D95),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? Colors.white60 : Colors.grey,
                          ),
                        ),
                        Text(
                          '7K',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SearchScreen()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(Icons.search, color: isDark ? Colors.white : Colors.black),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RemindersScreen()),
                          );
                        },
                        child: Stack(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Icon(Icons.notifications_outlined, color: isDark ? Colors.white : Colors.black),
                            ),
                        if (_reminderService.getNotificationCount() > 0)
                          Positioned(
                            right: 4,
                            top: 4,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 18,
                                minHeight: 18,
                              ),
                              child: Text(
                                '${_reminderService.getNotificationCount()}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 30),
              
              // Balance Card
              BalanceCard(
                balance: _summary.totalBalance,
                onAddPressed: _navigateToAddTransaction,
              ),
              
              const SizedBox(height: 20),
              
              // Salary Tracker Card (if salary is set)
              if (_salaryTracker != null) ...[
                _buildSalaryTrackerCard(_salaryTracker!, isDark),
                const SizedBox(height: 10),
              ],
              
              const SizedBox(height: 30),
              
              // Statistics Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Statistics',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Aug',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: StatisticsCard(
                      title: '₹ ${NumberFormat('#,##0').format(_summary.totalIncome)}',
                      subtitle: 'Income',
                      color: const Color(0xFF06D6A0),
                      icon: Icons.arrow_upward,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: StatisticsCard(
                      title: '₹ ${NumberFormat('#,##0').format(_summary.totalExpense)}',
                      subtitle: 'Expense',
                      color: const Color(0xFFFF6B9D),
                      icon: Icons.arrow_downward,
                    ),
                  ),
                ],
              ),
              
              // Lending/Borrowing Statistics
              if (_summary.pendingLentAmount > 0 || _summary.pendingBorrowedAmount > 0)
                Column(
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        if (_summary.pendingLentAmount > 0)
                          Expanded(
                            child: StatisticsCard(
                              title: '₹ ${NumberFormat('#,##0').format(_summary.pendingLentAmount)}',
                              subtitle: 'Lent (Pending)',
                              color: const Color(0xFFFFB800),
                              icon: Icons.call_made,
                            ),
                          ),
                        if (_summary.pendingLentAmount > 0 && _summary.pendingBorrowedAmount > 0)
                          const SizedBox(width: 16),
                        if (_summary.pendingBorrowedAmount > 0)
                          Expanded(
                            child: StatisticsCard(
                              title: '₹ ${NumberFormat('#,##0').format(_summary.pendingBorrowedAmount)}',
                              subtitle: 'Borrowed (Pending)',
                              color: const Color(0xFFFF4757),
                              icon: Icons.call_received,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              
              const SizedBox(height: 30),
              
              // Savings Goals Section
              if (_savingsGoals.isNotEmpty)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'My savings plan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'View all',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _savingsGoals.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              right: index < _savingsGoals.length - 1 ? 16 : 0,
                            ),
                            child: SavingsGoalCard(goal: _savingsGoals[index]),
                          );
                        },
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                  ],
                ),
              
              // Lending Manager Quick Access
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4C1D95), Color(0xFF7C3AED)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4C1D95).withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '💰 Lending Manager',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LendingManagerScreen(),
                              ),
                            ).then((_) => _refreshData());
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                Text(
                                  'View All',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(Icons.arrow_forward, color: Colors.white, size: 14),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildLendingQuickCard(
                            'Money Lent',
                            _summary.totalLent - _summary.totalLentReturned,
                            Icons.call_made,
                            Colors.white.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildLendingQuickCard(
                            'Money Borrowed',
                            _summary.totalBorrowed - _summary.totalBorrowReturned,
                            Icons.call_received,
                            Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Recent Transactions Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Recent Transactions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Tooltip(
                        message: 'Long press to edit or delete',
                        child: Icon(
                          Icons.info_outline,
                          size: 16,
                          color: isDark ? Colors.white38 : Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllTransactionsScreen(),
                        ),
                      ).then((_) => _refreshData());
                    },
                    child: Text(
                      'View all',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white60 : Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              _recentTransactions.isEmpty
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No transactions yet',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add your first transaction to get started',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _recentTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = _recentTransactions[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: GestureDetector(
                            onLongPress: () {
                              _showTransactionOptions(transaction);
                            },
                            child: TransactionItem(transaction: transaction),
                          ),
                        );
                      },
                    ),
              
              const SizedBox(height: 100), // Space for FAB
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLendingQuickCard(String title, double amount, IconData icon, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF4C1D95), size: 24),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF4C1D95),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '₹ ${NumberFormat('#,##0').format(amount)}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4C1D95),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryTrackerCard(SalaryExpenseTracker tracker, bool isDark) {
    final percentageSpent = tracker.spentPercentage.clamp(0.0, 100.0);
    final isWarning = percentageSpent > 80 && !tracker.isOverspent;
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SalaryManagementScreen(),
          ),
        ).then((_) => _refreshData());
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: tracker.isOverspent
                ? [const Color(0xFFDC2626), const Color(0xFFEF4444)]
                : isWarning
                    ? [const Color(0xFFEA580C), const Color(0xFFF97316)]
                    : [const Color(0xFF059669), const Color(0xFF10B981)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: (tracker.isOverspent 
                  ? const Color(0xFFDC2626)
                  : isWarning
                      ? const Color(0xFFEA580C)
                      : const Color(0xFF059669)).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Monthly Salary',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          DateFormat('MMM yyyy').format(tracker.salary.month),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Icon(
                  tracker.isOverspent 
                      ? Icons.warning_rounded 
                      : isWarning
                          ? Icons.warning_amber_rounded
                          : Icons.check_circle_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tracker.isOverspent ? 'Overspent' : 'Remaining',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹ ${NumberFormat('#,##0').format(tracker.remainingAmount.abs())}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'of ₹ ${NumberFormat('#,##0').format(tracker.salary.amount)}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${percentageSpent.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'spent',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (percentageSpent / 100).clamp(0.0, 1.0),
                backgroundColor: Colors.white.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 6,
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Footer info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${tracker.daysRemaining} days left',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                Text(
                  'Daily: ₹${NumberFormat('#,##0').format(tracker.recommendedDailyBudget)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}