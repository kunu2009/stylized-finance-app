import 'package:flutter/material.dart';
import '../models/finance_models.dart';
import '../services/finance_data_service.dart';
import 'add_category_screen.dart';

class ManageCategoriesScreen extends StatefulWidget {
  const ManageCategoriesScreen({super.key});

  @override
  State<ManageCategoriesScreen> createState() => _ManageCategoriesScreenState();
}

class _ManageCategoriesScreenState extends State<ManageCategoriesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FinanceDataService _dataService = FinanceDataService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _dataService.initializeData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Manage Categories',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF4C1D95),
          unselectedLabelColor: isDark ? Colors.white60 : Colors.grey,
          indicatorColor: const Color(0xFF4C1D95),
          tabs: const [
            Tab(text: 'Income'),
            Tab(text: 'Expense'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCategoryList(TransactionType.income),
          _buildCategoryList(TransactionType.expense),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addCategory(),
        backgroundColor: const Color(0xFF4C1D95),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Category',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildCategoryList(TransactionType type) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categories = type == TransactionType.income
        ? _dataService.getIncomeCategories()
        : _dataService.getExpenseCategories();

    if (categories.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: 80,
              color: isDark ? Colors.white24 : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No categories yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white60 : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + to add a new category',
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
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return _buildCategoryCard(categories[index], type);
      },
    );
  }

  Widget _buildCategoryCard(Category category, TransactionType type) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDefault = _dataService.isDefaultCategory(category.name, type);

    return Dismissible(
      key: Key(category.name),
      direction: isDefault ? DismissDirection.none : DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      confirmDismiss: (direction) async {
        return await _showDeleteConfirmation(category.name);
      },
      onDismissed: (direction) {
        _deleteCategory(category.name, type);
      },
      child: Card(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: Color(category.color).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Color(category.color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                category.icon,
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          title: Row(
            children: [
              Text(
                category.name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              if (isDefault) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Default',
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark ? Colors.white70 : Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ],
          ),
          subtitle: category.budget != null
              ? Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Budget: ₹${category.budget!.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white60 : Colors.grey[600],
                    ),
                  ),
                )
              : null,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Color(category.color),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? Colors.white24 : Colors.grey[300]!,
                    width: 2,
                  ),
                ),
              ),
              if (!isDefault) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.drag_handle,
                  color: isDark ? Colors.white38 : Colors.grey[400],
                ),
              ],
            ],
          ),
          onTap: isDefault ? null : () => _editCategory(category, type),
          onLongPress: isDefault ? null : () => _showDeleteDialog(category.name, type),
        ),
      ),
    );
  }

  Future<bool?> _showDeleteConfirmation(String categoryName) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        title: Text(
          'Delete Category',
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        content: Text(
          'Are you sure you want to delete "$categoryName"?',
          style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(color: isDark ? Colors.white70 : Colors.grey[700]),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(String categoryName, TransactionType type) async {
    final confirmed = await _showDeleteConfirmation(categoryName);
    if (confirmed == true) {
      _deleteCategory(categoryName, type);
    }
  }

  void _deleteCategory(String categoryName, TransactionType type) {
    _dataService.deleteCategory(categoryName, type);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Category "$categoryName" deleted'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _addCategory() async {
    final type = _tabController.index == 0 
        ? TransactionType.income 
        : TransactionType.expense;
    
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCategoryScreen(type: type),
      ),
    );

    if (result == true) {
      setState(() {});
    }
  }

  void _editCategory(Category category, TransactionType type) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCategoryScreen(
          type: type,
          editCategory: category,
        ),
      ),
    );

    if (result == true) {
      setState(() {});
    }
  }
}
