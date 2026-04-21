import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyCurrentProjectWidget extends StatelessWidget {
  final VoidCallback onpress;
  const MyCurrentProjectWidget({super.key, required this.onpress});

  @override
  Widget build(BuildContext context) {
    final String currentProject = 'Mobile App UI Design';
    final String todayDate = DateFormat(
      'EEE, dd MMM yyyy',
    ).format(DateTime.now());

    return GestureDetector(
      onTap: onpress,
      child: Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Current Project',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  todayDate,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1565C0),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    currentProject,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            if (currentProject.isEmpty) ...[
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'No project assigned today',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
