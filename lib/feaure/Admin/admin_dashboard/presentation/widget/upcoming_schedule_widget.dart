import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class UpcomingScheduleWidget extends StatelessWidget {
  const UpcomingScheduleWidget({super.key});

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
                "Upcoming Schedule",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              const Icon(Icons.more_vert)
            ],
          ),

          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade300),
          const SizedBox(height: 12),

          /// LIST
          _scheduleItem("20", "DEC", "React Dashboard Design",
              "11:30am - 12:30pm", Colors.blue.shade100),

          _scheduleItem("30", "DEC", "Admin Design Concept",
              "10:00am - 12:00pm", Colors.orange.shade100),

          _scheduleItem("17", "DEC", "Standup Team Meeting",
              "8:00am - 9:00am", Colors.green.shade100),

          _scheduleItem("25", "DEC", "Zoom Team Meeting",
              "03:30pm - 05:30pm", Colors.red.shade100),

          const SizedBox(height: 16),

          Divider(color: Colors.grey.shade300),

          const SizedBox(height: 10),

          const Text(
            "UPCOMMING SCHEDULE",
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

  Widget _scheduleItem(
      String date,
      String month,
      String title,
      String time,
      Color color,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [

          /// DATE BOX
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  date,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  month,
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          /// TEXT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                      color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),

          /// RIGHT TEXT
          Row(
            children: const [
              Text("ma ma ma ma"),
              SizedBox(width: 8),
              Icon(Icons.more_horiz, size: 18)
            ],
          )
        ],
      ),
    );
  }
}