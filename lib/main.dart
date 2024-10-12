import 'package:flutter/material.dart';
import 'package:taskproject/home_screen/home_screen.dart';
import 'package:taskproject/local_storage.dart';
import 'package:taskproject/userauth/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final isLoggedIn = await SharedPreferenceHelper.getIsLoggedIn();
    setState(() {
      _isLoggedIn = isLoggedIn ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(), // Light theme
      darkTheme: ThemeData.dark(), // Dark theme
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: _isLoggedIn ? HomeScreen() : LoginScreen(),
    );
  }
}
