import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import '../../data/model/admin_dashboard_model.dart';
// import '../data/model/admin_dashboard_model.dart';

class RecentActivityWidget extends StatelessWidget {
  final List<RecentAuditData> activities;
  const RecentActivityWidget({super.key, required this.activities});

  Widget _activityItem(String title, String subtitle, String time) {
    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 14,
              backgroundColor: Colors.grey.shade200,
              child: const Text(
                "S",
                style: TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            Text(
              time,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black45,
              ),
            )
          ],
        ),
        const SizedBox(height: 12),
        Divider(color: Colors.grey.shade200),
      ],
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
              children: [
                const Icon(Icons.show_chart, size: 18),
                const SizedBox(width: 8),
                const Text(
                  "Recent Activity",
                  style: TextStyle(fontWeight: FontWeight.w600),
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

            if (activities.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("No recent activities."),
              )
            else
              ...activities.take(5).map((activity) {
                return _activityItem(
                  activity.user['name'] ?? "Unknown",
                  "${activity.event} ${activity.module}",
                  activity.createdAt,
                );
              }),
          ],
        ),
      ),
    );
  }
}