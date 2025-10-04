import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/finance_models.dart';
import '../services/finance_data_service.dart';
import 'add_transaction_screen.dart';

class LendingManagerScreen extends StatefulWidget {
  const LendingManagerScreen({super.key});

  @override
  State<LendingManagerScreen> createState() => _LendingManagerScreenState();
}

class _LendingManagerScreenState extends State<LendingManagerScreen> with SingleTickerProviderStateMixin {
  final FinanceDataService _dataService = FinanceDataService();
  late TabController _tabController;
  
  Map<String, LendingRecord> _lentRecords = {};
  Map<String, LendingRecord> _borrowedRecords = {};
  
  double _totalLent = 0;
  double _totalBorrowed = 0;
  double _totalLentReturned = 0;
  double _totalBorrowReturned = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    await _dataService.initializeData();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _calculateLendingRecords();
    });
  }

  void _calculateLendingRecords() {
    final Map<String, LendingRecord> lentRecords = {};
    final Map<String, LendingRecord> borrowedRecords = {};

    _totalLent = 0;
    _totalBorrowed = 0;
    _totalLentReturned = 0;
    _totalBorrowReturned = 0;

    for (var transaction in _dataService.transactions) {
      if (transaction.contactName == null || transaction.contactName!.isEmpty) continue;

      final contactName = transaction.contactName!;

      if (transaction.type == TransactionType.lent) {
        lentRecords[contactName] ??= LendingRecord(contactName: contactName);
        lentRecords[contactName]!.amountLent += transaction.amount;
        lentRecords[contactName]!.transactions.add(transaction);
        _totalLent += transaction.amount;
      } else if (transaction.type == TransactionType.lentReturn) {
        lentRecords[contactName] ??= LendingRecord(contactName: contactName);
        lentRecords[contactName]!.amountReturned += transaction.amount;
        lentRecords[contactName]!.transactions.add(transaction);
        _totalLentReturned += transaction.amount;
      } else if (transaction.type == TransactionType.borrowed) {
        borrowedRecords[contactName] ??= LendingRecord(contactName: contactName);
        borrowedRecords[contactName]!.amountLent += transaction.amount;
        borrowedRecords[contactName]!.transactions.add(transaction);
        _totalBorrowed += transaction.amount;
      } else if (transaction.type == TransactionType.borrowReturn) {
        borrowedRecords[contactName] ??= LendingRecord(contactName: contactName);
        borrowedRecords[contactName]!.amountReturned += transaction.amount;
        borrowedRecords[contactName]!.transactions.add(transaction);
        _totalBorrowReturned += transaction.amount;
      }
    }

    // Sort transactions by date
    for (var record in lentRecords.values) {
      record.transactions.sort((a, b) => b.date.compareTo(a.date));
    }
    for (var record in borrowedRecords.values) {
      record.transactions.sort((a, b) => b.date.compareTo(a.date));
    }

    _lentRecords = lentRecords;
    _borrowedRecords = borrowedRecords;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey[50],
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        title: Text(
          'Lending Manager',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF4C1D95),
          labelColor: const Color(0xFF4C1D95),
          unselectedLabelColor: isDark ? Colors.white60 : Colors.grey,
          tabs: const [
            Tab(text: 'Money Lent', icon: Icon(Icons.call_made, size: 20)),
            Tab(text: 'Money Borrowed', icon: Icon(Icons.call_received, size: 20)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Summary Cards
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Total Lent',
                    _totalLent - _totalLentReturned,
                    Icons.trending_up,
                    const Color(0xFFFF6B9D),
                    isDark,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    'Total Borrowed',
                    _totalBorrowed - _totalBorrowReturned,
                    Icons.trending_down,
                    const Color(0xFF06D6A0),
                    isDark,
                  ),
                ),
              ],
            ),
          ),
          
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLendingList(_lentRecords, true, isDark),
                _buildLendingList(_borrowedRecords, false, isDark),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransactionScreen(
                initialType: TransactionType.lent,
              ),
            ),
          );
          if (result == true) {
            _refreshData();
          }
        },
        backgroundColor: const Color(0xFF4C1D95),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Lending',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, double amount, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white60 : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '₹ ${NumberFormat('#,##0.00').format(amount)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLendingList(Map<String, LendingRecord> records, bool isLent, bool isDark) {
    if (records.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isLent ? Icons.call_made : Icons.call_received,
              size: 64,
              color: isDark ? Colors.white24 : Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              isLent ? 'No money lent yet' : 'No money borrowed yet',
              style: TextStyle(
                fontSize: 16,
                color: isDark ? Colors.white60 : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isLent 
                  ? 'Add transactions to track money you\'ve lent'
                  : 'Add transactions to track money you\'ve borrowed',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white38 : Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final contactName = records.keys.elementAt(index);
        final record = records[contactName]!;
        final balance = record.amountLent - record.amountReturned;
        
        return _buildContactCard(contactName, record, balance, isLent, isDark);
      },
    );
  }

  Widget _buildContactCard(String contactName, LendingRecord record, double balance, bool isLent, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          childrenPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: CircleAvatar(
            backgroundColor: const Color(0xFF4C1D95).withOpacity(0.2),
            child: Text(
              contactName[0].toUpperCase(),
              style: const TextStyle(
                color: Color(0xFF4C1D95),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            contactName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                '${record.transactions.length} transaction${record.transactions.length > 1 ? 's' : ''}',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white60 : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildAmountChip('Given', record.amountLent, isLent ? Colors.red : Colors.blue, isDark),
                  const SizedBox(width: 8),
                  _buildAmountChip('Returned', record.amountReturned, Colors.green, isDark),
                ],
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                balance >= 0 ? 'Balance' : 'Overpaid',
                style: TextStyle(
                  fontSize: 11,
                  color: isDark ? Colors.white60 : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '₹ ${NumberFormat('#,##0').format(balance.abs())}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: balance > 0 
                      ? (isLent ? Colors.red : Colors.orange)
                      : balance < 0
                          ? Colors.green
                          : (isDark ? Colors.white : Colors.black),
                ),
              ),
            ],
          ),
          children: [
            ...record.transactions.map((transaction) => _buildTransactionTile(transaction, isDark)),
            const SizedBox(height: 8),
            if (balance > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddTransactionScreen(
                                initialType: isLent ? TransactionType.lentReturn : TransactionType.borrowReturn,
                                initialContact: contactName,
                              ),
                            ),
                          );
                          if (result == true) {
                            _refreshData();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.check_circle, size: 18),
                        label: Text(isLent ? 'Mark Returned' : 'Mark Paid'),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountChip(String label, double amount, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '₹${NumberFormat('#,##0').format(amount)}',
            style: TextStyle(
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTile(Transaction transaction, bool isDark) {
    final isReturn = transaction.type == TransactionType.lentReturn || 
                     transaction.type == TransactionType.borrowReturn;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isReturn ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isReturn ? Icons.check_circle : Icons.arrow_forward,
              color: isReturn ? Colors.green : Colors.orange,
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM dd, yyyy').format(transaction.date),
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white60 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            '₹ ${NumberFormat('#,##0').format(transaction.amount)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isReturn ? Colors.green : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }
}

class LendingRecord {
  final String contactName;
  double amountLent = 0;
  double amountReturned = 0;
  List<Transaction> transactions = [];

  LendingRecord({required this.contactName});
}
