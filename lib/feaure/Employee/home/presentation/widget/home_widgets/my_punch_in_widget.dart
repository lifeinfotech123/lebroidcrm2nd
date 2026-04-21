import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class MyPunchInWidget extends StatelessWidget {
  const MyPunchInWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream: Stream.periodic(
        const Duration(seconds: 1),
        (_) => DateTime.now(),
      ),
      builder: (context, snapshot) {
        final DateTime time = snapshot.data ?? DateTime.now();
        final String formattedTime = DateFormat('hh:mm a').format(time);
        final String formattedDate = DateFormat(
          'EEE, dd MMM yyyy',
        ).format(time);

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withValues(alpha: 0.15),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Punch In Time',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    color: Color(0xFF1565C0),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    formattedTime,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                formattedDate,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ],
          ),
        );
      },
    );
  }
}
