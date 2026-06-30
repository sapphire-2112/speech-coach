import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _registeredNameKey = 'registered_name';
  static const String _registeredEmailKey = 'registered_email';
  static const String _registeredPasswordKey = 'registered_password';
  static const String _isLoggedInKey = 'is_logged_in';

  static Future<bool> hasRegisteredUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_registeredEmailKey) && prefs.containsKey(_registeredPasswordKey);
  }

  static Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final registeredEmail = prefs.getString(_registeredEmailKey);
    if (registeredEmail != null) {
      return false;
    }

    await prefs.setString(_registeredNameKey, name.trim());
    await prefs.setString(_registeredEmailKey, email.trim().toLowerCase());
    await prefs.setString(_registeredPasswordKey, password);
    await prefs.setBool(_isLoggedInKey, true);
    return true;
  }

  static Future<bool> login({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final registeredEmail = prefs.getString(_registeredEmailKey);
    final registeredPassword = prefs.getString(_registeredPasswordKey);

    if (registeredEmail == null || registeredPassword == null) {
      return false;
    }

    final isMatching = registeredEmail == email.trim().toLowerCase() && registeredPassword == password;
    if (isMatching) {
      await prefs.setBool(_isLoggedInKey, true);
    }
    return isMatching;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
  }

  static Future<String?> getRegisteredName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_registeredNameKey);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }
}
