import 'package:flutter/material.dart';
import 'package:taskproject/home_screen/home_screen.dart';
import 'package:taskproject/local_storage.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoginSelected = true;
  final TextEditingController _userNameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    bool? isLoggedIn = await SharedPreferenceHelper.getIsLoggedIn();
    if (isLoggedIn == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                ToggleButtons(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text('Login'),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Text('Register'),
                    ),
                  ],
                  isSelected: [isLoginSelected, !isLoginSelected],
                  onPressed: (index) {
                    setState(() {
                      isLoginSelected = index == 0;
                    });
                  },
                  borderRadius: BorderRadius.circular(30),
                  selectedColor: Colors.white,
                  fillColor: Colors.red,
                  color: Colors.red,
                  selectedBorderColor: Colors.red,
                  borderColor: Colors.red,
                ),
                const SizedBox(height: 30),
                const Text(
                  'Glad to see you!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  isLoginSelected
                      ? 'Please provide your username to login'
                      : 'Please register with your username',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _userNameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: Text(isLoginSelected ? 'Log In' : 'Register'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String username = _userNameController.text;
                      if (isLoginSelected) {
                        bool success = await _login(username);
                        if (success) {
                          await SharedPreferenceHelper.setIsLoggedIn(true);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                          );
                        } else {
                          _showErrorDialog(
                              'Login failed. Username does not exist.');
                        }
                      } else {
                        bool registered = await _register(username);
                        if (registered) {
                          _userNameController.clear();
                          _showSuccessDialog('Registration successful!');
                        } else {
                          _showErrorDialog(
                              'Registration failed. User already exists.');
                        }
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _register(String username) async {
    List<String> users = await SharedPreferenceHelper.getAllUsers();
    if (users.contains(username)) {
      // User already exists
      return false;
    } else {
      await SharedPreferenceHelper.setUserName(username);
      return true;
    }
  }

  Future<bool> _login(String username) async {
    List<String> users = await SharedPreferenceHelper.getAllUsers();
    return users.contains(username);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _userNameController.dispose();
    super.dispose();
  }
}
