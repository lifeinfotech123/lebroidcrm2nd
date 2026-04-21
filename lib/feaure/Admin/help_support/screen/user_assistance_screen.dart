import 'package:flutter/material.dart';

class UserAssistanceScreen extends StatelessWidget {
  const UserAssistanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Assistance'), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 0),
      body: const Center(child: Text('Live Chat and User Tutorials')),
    );
  }
}
