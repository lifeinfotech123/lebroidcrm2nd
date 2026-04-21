import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import '../../data/model/admin_dashboard_model.dart';
// import '../data/model/admin_dashboard_model.dart';
import 'package:intl/intl.dart';

class TodaysAttendanceWidget extends StatelessWidget {
  final TodayAttendanceData data;
  const TodaysAttendanceWidget({super.key, required this.data});

  Widget _buildAttendanceRow({
    required Color color,
    required String title,
    required int value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // Dot
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),

          // Title
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ),

          // Progress bar
          Expanded(
            flex: 2,
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: value == 0 ? 0.05 : value / 10, // simple scaling
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Value
          Text(
            "$value",
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 18),
                const SizedBox(width: 8),
                const Text(
                  "Today's Attendance",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  DateFormat("dd MMM yyyy").format(DateTime.now()),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Rows
            _buildAttendanceRow(
              color: Colors.green,
              title: "Present",
              value: data.present,
            ),
            _buildAttendanceRow(
              color: Colors.red,
              title: "Absent",
              value: data.absent,
            ),
            _buildAttendanceRow(
              color: Colors.orange,
              title: "Late",
              value: data.late,
            ),
            _buildAttendanceRow(
              color: Colors.teal,
              title: "On Leave",
              value: 0, // No specific leave stat just for today in this block
            ),

            const SizedBox(height: 20),

            // Overall %
            Column(
              children: [
                Text(
                  "${data.pct.toStringAsFixed(1)}%",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Overall Attendance",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}