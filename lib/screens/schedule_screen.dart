import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../config/theme.dart';
import '../models/schedule_model.dart';
import '../services/database_service.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});
  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final _dbService = DatabaseService();
  final _appNameController = TextEditingController();
  final _timeController = TextEditingController();

  String _selectedPermission = 'Camera';
  List<Schedule> _schedules = [];

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  void _refreshList() {
    setState(() {
      _schedules = _dbService.getSchedules();
    });
  }

  // Helper to pick time
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: SafePermsTheme.darkTheme.copyWith(
            colorScheme: const ColorScheme.dark(
              primary: SafePermsTheme.primaryGreen,
              onPrimary: Colors.white,
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      _timeController.text = picked.format(context);
    }
  }

  void _showAddDialog() {
    _appNameController.clear();
    _timeController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('New Schedule', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _appNameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'App Name',
                hintText: 'e.g. Zoom',
                hintStyle: TextStyle(color: Colors.white38),
                prefixIcon: Icon(Icons.apps, color: SafePermsTheme.primaryGreen),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _timeController,
              readOnly: true,
              onTap: () => _selectTime(context),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Time',
                hintText: 'Tap to select time',
                hintStyle: TextStyle(color: Colors.white38),
                prefixIcon: Icon(Icons.access_time, color: SafePermsTheme.primaryGreen),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedPermission,
              dropdownColor: const Color(0xFF1E1E1E),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Permission',
                prefixIcon: Icon(Icons.security, color: SafePermsTheme.primaryGreen),
              ),
              items: ['Camera', 'Location', 'Microphone', 'Contacts'].map((String val) {
                return DropdownMenuItem(value: val, child: Text(val));
              }).toList(),
              onChanged: (val) => setState(() => _selectedPermission = val!),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: SafePermsTheme.primaryGreen,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (_appNameController.text.isNotEmpty && _timeController.text.isNotEmpty) {
                final String uniqueId = const Uuid().v4();
                final newSchedule = Schedule(
                  key: uniqueId,
                  appName: _appNameController.text,
                  permissionType: _selectedPermission,
                  time: _timeController.text,
                  isActive: true,
                );

                _dbService.addSchedule(newSchedule);
                _refreshList();
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter App Name and Time')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // DELETE FUNCTION WITH CONFIRMATION DIALOG
  void _deleteItem(String key) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Delete Schedule?', style: TextStyle(color: Colors.white)),
        content: const Text('This action cannot be undone.', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(ctx),
          ),
          TextButton(
            child: const Text('Delete', style: TextStyle(color: SafePermsTheme.dangerRed)),
            onPressed: () {
              // Perform Delete
              _dbService.deleteSchedule(key);
              _refreshList();
              Navigator.pop(ctx); // Close Dialog

              // Show Snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Schedule Deleted'),
                  backgroundColor: SafePermsTheme.dangerRed,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permission Schedules'),
        automaticallyImplyLeading: false, // <--- ADD THIS (Removes Back Arrow)
        // REMOVED leading: IconButton(...)
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: SafePermsTheme.primaryGreen,
        onPressed: _showAddDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _schedules.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.schedule, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No active schedules.\nTap + to create one.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _schedules.length,
        itemBuilder: (context, index) {
          final item = _schedules[index];

          // WRAPPED IN DISMISSIBLE (Swipe to Delete)
          return Dismissible(
            key: Key(item.key),
            background: Container(
              color: SafePermsTheme.dangerRed,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              margin: const EdgeInsets.only(bottom: 12),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (_) => _deleteItem(item.key),
            child: Card(
              margin: const EdgeInsets.only(bottom: 12),
              color: const Color(0xFF1E1E1E),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: SafePermsTheme.primaryGreen.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item.permissionType == 'Camera' ? Icons.camera_alt :
                    item.permissionType == 'Location' ? Icons.location_on :
                    item.permissionType == 'Microphone' ? Icons.mic : Icons.contacts,
                    color: SafePermsTheme.primaryGreen,
                  ),
                ),
                title: Text(item.appName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle: Text(
                    '${item.permissionType} • ${item.time}',
                    style: const TextStyle(color: Colors.grey)
                ),
                // ADDED DELETE BUTTON NEXT TO SWITCH
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Switch(
                      value: item.isActive,
                      activeColor: SafePermsTheme.primaryGreen,
                      onChanged: (val) {
                        final updated = Schedule(
                          key: item.key,
                          appName: item.appName,
                          permissionType: item.permissionType,
                          time: item.time,
                          isActive: val,
                        );
                        _dbService.updateSchedule(updated);
                        _refreshList();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.grey),
                      onPressed: () => _deleteItem(item.key),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}