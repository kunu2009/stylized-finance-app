import 'package:flutter/material.dart';
import '../models/finance_models.dart';
import '../services/finance_data_service.dart';

class AddCategoryScreen extends StatefulWidget {
  final TransactionType type;
  final Category? editCategory;

  const AddCategoryScreen({
    super.key,
    required this.type,
    this.editCategory,
  });

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _budgetController = TextEditingController();
  
  String _selectedIcon = '📦';
  Color _selectedColor = const Color(0xFF4C1D95);
  
  final FinanceDataService _dataService = FinanceDataService();

  // Popular category icons
  final List<String> _availableIcons = [
    '💰', '💵', '💳', '🏦', '💼', '📊', '📈', '📉',
    '🛒', '🍔', '🍕', '☕', '🎬', '🎮', '🎵', '🎨',
    '🏠', '🚗', '✈️', '🏥', '📚', '👕', '💊', '⚡',
    '📱', '💻', '🎓', '🏋️', '🎁', '🌟', '❤️', '🔧',
    '🌍', '🎪', '🎯', '📦', '🛍️', '🍱', '🚕', '⛽',
  ];

  // Popular colors
  final List<Color> _availableColors = [
    const Color(0xFF4C1D95), // Purple
    const Color(0xFFEF4444), // Red
    const Color(0xFF10B981), // Green
    const Color(0xFF3B82F6), // Blue
    const Color(0xFFF59E0B), // Orange
    const Color(0xFF8B5CF6), // Light Purple
    const Color(0xFFEC4899), // Pink
    const Color(0xFF14B8A6), // Teal
    const Color(0xFF6366F1), // Indigo
    const Color(0xFFF97316), // Dark Orange
    const Color(0xFF06B6D4), // Cyan
    const Color(0xFFA855F7), // Violet
    const Color(0xFFEAB308), // Yellow
    const Color(0xFF22C55E), // Light Green
    const Color(0xFF0EA5E9), // Sky Blue
    const Color(0xFFDC2626), // Dark Red
  ];

  @override
  void initState() {
    super.initState();
    _dataService.initializeData();
    
    if (widget.editCategory != null) {
      _nameController.text = widget.editCategory!.name;
      _selectedIcon = widget.editCategory!.icon;
      _selectedColor = Color(widget.editCategory!.color);
      if (widget.editCategory!.budgetAmount > 0) {
        _budgetController.text = widget.editCategory!.budgetAmount.toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEdit = widget.editCategory != null;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          isEdit ? 'Edit Category' : 'Add Category',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Preview Card
              _buildPreviewCard(isDark),
              
              const SizedBox(height: 32),
              
              // Category Name
              Text(
                'Category Name',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'e.g., Groceries, Salary, etc.',
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF4C1D95)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category name';
                  }
                  return null;
                },
                onChanged: (value) => setState(() {}),
              ),
              
              const SizedBox(height: 24),
              
              // Icon Selection
              Text(
                'Choose Icon',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _availableIcons.map((icon) {
                    final isSelected = _selectedIcon == icon;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedIcon = icon),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? _selectedColor.withOpacity(0.2)
                              : (isDark ? const Color(0xFF2A2A2A) : Colors.grey[100]),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? _selectedColor : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            icon,
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Color Selection
              Text(
                'Choose Color',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _availableColors.map((color) {
                    final isSelected = _selectedColor == color;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedColor = color),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? (isDark ? Colors.white : Colors.black) : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, color: Colors.white, size: 24)
                            : null,
                      ),
                    );
                  }).toList(),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Budget (Optional)
              Text(
                'Budget (Optional)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _budgetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Set monthly budget',
                  prefixText: '₹ ',
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF4C1D95)),
                  ),
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 40),
              
              // Save Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _saveCategory,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    isEdit ? 'Update Category' : 'Add Category',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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

  Widget _buildPreviewCard(bool isDark) {
    final categoryName = _nameController.text.isEmpty ? 'Category Name' : _nameController.text;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _selectedColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Preview',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white60 : Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: _selectedColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                _selectedIcon,
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            categoryName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          if (_budgetController.text.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Budget: ₹${_budgetController.text}',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white60 : Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _saveCategory() {
    if (_formKey.currentState!.validate()) {
      final budget = _budgetController.text.isEmpty 
          ? 0.0 
          : double.parse(_budgetController.text);

      final category = Category(
        id: widget.editCategory?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        icon: _selectedIcon,
        color: _selectedColor.value,
        budgetAmount: budget,
        type: widget.type,
        isCustom: true,
      );

      if (widget.editCategory != null) {
        _dataService.updateCustomCategory(category);
      } else {
        _dataService.addCustomCategory(category);
      }

      Navigator.pop(context, true);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.editCategory != null
                ? 'Category updated successfully'
                : 'Category added successfully',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
