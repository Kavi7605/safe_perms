import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this
import '../config/theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Default values
  bool _biometricEnabled = false;
  bool _notificationsEnabled = true;
  double _scanFrequency = 24.0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // Load saved settings from disk
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _biometricEnabled = prefs.getBool('biometric') ?? false;
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      _scanFrequency = prefs.getDouble('scanFrequency') ?? 24.0;
    });
  }

  // Save settings when changed
  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Security'),
          SwitchListTile(
            title: const Text('Biometric Lock', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Require fingerprint to open app', style: TextStyle(color: Colors.grey)),
            value: _biometricEnabled,
            activeColor: SafePermsTheme.primaryGreen,
            onChanged: (val) {
              setState(() => _biometricEnabled = val);
              _saveSetting('biometric', val);

              // Feedback to user (Since we don't have real biometrics yet)
              if (val) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Biometric requirement enabled')),
                );
              }
            },
            secondary: const Icon(Icons.fingerprint, color: SafePermsTheme.primaryGreen),
            tileColor: SafePermsTheme.surfaceLight,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),

          const SizedBox(height: 16),

          _buildSectionHeader('Notifications'),
          SwitchListTile(
            title: const Text('Permission Alerts', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Get notified when apps use camera/mic', style: TextStyle(color: Colors.grey)),
            value: _notificationsEnabled,
            activeColor: SafePermsTheme.primaryGreen,
            onChanged: (val) {
              setState(() => _notificationsEnabled = val);
              _saveSetting('notifications', val);
            },
            secondary: const Icon(Icons.notifications_active, color: SafePermsTheme.primaryGreen),
            tileColor: SafePermsTheme.surfaceLight,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),

          const SizedBox(height: 16),

          _buildSectionHeader('Auto-Scan Frequency'),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: SafePermsTheme.surfaceLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    'Scan every ${_scanFrequency.round()} hours',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
                ),
                Slider(
                  value: _scanFrequency,
                  min: 1,
                  max: 48,
                  divisions: 47,
                  activeColor: SafePermsTheme.primaryGreen,
                  label: '${_scanFrequency.round()} hrs',
                  onChanged: (val) {
                    setState(() => _scanFrequency = val);
                  },
                  onChangeEnd: (val) {
                    _saveSetting('scanFrequency', val); // Save only when user stops dragging
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: SafePermsTheme.primaryGreen,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}