import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'budget_screen.dart';
import 'parcours_screen.dart';
import 'historique_screen.dart';
import 'aide_screen.dart';

/// HomeShell = la "coquille" de l'app contenant la barre de navigation du bas,
/// affichée uniquement une fois le bénéficiaire connecté (après l'OTP).
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    BudgetScreen(),
    ParcoursScreen(),
    HistoriqueScreen(),
    AideScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: AppColors.textSecondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.credit_card), label: 'Budget'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined), label: 'Parcours'),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: 'Historique'),
          BottomNavigationBarItem(icon: Icon(Icons.help_outline), label: 'Aide'),
        ],
      ),
    );
  }
}