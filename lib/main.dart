import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'services/theme_service.dart';
import 'services/recurring_service.dart';
import 'services/salary_service.dart';
import 'utils/data_preloader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataPreloader.loadSampleData();
  
  // Process any due recurring transactions
  final recurringService = RecurringService();
  await recurringService.processDueTransactions();
  
  // Initialize salary service
  final salaryService = SalaryService();
  await salaryService.initialize();
  
  runApp(const FinanceTrackerApp());
}

class FinanceTrackerApp extends StatefulWidget {
  const FinanceTrackerApp({super.key});

  @override
  State<FinanceTrackerApp> createState() => _FinanceTrackerAppState();
}

class _FinanceTrackerAppState extends State<FinanceTrackerApp> {
  final ThemeService _themeService = ThemeService();

  @override
  void initState() {
    super.initState();
    _themeService.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    _themeService.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '7K Money',
      debugShowCheckedModeBanner: false,
      theme: _themeService.getLightTheme(),
      darkTheme: _themeService.getDarkTheme(),
      themeMode: _themeService.themeMode == AppThemeMode.dark 
          ? ThemeMode.dark 
          : _themeService.themeMode == AppThemeMode.light
              ? ThemeMode.light
              : ThemeMode.system,
      home: const MainScreen(),
    );
  }
}
