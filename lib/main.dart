import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'config/theme.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const SafePermsApp(),
    ),
  );
}

class AppState extends ChangeNotifier {
  // Simple state for UI demo
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/dashboard', builder: (context, state) => const DashboardScreen()),
  ],
);

class SafePermsApp extends StatelessWidget {
  const SafePermsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SafePerms',
      debugShowCheckedModeBanner: false,
      theme: SafePermsTheme.darkTheme,
      routerConfig: _router,
    );
  }
}