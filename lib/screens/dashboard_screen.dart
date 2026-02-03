import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../main.dart';  // Import AppState from main.dart

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SafePerms'),
        backgroundColor: SafePermsTheme.primaryGreen,
      ),

      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Permission Summary Cards
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        color: SafePermsTheme.surfaceLight,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text('Total Apps',
                                  style: Theme.of(context).textTheme.titleMedium),
                              const Text('127',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: SafePermsTheme.primaryGreen,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Card(
                        color: SafePermsTheme.surfaceLight,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text('Permissions',
                                  style: Theme.of(context).textTheme.titleMedium),
                              Text('${appState.permissionCount}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: SafePermsTheme.primaryGreen,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Text('Quick Actions',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.apps),
                        label: const Text('View Apps'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.schedule),
                        label: const Text('Schedules'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SafePermsTheme.greenDark,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Bottom Navigation Preview
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: SafePermsTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _NavItem(icon: Icons.apps, label: 'Apps', active: true),
                      _NavItem(icon: Icons.security, label: 'Permissions'),
                      _NavItem(icon: Icons.schedule, label: 'Schedule'),
                      _NavItem(icon: Icons.history, label: 'History'),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'Apps'),
          BottomNavigationBarItem(icon: Icon(Icons.security), label: 'Permissions'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
        currentIndex: 0,
        onTap: (index) {},
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _NavItem({
    required this.icon,
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon,
            color: active ? SafePermsTheme.primaryGreen : Colors.grey),
        Text(label, style: TextStyle(
          fontSize: 12,
          color: active ? SafePermsTheme.primaryGreen : Colors.grey,
          fontWeight: active ? FontWeight.bold : FontWeight.normal,
        )),
      ],
    );
  }
}
