import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../config/theme.dart';
import '../widgets/nav_drawer.dart';
import 'apps_screen.dart';
import 'schedule_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  String _userName = 'User';
  int _scheduleCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final scheduleBox = Hive.box('schedules');

    if (!mounted) return;

    setState(() {
      _userName =
          prefs.getString('userName') ??
              prefs.getString('userEmail') ??
              'User';
      _scheduleCount = scheduleBox.length;
    });
  }

  List<Widget> get _pages => [
    _buildHomeTab(),
    const AppsScreen(),
    const ScheduleScreen(),
    _buildHistoryTab(),
  ];

  void _onBottomNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      _loadData();
    }
  }

  void _showEnhancedSnackBar(
      String message, {
        Color? bgColor,
        String? actionText,
        VoidCallback? onAction,
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: bgColor ?? SafePermsTheme.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        action: actionText != null
            ? SnackBarAction(
          label: actionText,
          textColor: Colors.white,
          onPressed: onAction ?? () {},
        )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: SafePermsTheme.surfaceLight,
        selectedItemColor: SafePermsTheme.primaryGreen,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'Apps'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Row(
          children: [
            Icon(Icons.security, color: SafePermsTheme.primaryGreen),
            SizedBox(width: 8),
            Text(
              'SafePerms',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showEnhancedSnackBar(
                'Dashboard refreshed',
                bgColor: SafePermsTheme.primaryGreen,
              );
              _loadData();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: SafePermsTheme.primaryGreen,
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back,',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                _userName,
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(fontSize: 24),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  _buildStatCard('4', 'Installed Apps', Colors.white),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    '$_scheduleCount',
                    'Active Schedules',
                    SafePermsTheme.primaryGreen,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                'Quick Access',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  _buildQuickAction(
                    Icons.camera_alt,
                    'Camera',
                    'Safe',
                    Colors.teal,
                  ),
                  _buildQuickAction(
                    Icons.location_on,
                    'Location',
                    'In Use',
                    Colors.blue,
                  ),
                  _buildQuickAction(
                    Icons.mic,
                    'Microphone',
                    'Off',
                    Colors.redAccent,
                  ),
                  _buildQuickAction(
                    Icons.contacts,
                    'Contacts',
                    'Safe',
                    Colors.orange,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                'Recent Activity',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              _buildRecentActivityTile(
                icon: Icons.schedule,
                title: 'Schedule module opened',
                subtitle: 'Track and manage permission timings',
              ),
              _buildRecentActivityTile(
                icon: Icons.notifications_active,
                title: 'Snackbar support added',
                subtitle: 'Feedback messages available for user actions',
              ),
              _buildRecentActivityTile(
                icon: Icons.design_services,
                title: 'Lab 7 UI components active',
                subtitle: 'Cards, forms, navigation and dialogs integrated',
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: SafePermsTheme.primaryGreen,
        onPressed: () {
          setState(() {
            _selectedIndex = 2;
          });
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  Widget _buildHistoryTab() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(
            child: ListTile(
              leading: Icon(Icons.history, color: SafePermsTheme.primaryGreen),
              title: Text(
                'No history yet',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                'User activity log will appear here.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color valueColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: SafePermsTheme.surfaceLight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                color: valueColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(
      IconData icon,
      String label,
      String status,
      Color color,
      ) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        _showEnhancedSnackBar('$label permission status: $status');
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: SafePermsTheme.surfaceLight,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    status,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: SafePermsTheme.primaryGreen),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ),
    );
  }
}
