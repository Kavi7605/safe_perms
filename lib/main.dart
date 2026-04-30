import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'config/theme.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart'; // Make sure this exists if you use it
import 'screens/dashboard_screen.dart';
import 'screens/schedule_screen.dart';
import 'screens/apps_screen.dart';
import 'screens/settings_screen.dart'; // If you created this in Lab 7
import 'services/auth_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Database
  await Hive.initFlutter();
  await Hive.openBox('schedules');

  // Check Login State
  final isLoggedIn = await AuthService.isLoggedIn();

  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: SafePermsApp(initialLocation: isLoggedIn ? '/dashboard' : '/'),
    ),
  );
}

class AppState extends ChangeNotifier {}

class SafePermsApp extends StatelessWidget {
  final String initialLocation;
  const SafePermsApp({super.key, required this.initialLocation});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
        // If you haven't created RegisterScreen yet, comment this line out
        GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
        GoRoute(path: '/dashboard', builder: (context, state) => const DashboardScreen()),
        GoRoute(path: '/schedules', builder: (context, state) => const ScheduleScreen()),
        GoRoute(path: '/apps', builder: (context, state) => const AppsScreen()),
        GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
      ],
    );

    return MaterialApp.router(
      title: 'SafePerms',
      debugShowCheckedModeBanner: false,
      theme: SafePermsTheme.darkTheme,
      routerConfig: router,
    );
  }
}