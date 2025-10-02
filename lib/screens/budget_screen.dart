import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/finance_models.dart';
import '../services/finance_data_service.dart';
import '../widgets/category_budget_card.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final FinanceDataService _dataService = FinanceDataService();
  FinancialSummary _summary = FinancialSummary();
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _dataService.initializeData();
    _refreshData();
  }

  void _refreshData() {
    setState(() {
      _summary = _dataService.getFinancialSummary();
      _categories = _dataService.getExpenseCategories();
      // Calculate actual spending for each category
      _categories = _categories.map((category) {
        final categoryTransactions = _dataService.transactions
            .where((t) => t.category == category.name && t.type == TransactionType.expense)
            .toList();
        final spentAmount = categoryTransactions.fold(0.0, (sum, t) => sum + t.amount);
        
        return Category(
          id: category.id,
          name: category.name,
          icon: category.icon,
          color: category.color,
          budgetAmount: category.budgetAmount > 0 ? category.budgetAmount : 5000, // Default budget
          spentAmount: spentAmount,
          type: category.type,
        );
      }).where((c) => c.spentAmount > 0).toList(); // Only show categories with spending
    });
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Budget Management',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
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
                    child: Icon(
                      Icons.notifications_outlined,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 30),
              
              // Budget Overview Chart
              Container(
                height: 250,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          PieChart(
                            PieChartData(
                              sectionsSpace: 8,
                              centerSpaceRadius: 60,
                              sections: _buildPieChartSections(),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '₹ ${NumberFormat('#,##0').format(_summary.totalExpense > 0 ? _summary.totalExpense : 0)}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                              Text(
                                'Total Budget',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.white60 : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        _buildLegendItem('Groceries', const Color(0xFF8B5CF6)),
                        const SizedBox(width: 20),
                        _buildLegendItem('Shopping', const Color(0xFFFFB800)),
                        const SizedBox(width: 20),
                        _buildLegendItem('Rent', const Color(0xFFFF6B9D)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildLegendItem('Fuel', const Color(0xFF06D6A0)),
                        const SizedBox(width: 20),
                        _buildLegendItem('Other', const Color(0xFFFF4757)),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Categories Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: Navigate to add category screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Add categories feature coming soon!'),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4C1D95),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Add More',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Categories Grid
              _categories.isEmpty
                  ? Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(40),
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
                      child: Column(
                        children: [
                          Icon(
                            Icons.category_outlined,
                            size: 48,
                            color: isDark ? Colors.white38 : Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No budget categories',
                            style: TextStyle(
                              fontSize: 16,
                              color: isDark ? Colors.white60 : Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add transactions to see budget breakdown',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? Colors.white38 : Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.8,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        return CategoryBudgetCard(category: _categories[index]);
                      },
                    ),
              
              const SizedBox(height: 100), // Space for FAB
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    if (_categories.isEmpty || _summary.totalExpense == 0) {
      return [
        PieChartSectionData(
          color: Colors.grey[300]!,
          value: 1,
          title: 'No Data',
          radius: 40,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ];
    }
    
    return _categories.where((c) => c.spentAmount > 0).map((category) {
      final percentage = (category.spentAmount / _summary.totalExpense) * 100;
      return PieChartSectionData(
        color: Color(category.color),
        value: category.spentAmount,
        title: '${percentage.toInt()}%',
        radius: 40,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildLegendItem(String label, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white70 : Colors.grey,
          ),
        ),
      ],
    );
  }
}