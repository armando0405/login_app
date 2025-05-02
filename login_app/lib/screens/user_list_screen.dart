import 'package:flutter/material.dart';
import '../widgets/user_list.dart';

class UserListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Consistente modo oscuro
      body: SafeArea(
        child: UserList(),
      ),
    );
  }
}