import 'package:flutter/material.dart';
import '../services/import_export_service.dart';
import '../services/finance_data_service.dart';
import '../services/theme_service.dart';
import '../utils/data_preloader.dart';
import 'recurring_screen.dart';
import 'reminders_screen.dart';
import 'manage_categories_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ImportExportService _importExportService = ImportExportService();
  final FinanceDataService _dataService = FinanceDataService();
  final ThemeService _themeService = ThemeService();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Features Section
            Text(
              'Features',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            
            // Recurring Transactions
            _buildSettingCard(
              icon: Icons.repeat,
              title: 'Recurring Transactions',
              subtitle: 'Manage subscriptions and bills',
              color: const Color(0xFF8B5CF6),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RecurringScreen()),
                );
              },
            ),
            
            const SizedBox(height: 12),
            
            // Reminders
            _buildSettingCard(
              icon: Icons.notifications,
              title: 'Reminders',
              subtitle: 'Set reminders for payments and goals',
              color: const Color(0xFFFF6B9D),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RemindersScreen()),
                );
              },
            ),
            
            const SizedBox(height: 12),
            
            // Manage Categories
            _buildSettingCard(
              icon: Icons.category,
              title: 'Manage Categories',
              subtitle: 'Create and customize your categories',
              color: const Color(0xFF4C1D95),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ManageCategoriesScreen()),
                );
              },
            ),
            
            const SizedBox(height: 30),
            
            // Appearance Section
            Text(
              'Appearance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            
            // Dark Mode Toggle
            Card(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              child: SwitchListTile(
                secondary: const Icon(Icons.dark_mode, color: Color(0xFF8B5CF6)),
                title: Text(
                  'Dark Mode',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                subtitle: Text(
                  'Toggle dark/light theme',
                  style: TextStyle(color: isDark ? Colors.white60 : Colors.grey[600]),
                ),
                value: _themeService.isDarkMode,
                onChanged: (value) {
                  setState(() {
                    _themeService.toggleTheme();
                  });
                },
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Data Management Section
            Text(
              'Data Management',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            
            // Import Data Card
            _buildSettingCard(
              icon: Icons.file_upload,
              title: 'Import Data',
              subtitle: 'Import transactions from JSON file',
              color: const Color(0xFF06D6A0),
              onTap: () => _importExportService.pickAndImportFile(context),
            ),
            
            const SizedBox(height: 12),
            
            // Load Sample Data Card
            _buildSettingCard(
              icon: Icons.cloud_download,
              title: 'Load Sample Data',
              subtitle: 'Load your backup data from 7k_money_backup.json',
              color: const Color(0xFF118AB2),
              onTap: () async {
                try {
                  await DataPreloader.loadSampleData();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sample data loaded successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error loading data: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
            ),
            
            const SizedBox(height: 12),
            
            // Export Data Card
            _buildSettingCard(
              icon: Icons.file_download,
              title: 'Export Data',
              subtitle: 'Export all transactions as JSON',
              color: const Color(0xFF8B5CF6),
              onTap: () async {
                await _importExportService.exportToJson();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Data exported successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
            ),
            
            const SizedBox(height: 12),
            
            // Clear All Data Card
            _buildSettingCard(
              icon: Icons.delete_forever,
              title: 'Clear All Data',
              subtitle: 'Delete all transactions (cannot be undone)',
              color: const Color(0xFFFF4757),
              onTap: () => _showClearDataDialog(),
            ),
            
            const SizedBox(height: 30),
            
            // App Information Section
            const Text(
              'App Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            _buildInfoCard(
              icon: Icons.info_outline,
              title: 'Version',
              value: '1.0.0',
            ),
            
            const SizedBox(height: 12),
            
            _buildInfoCard(
              icon: Icons.account_balance_wallet,
              title: 'Total Transactions',
              value: '${_dataService.transactions.length}',
            ),
            
            const SizedBox(height: 30),
            
            // Import Instructions
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E3A5F) : Colors.blue[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? const Color(0xFF2563EB) : Colors.blue[200]!,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info,
                        color: isDark ? const Color(0xFF60A5FA) : Colors.blue[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Import Instructions',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDark ? const Color(0xFF93C5FD) : Colors.blue[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Your JSON file should contain an array of transactions with the following format:',
                    style: TextStyle(
                      color: isDark ? const Color(0xFF93C5FD) : Colors.blue[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark ? const Color(0xFF2563EB) : Colors.blue[200]!,
                      ),
                    ),
                    child: Text(
                      '''[
  {
    "date": "2025-09-23",
    "description": "Transaction title",
    "amount": 500,
    "type": "income", // or "expense"
    "id": 123456
  }
]''',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: isDark ? const Color(0xFF93C5FD) : Colors.black87,
                      ),
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

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
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
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white60 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.grey[600],
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear All Data'),
          content: const Text(
            'Are you sure you want to delete all transactions? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _dataService.clearAllData();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All data cleared successfully'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Clear All'),
            ),
          ],
        );
      },
    );
  }
}