import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import '../../data/model/admin_dashboard_model.dart';

// import '../data/model/admin_dashboard_model.dart';

class SevenDatsAttendanceTrend extends StatelessWidget {
  final List<AttendanceTrendData> data;
  const SevenDatsAttendanceTrend({super.key, required this.data});

  Widget _buildRow(String day, double presentRatio, int present, int absent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(day),
          ),

          // Bar
          Expanded(
            child: Row(
              children: [
                if (presentRatio > 0)
                  Container(
                    height: 16,
                    width: 200 * presentRatio,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                Expanded(
                  child: Container(
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Text(
            "${present}P",
            style: const TextStyle(color: Colors.green),
          ),
          const SizedBox(width: 6),
          Text(
            "${absent}A",
            style: const TextStyle(color: Colors.red),
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
            Row(
              children: const [
                Icon(Icons.show_chart, size: 18),
                SizedBox(width: 8),
                Text(
                  "7-Day Attendance Trend",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),

            if (data.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("No attendance trend data available."),
              )
            else
              ...data.map((trend) => _buildRow(
                    trend.date,
                    trend.total > 0 ? (trend.present / trend.total) : 0.0,
                    trend.present,
                    trend.total - trend.present, // Absent
                  )),
          ],
        ),
      ),
    );
  }
}