import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/theme.dart';
import '../services/auth_service.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({super.key});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  String _userName = 'User';
  String _userEmail = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? 'SafePerms User';
      _userEmail = prefs.getString('userEmail') ?? 'guest@safeperms.com';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: SafePermsTheme.surfaceDark,
      child: Column(
        children: [
          // 1. User Profile Header
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: SafePermsTheme.surfaceLight),
            accountName: Text(
              _userName,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: Text(
              _userEmail,
              style: const TextStyle(color: Colors.grey),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: SafePermsTheme.primaryGreen,
              child: Text(
                _userName.isNotEmpty ? _userName[0].toUpperCase() : 'U',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),

          // 2. Navigation Options
          ListTile(
            leading: const Icon(Icons.settings, color: SafePermsTheme.primaryGreen),
            title: const Text('Settings', style: TextStyle(color: Colors.white)),
            onTap: () {
              context.pop(); // Close drawer
              context.push('/settings');
            },
          ),

          const Spacer(), // Pushes Logout to the bottom
          const Divider(color: Colors.grey),

          // 3. Logout Button
          ListTile(
            leading: const Icon(Icons.logout, color: SafePermsTheme.dangerRed),
            title: const Text('Logout', style: TextStyle(color: SafePermsTheme.dangerRed)),
            onTap: () {
              context.pop(); // Close drawer first
              _showLogoutDialog(context);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: SafePermsTheme.surfaceLight,
        title: const Text('Logout?', style: TextStyle(color: Colors.white)),
        content: const Text('Are you sure you want to exit?', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(ctx),
          ),
          TextButton(
            child: const Text('Logout', style: TextStyle(color: SafePermsTheme.dangerRed)),
            onPressed: () async {
              Navigator.pop(ctx);
              await AuthService.logout();
              if (context.mounted) context.go('/');
            },
          ),
        ],
      ),
    );
  }
}