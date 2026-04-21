import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import '../../data/model/admin_dashboard_model.dart';
// import '../data/model/admin_dashboard_model.dart';
import 'package:intl/intl.dart';

class UpcomingHolidaysWidget extends StatelessWidget {
  final SharedData data;
  const UpcomingHolidaysWidget({super.key, required this.data});

  Widget _holidayItem({
    required String date,
    required String month,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          // Date Box
          Container(
            width: 50,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  date,
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  month,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        "National",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
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
              children: [
                const Icon(Icons.calendar_today, size: 18),
                const SizedBox(width: 8),
                const Text(
                  "Upcoming Holidays",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text("MANAGE"),
                )
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),

            if (data.upcomingHolidays.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("No upcoming holidays."),
              )
            else
              ...data.upcomingHolidays.map((holiday) {
                DateTime parsedDate = DateTime.tryParse(holiday.date) ?? DateTime.now();
                return _holidayItem(
                  date: DateFormat('dd').format(parsedDate),
                  month: DateFormat('MMM').format(parsedDate),
                  title: holiday.name,
                  subtitle: DateFormat('EEEE').format(parsedDate),
                );
              }),
          ],
        ),
      ),
    );
  }
}