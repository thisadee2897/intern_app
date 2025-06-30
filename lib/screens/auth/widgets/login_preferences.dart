import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPreferences {
  static const String _rememberPasswordKey = 'remember_password';
  static const String _savedEmailKey = 'saved_email';
  static const String _savedPasswordKey = 'saved_password';

  // Save login preferences
  static Future<void> saveLoginData({
    required String email,
    required String password,
    required bool rememberPassword,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Always save email for convenience
      await prefs.setString(_savedEmailKey, email);
      
      // Save remember password preference
      await prefs.setBool(_rememberPasswordKey, rememberPassword);
      
      // Only save password if user chose to remember it
      if (rememberPassword) {
        // Note: In production, you should encrypt the password
        await prefs.setString(_savedPasswordKey, password);
      } else {
        // Clear saved password if user unchecked remember password
        await prefs.remove(_savedPasswordKey);
      }
    } catch (e) {
      debugPrint('Error saving login data: $e');
    }
  }

  // Get saved email
  static Future<String?> getSavedEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_savedEmailKey);
    } catch (e) {
      debugPrint('Error getting saved email: $e');
      return null;
    }
  }

  // Get saved password (if remember password is enabled)
  static Future<String?> getSavedPassword() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rememberPassword = prefs.getBool(_rememberPasswordKey) ?? false;
      
      if (rememberPassword) {
        return prefs.getString(_savedPasswordKey);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting saved password: $e');
      return null;
    }
  }

  // Check if remember password is enabled
  static Future<bool> isRememberPasswordEnabled() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_rememberPasswordKey) ?? false;
    } catch (e) {
      debugPrint('Error checking remember password: $e');
      return false;
    }
  }

  // Clear all saved login data
  static Future<void> clearLoginData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_savedEmailKey);
      await prefs.remove(_savedPasswordKey);
      await prefs.remove(_rememberPasswordKey);
    } catch (e) {
      debugPrint('Error clearing login data: $e');
    }
  }

  // Load saved login data
  static Future<Map<String, dynamic>> loadSavedLoginData() async {
    try {
      final email = await getSavedEmail();
      final password = await getSavedPassword();
      final rememberPassword = await isRememberPasswordEnabled();

      return {
        'email': email ?? '',
        'password': password ?? '',
        'rememberPassword': rememberPassword,
      };
    } catch (e) {
      debugPrint('Error loading saved login data: $e');
      return {
        'email': '',
        'password': '',
        'rememberPassword': false,
      };
    }
  }
}
