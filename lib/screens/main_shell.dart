import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../utils/app_theme.dart';
import 'home_tab.dart';
import 'profile_tab.dart';
import 'reports_tab.dart';
import 'staff/staff_dashboard.dart';
import 'student/submit_incident_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  void _go(int i) => setState(() => _index = i);

  void _openReport() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const SubmitIncidentScreen()));
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<AuthProvider>().isStaff) {
      return const _StaffShell();
    }

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomeTab(onSeeAll: () => _go(1)),
          const ReportsTab(),
          const ProfileTab(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        height: 82,
        child: Row(
          children: [
            Expanded(
              child: _NavItem(
                icon: Icons.grid_view_outlined,
                activeIcon: Icons.grid_view_rounded,
                label: 'Home',
                selected: _index == 0,
                onTap: () => _go(0),
              ),
            ),
            Expanded(
              child: _NavItem(
                icon: Icons.feed_outlined,
                activeIcon: Icons.feed_rounded,
                label: 'Reports',
                selected: _index == 1,
                onTap: () => _go(1),
              ),
            ),
            Expanded(child: _ReportNavItem(onTap: _openReport)),
            Expanded(
              child: _NavItem(
                icon: Icons.account_circle_outlined,
                activeIcon: Icons.account_circle_rounded,
                label: 'Profile',
                selected: _index == 2,
                onTap: () => _go(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StaffShell extends StatefulWidget {
  const _StaffShell();

  @override
  State<_StaffShell> createState() => _StaffShellState();
}

class _StaffShellState extends State<_StaffShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [StaffDashboard(), ProfileTab()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppTheme.secondary,
        unselectedItemColor: const Color(0xFF718096),
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 11,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
        currentIndex: _index,
        onTap: (index) => setState(() => _index = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.space_dashboard_outlined),
            activeIcon: Icon(Icons.space_dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            activeIcon: Icon(Icons.account_circle_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppTheme.secondary : const Color(0xFF718096);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(selected ? activeIcon : icon, color: color, size: 23),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: color,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportNavItem extends StatelessWidget {
  final VoidCallback onTap;

  const _ReportNavItem({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_box_rounded, color: AppTheme.primary, size: 25),
            SizedBox(height: 2),
            Text(
              'Report',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.primary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
