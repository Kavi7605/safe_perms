import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: SafePermsTheme.surfaceLight,
                    shape: BoxShape.circle,
                    border: Border.all(color: SafePermsTheme.primaryGreen, width: 2),
                  ),
                  child: const Icon(
                      Icons.security,
                      size: 64,
                      color: SafePermsTheme.primaryGreen
                  ),
                ),
                const SizedBox(height: 24),

                Text('SafePerms', style: Theme.of(context).textTheme.displayLarge),
                const SizedBox(height: 8),
                Text('Advanced Permission Manager', style: Theme.of(context).textTheme.bodyMedium),

                const SizedBox(height: 48),

                // Inputs
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: Icon(Icons.email_outlined, color: SafePermsTheme.primaryGreen),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  obscureText: !_isPasswordVisible,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline, color: SafePermsTheme.primaryGreen),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go('/dashboard'),
                    child: const Text('LOGIN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),

                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                      'Create Account',
                      style: TextStyle(color: SafePermsTheme.primaryGreen)
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}