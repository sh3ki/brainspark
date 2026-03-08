import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'dashboard_screen.dart';
import 'progress_screen.dart';
import 'create_card_screen.dart';
import 'settings_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  static const _screens = [
    DashboardScreen(),
    ProgressScreen(),
    CreateCardScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () => setState(() => _selectedIndex = 2),
              backgroundColor: AppTheme.primary,
              child: const Icon(Icons.add_rounded, color: Colors.white),
            )
          : null,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                _NavItem(
                    icon: Icons.home_rounded,
                    label: 'Decks',
                    selected: _selectedIndex == 0,
                    onTap: () => setState(() => _selectedIndex = 0)),
                _NavItem(
                    icon: Icons.insights_rounded,
                    label: 'Progress',
                    selected: _selectedIndex == 1,
                    onTap: () => setState(() => _selectedIndex = 1)),
                _NavItem(
                    icon: Icons.add_circle_outline_rounded,
                    label: 'Create',
                    selected: _selectedIndex == 2,
                    onTap: () => setState(() => _selectedIndex = 2)),
                _NavItem(
                    icon: Icons.settings_rounded,
                    label: 'Settings',
                    selected: _selectedIndex == 3,
                    onTap: () => setState(() => _selectedIndex = 3)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: selected
                    ? AppTheme.primary.withOpacity(0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon,
                  color: selected
                      ? AppTheme.primary
                      : AppTheme.textSecondary,
                  size: 24),
            ),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: selected
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: selected
                        ? AppTheme.primary
                        : AppTheme.textSecondary)),
          ],
        ),
      ),
    );
  }
}
