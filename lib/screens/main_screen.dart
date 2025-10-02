import 'package:flutter/material.dart';
import 'dashboard_screen.dart';
import 'budget_screen.dart';
import 'statistics_screen.dart';
import 'settings_screen.dart';
import 'add_transaction_screen.dart';
import 'search_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late PageController _pageController;
  
  final List<Widget> _screens = [
    const DashboardScreen(),
    const BudgetScreen(),
    const StatisticsScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _navigateToAddTransaction() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTransactionScreen()),
    );
    // Refresh current screen if it's dashboard
    if (_currentIndex == 0) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          color: const Color(0xFF2E1065),
          elevation: 8,
          child: SizedBox(
            height: 65,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(
                    _currentIndex == 0 ? Icons.home : Icons.home_outlined,
                    color: _currentIndex == 0
                        ? const Color(0xFFFFD700)
                        : Colors.white.withOpacity(0.6),
                    size: 28,
                  ),
                  onPressed: () => _onTabTapped(0),
                ),
                IconButton(
                  icon: Icon(
                    _currentIndex == 1 ? Icons.pie_chart : Icons.pie_chart_outline,
                    color: _currentIndex == 1
                        ? const Color(0xFFFFD700)
                        : Colors.white.withOpacity(0.6),
                    size: 28,
                  ),
                  onPressed: () => _onTabTapped(1),
                ),
                const SizedBox(width: 70), // Space for FAB notch
                IconButton(
                  icon: Icon(
                    _currentIndex == 2 ? Icons.bar_chart : Icons.bar_chart_outlined,
                    color: _currentIndex == 2
                        ? const Color(0xFFFFD700)
                        : Colors.white.withOpacity(0.6),
                    size: 28,
                  ),
                  onPressed: () => _onTabTapped(2),
                ),
                IconButton(
                  icon: Icon(
                    _currentIndex == 3 ? Icons.person : Icons.person_outline,
                    color: _currentIndex == 3
                        ? const Color(0xFFFFD700)
                        : Colors.white.withOpacity(0.6),
                    size: 28,
                  ),
                  onPressed: () => _onTabTapped(3),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top: 30),
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFD700).withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton(
          heroTag: 'add',
          onPressed: _navigateToAddTransaction,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 32,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}