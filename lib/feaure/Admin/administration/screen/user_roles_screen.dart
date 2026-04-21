import 'package:flutter/material.dart';

class UserRolesScreen extends StatelessWidget {
  const UserRolesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administration Tools'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: const Center(child: Text('Admin Control Panel')),
    );
  }
}
