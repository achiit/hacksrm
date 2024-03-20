import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class UserDataScreen extends StatefulWidget {
  const UserDataScreen({Key? key}) : super(key: key);

  @override
  _UserDataScreenState createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  late Future<List<Map<String, dynamic>>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _getUserData();
  }

  Future<List<Map<String, dynamic>>> _getUserData() async {
    // Open the database
    final Database database = await openDatabase(
      path.join(await getDatabasesPath(), 'user_database.db'),
    );

    // Query the database for user data
    final List<Map<String, dynamic>> userData = await database.query('users');

    return userData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Data'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final userData = snapshot.data!;
            if (userData.isEmpty) {
              return Center(child: Text('No user data found'));
            } else {
              final userName = userData.first['name'] as String;
              return Center(child: Text('User Name: $userName'));
            }
          }
        },
      ),
    );
  }
}
