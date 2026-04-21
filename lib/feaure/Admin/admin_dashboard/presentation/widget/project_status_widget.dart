import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class ProjectStatusWidget extends StatelessWidget {
  const ProjectStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [

          /// HEADER
          Row(
            children: [
              const Text(
                "Project Status",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              const Icon(Icons.more_vert)
            ],
          ),

          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade300),
          const SizedBox(height: 12),

          _projectItem("Apps Development", "Applications", 0.54, Colors.red),
          _projectItem("Dashboard Design", "App UI Kit", 0.86, Colors.blue),
          _projectItem("Facebook Marketing", "Marketing", 0.90, Colors.green),
          _projectItem("React Dashboard Github", "Dashboard", 0.37, Colors.teal),
          _projectItem("Paypal Payment Gateway", "Payment", 0.29, Colors.orange),

          const SizedBox(height: 16),

          Divider(color: Colors.grey.shade300),

          const SizedBox(height: 10),

          const Text(
            "UPCOMMING PROJECTS",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          )
        ],
      ),
    );
  }

  Widget _projectItem(
      String title,
      String subtitle,
      double progress,
      Color color,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [

          /// ICON PLACEHOLDER
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.image, size: 20),
          ),

          const SizedBox(width: 12),

          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                      color: Colors.grey.shade600, fontSize: 12),
                ),
                const SizedBox(height: 6),

                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(width: 12),

          Text(
            "${(progress * 100).toInt()}%",
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}