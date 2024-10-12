import 'package:flutter/material.dart';
import 'package:taskproject/local_storage.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<Map<String, dynamic>> _userCounters = [];

  @override
  void initState() {
    super.initState();
    _loadUserCounters();
  }

  Future<void> _loadUserCounters() async {
    List<String> users = await SharedPreferenceHelper.getAllUsers();
    List<Map<String, dynamic>> userCounters = [];

    for (String user in users) {
      int? counter = await SharedPreferenceHelper.getCounterValue(user);
      userCounters.add({'username': user, 'counter': counter ?? 0});
    }

    setState(() {
      _userCounters = userCounters;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.black,
        title: const Text(
          "User Click Counters",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _userCounters.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ScrollConfiguration(
              behavior:
                  ScrollConfiguration.of(context).copyWith(scrollbars: false),
              child: ListView.builder(
                itemCount: _userCounters.length,
                itemBuilder: (context, index) {
                  final user = _userCounters[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text('${index + 1}'),
                      ),
                      title: Text(user['username']),
                      subtitle: Text('Counter: ${user['counter']}'),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
