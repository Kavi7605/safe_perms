import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _kLoggedInKey = 'isLoggedIn';
  static const String _kEmailKey = 'userEmail';
  static const String _kPasswordKey = 'userPassword';
  static const String _kNameKey = 'userName';

  // Check if user is already logged in (Session Management)
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kLoggedInKey) ?? false;
  }

  // Register a new user (Save to Local DB)
  Future<bool> register(String name, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    // In a real app, you'd check if email exists. Here we just overwrite for demo.
    await prefs.setString(_kNameKey, name);
    await prefs.setString(_kEmailKey, email);
    await prefs.setString(_kPasswordKey, password);
    return true;
  }

  // Login user (Validate against Local DB)
  Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString(_kEmailKey);
    final storedPass = prefs.getString(_kPasswordKey);

    if (storedEmail == email && storedPass == password) {
      await prefs.setBool(_kLoggedInKey, true);
      return true;
    }
    return false;
  }

  // Logout (Clear Session)
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kLoggedInKey, false);
  }
}