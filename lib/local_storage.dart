import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static const String _userNameKey = 'username';
  static const String _isLoggedInKey = 'isLoggedIn';
  static const String _usersListKey = 'users_list';

  // Dynamic counter key for each user
  static String _counterKey(String username) => 'counter_$username';

  // Set and get username for registration
  static Future<void> setUserName(String username) async {
    final prefs = await SharedPreferences.getInstance();

    // Add username to the list of users
    List<String> users = (await prefs.getStringList(_usersListKey)) ?? [];
    if (!users.contains(username)) {
      users.add(username);
      await prefs.setStringList(_usersListKey, users);
    }

    await prefs.setString(_userNameKey, username);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  // Set and get login status
  static Future<void> setIsLoggedIn(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  static Future<bool?> getIsLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey);
  }

  // Set and get counter value for each user
  static Future<void> setCounterValue(String username, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_counterKey(username), value);
  }

  static Future<int?> getCounterValue(String username) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_counterKey(username));
  }

  // Get all users
  static Future<List<String>> getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_usersListKey) ?? [];
  }

  // Clear data on logout
  static Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
