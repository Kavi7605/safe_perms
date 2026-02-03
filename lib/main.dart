import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/theme.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const SafePermsApp(),
    ),
  );
}

class SafePermsApp extends StatelessWidget {
  const SafePermsApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafePerms',
      debugShowCheckedModeBanner: false,
      theme: SafePermsTheme.darkTheme,
      home: const DashboardScreen(),
    );
  }
}

class AppState extends ChangeNotifier {
  int permissionCount = 42;
  int activeSchedules = 3;
  void updatePermissions(int count) {
    permissionCount = count;
    notifyListeners();
  }
}
