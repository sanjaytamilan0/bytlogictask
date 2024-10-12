import 'package:flutter/material.dart';
import 'package:taskproject/home_screen/all_user_count.dart';
import 'package:taskproject/local_storage.dart';
import 'package:taskproject/userauth/login_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;
  String _username = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    _username = await SharedPreferenceHelper.getUserName() ?? '';
    _counter = await SharedPreferenceHelper.getCounterValue(_username) ?? 0;
    setState(() {});
  }

  void _incrementCounter() async {
    setState(() {
      _counter++;
    });
    await SharedPreferenceHelper.setCounterValue(_username, _counter);
  }

  void _decrementCounter() async {
    setState(() {
      if (_counter > 0) {
        _counter--;
      }
    });
    await SharedPreferenceHelper.setCounterValue(_username, _counter);
  }

  void _logout() async {
    await SharedPreferenceHelper.setIsLoggedIn(false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _showUserCounters() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserListScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          _username,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
              size: 25,
            ),
            onPressed: _logout,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$_username Press Count:',
                style: const TextStyle(fontSize: 24)),
            Text(
              '$_counter',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _decrementCounter,
                  child: const Text(
                    "Decrement",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _incrementCounter,
                  child: const Text(
                    "Increment",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showUserCounters,
              child: const Text(
                "View All User press Count >",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
