import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'config/theme.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/schedule_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Hive (Database)
  await Hive.initFlutter();
  await Hive.openBox('schedules'); // Create a box (table) for schedules

  // 2. Check Session
  final isLoggedIn = await AuthService().isLoggedIn();

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
        GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
        GoRoute(path: '/dashboard', builder: (context, state) => const DashboardScreen()),
        // Add the new CRUD Screen Route
        GoRoute(path: '/schedules', builder: (context, state) => const ScheduleScreen()),
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