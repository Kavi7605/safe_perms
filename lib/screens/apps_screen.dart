import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../config/theme.dart';

class AppsScreen extends StatefulWidget {
  const AppsScreen({super.key});

  @override
  State<AppsScreen> createState() => _AppsScreenState();
}

class _AppsScreenState extends State<AppsScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _apps = [
    {
      'name': 'WhatsApp',
      'permission': 'Contacts',
      'risk': 'Medium',
      'icon': Icons.chat,
    },
    {
      'name': 'Instagram',
      'permission': 'Camera',
      'risk': 'High',
      'icon': Icons.camera_alt,
    },
    {
      'name': 'Google Maps',
      'permission': 'Location',
      'risk': 'High',
      'icon': Icons.location_on,
    },
    {
      'name': 'Zoom',
      'permission': 'Microphone',
      'risk': 'Medium',
      'icon': Icons.videocam,
    },
    {
      'name': 'Gallery',
      'permission': 'Storage',
      'risk': 'Low',
      'icon': Icons.photo,
    },
  ];

  String _selectedFilter = 'All';

  List<Map<String, dynamic>> get filteredApps {
    List<Map<String, dynamic>> result = List.from(_apps);

    if (_selectedFilter != 'All') {
      result = result
          .where((app) => app['risk'] == _selectedFilter)
          .toList();
    }

    if (_searchController.text.trim().isNotEmpty) {
      final query = _searchController.text.trim().toLowerCase();
      result = result.where((app) {
        final name = (app['name'] as String).toLowerCase();
        final permission = (app['permission'] as String).toLowerCase();
        return name.contains(query) || permission.contains(query);
      }).toList();
    }

    return result;
  }

  Color getRiskColor(String risk) {
    switch (risk) {
      case 'High':
        return Colors.redAccent;
      case 'Medium':
        return Colors.orangeAccent;
      default:
        return const Color(0xFF00C851);
    }
  }

  void _showAppDetails(BuildContext context, Map<String, dynamic> app) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text(
          app['name'] as String,
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Permission: ${app['permission']}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Risk Level: ${app['risk']}',
              style: TextStyle(
                color: getRiskColor(app['risk'] as String),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final apps = filteredApps;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Installed Apps'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/dashboard'),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search apps or permissions...',
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(
                  Icons.search,
                  color: SafePermsTheme.primaryGreen,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                )
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 4),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: ['All', 'Low', 'Medium', 'High'].map((filter) {
                final selected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(filter),
                    selected: selected,
                    selectedColor: SafePermsTheme.primaryGreen,
                    labelStyle: TextStyle(
                      color: selected ? Colors.black : Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    backgroundColor: SafePermsTheme.surfaceLight,
                    onSelected: (_) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: apps.isEmpty
                ? const Center(
              child: Text(
                'No apps found',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
                : ListView.builder(
              itemCount: apps.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final app = apps[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: const Color(0xFF1E1E1E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(
                        0xFF00C851,
                      ).withOpacity(0.15),
                      child: Icon(
                        app['icon'] as IconData,
                        color: const Color(0xFF00C851),
                      ),
                    ),
                    title: Text(
                      app['name'] as String,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Permission: ${app['permission']}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: Chip(
                      label: Text(app['risk'] as String),
                      backgroundColor: getRiskColor(
                        app['risk'] as String,
                      ).withOpacity(0.15),
                      labelStyle: TextStyle(
                        color: getRiskColor(app['risk'] as String),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () => _showAppDetails(context, app),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) context.go('/dashboard');
          if (index == 1) context.go('/schedules');
          if (index == 2) context.go('/apps');
          if (index == 3) context.go('/settings');
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Schedules',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.apps), label: 'Apps'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
