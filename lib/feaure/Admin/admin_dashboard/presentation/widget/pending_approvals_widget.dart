import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import '../../data/model/admin_dashboard_model.dart';
// import '../data/model/admin_dashboard_model.dart';

class PendingApprovalsWidget extends StatelessWidget {
  final PendingApprovalsData data;
  const PendingApprovalsWidget({super.key, required this.data});

  Widget _buildItem({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),

            const SizedBox(height: 10),

            // Count
            Text(
              "$count",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),

            const SizedBox(height: 4),

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Header
            Row(
              children: const [
                Icon(Icons.pending_actions, size: 18),
                SizedBox(width: 8),
                Text(
                  "Pending Approvals",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Grid Layout (2 rows)
            Column(
              children: [
                Row(
                  children: [
                    _buildItem(
                      title: "Leaves",
                      count: data.leaves,
                      icon: Icons.event_note,
                      color: Colors.orange,
                    ),
                    _buildItem(
                      title: "Expenses",
                      count: data.expensesCount,
                      icon: Icons.receipt_long,
                      color: Colors.red,
                    ),
                    _buildItem(
                      title: "Task\nCompletions",
                      count: 0, // Hardcoded for now
                      icon: Icons.task_alt,
                      color: Colors.green,
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildItem(
                      title: "Overtime",
                      count: data.overtime,
                      icon: Icons.access_time,
                      color: Colors.blue,
                    ),
                    _buildItem(
                      title: "Payrolls",
                      count: 0,
                      icon: Icons.payments,
                      color: Colors.purple,
                    ),
                    const Spacer(), // keeps layout balanced
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}