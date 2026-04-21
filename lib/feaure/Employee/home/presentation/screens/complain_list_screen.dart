import 'package:flutter/material.dart';

class ComplainsScreen extends StatelessWidget {
  const ComplainsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complaint List')),
      body: const Center(child: Text('Complaint List Screen')),
    );
  }
}
