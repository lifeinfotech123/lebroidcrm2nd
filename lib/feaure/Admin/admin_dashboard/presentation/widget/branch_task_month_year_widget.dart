import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

// import '../data/model/admin_dashboard_model.dart';
import 'package:intl/intl.dart';

import '../../data/model/admin_dashboard_model.dart';

class BranchTaskMonthYearWidget extends StatelessWidget {
  final TasksOverviewData data;
  const BranchTaskMonthYearWidget({super.key, required this.data});

  Widget _buildItem(String title, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(title),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              "$value",
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.check_box_outlined, size: 18),
                const SizedBox(width: 8),
                Text(
                  "Tasks — ${DateFormat('MMMM yyyy').format(DateTime.now())}",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text("VIEW ALL"),
                )
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),

            _buildItem("Total", data.totalThisMonth, Colors.blue),
            _buildItem("Pending", data.pending, Colors.orange),
            _buildItem("In Progress", data.inProgress, Colors.indigo),
            _buildItem("Completed", data.completed, Colors.green),
            _buildItem("Overdue", data.overdue, Colors.red),
          ],
        ),
      ),
    );
  }
}