import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/finance_models.dart';
import '../services/finance_data_service.dart';
import '../widgets/transaction_item.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FinanceDataService _dataService = FinanceDataService();
  
  List<Transaction> _searchResults = [];
  TransactionType? _filterType;
  String? _filterCategory;
  DateTimeRange? _dateRange;
  
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _performSearch();
  }

  void _performSearch() {
    final query = _searchController.text.toLowerCase();
    
    setState(() {
      _searchResults = _dataService.transactions.where((transaction) {
        // Text search
        final matchesQuery = query.isEmpty ||
            transaction.title.toLowerCase().contains(query) ||
            transaction.description.toLowerCase().contains(query) ||
            transaction.category.toLowerCase().contains(query);
        
        // Type filter
        final matchesType = _filterType == null || transaction.type == _filterType;
        
        // Category filter
        final matchesCategory = _filterCategory == null || 
            transaction.category == _filterCategory;
        
        // Date range filter
        final matchesDate = _dateRange == null ||
            (transaction.date.isAfter(_dateRange!.start.subtract(const Duration(days: 1))) &&
             transaction.date.isBefore(_dateRange!.end.add(const Duration(days: 1))));
        
        return matchesQuery && matchesType && matchesCategory && matchesDate;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search transactions...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey[400]),
          ),
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_hasActiveFilters()) _buildActiveFilters(),
          Expanded(
            child: _searchController.text.isEmpty && !_hasActiveFilters()
                ? _buildEmptyState()
                : _searchResults.isEmpty
                    ? _buildNoResults()
                    : _buildResults(),
          ),
        ],
      ),
    );
  }

  bool _hasActiveFilters() {
    return _filterType != null || _filterCategory != null || _dateRange != null;
  }

  Widget _buildActiveFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (_filterType != null)
            _buildFilterChip(
              label: _getTypeLabel(_filterType!),
              onDelete: () {
                setState(() {
                  _filterType = null;
                  _performSearch();
                });
              },
            ),
          if (_filterCategory != null)
            _buildFilterChip(
              label: _filterCategory!,
              onDelete: () {
                setState(() {
                  _filterCategory = null;
                  _performSearch();
                });
              },
            ),
          if (_dateRange != null)
            _buildFilterChip(
              label: '${DateFormat('MMM dd').format(_dateRange!.start)} - ${DateFormat('MMM dd').format(_dateRange!.end)}',
              onDelete: () {
                setState(() {
                  _dateRange = null;
                  _performSearch();
                });
              },
            ),
          TextButton(
            onPressed: () {
              setState(() {
                _filterType = null;
                _filterCategory = null;
                _dateRange = null;
                _performSearch();
              });
            },
            child: const Text('Clear all'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({required String label, required VoidCallback onDelete}) {
    return Chip(
      label: Text(label),
      deleteIcon: const Icon(Icons.close, size: 18),
      onDeleted: onDelete,
      backgroundColor: const Color(0xFF8B5CF6).withOpacity(0.1),
      labelStyle: const TextStyle(
        color: Color(0xFF8B5CF6),
        fontWeight: FontWeight.w600,
      ),
    );
  }

  String _getTypeLabel(TransactionType type) {
    switch (type) {
      case TransactionType.income:
        return 'Income';
      case TransactionType.expense:
        return 'Expense';
      case TransactionType.lent:
        return 'Lent';
      case TransactionType.borrowed:
        return 'Borrowed';
      case TransactionType.lentReturn:
        return 'Lent Return';
      case TransactionType.borrowReturn:
        return 'Borrow Return';
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Search Transactions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Search by title, category, or description',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Results Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try different keywords or filters',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResults() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return TransactionItem(transaction: _searchResults[index]);
      },
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Type filter
              const Text(
                'Transaction Type',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildTypeFilterChip('All', null, setModalState),
                  ...TransactionType.values.map((type) =>
                    _buildTypeFilterChip(_getTypeLabel(type), type, setModalState),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Date range
              const Text(
                'Date Range',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () async {
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setModalState(() {
                      _dateRange = picked;
                    });
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  _dateRange == null
                      ? 'Select Date Range'
                      : '${DateFormat('MMM dd').format(_dateRange!.start)} - ${DateFormat('MMM dd').format(_dateRange!.end)}',
                ),
              ),
              const SizedBox(height: 20),
              
              // Apply button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _performSearch();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B5CF6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Apply Filters',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeFilterChip(String label, TransactionType? type, StateSetter setModalState) {
    final isSelected = _filterType == type;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setModalState(() {
          _filterType = selected ? type : null;
        });
      },
      selectedColor: const Color(0xFF8B5CF6).withOpacity(0.2),
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFF8B5CF6) : Colors.black87,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
}
