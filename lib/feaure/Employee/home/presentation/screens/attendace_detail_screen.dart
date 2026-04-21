import 'package:flutter/material.dart';

class AttendanceDetailScreen extends StatelessWidget {
  const AttendanceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Attendance Record',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            /// Month Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'May 2025',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Icon(Icons.chevron_left),
                    SizedBox(width: 8),
                    Icon(Icons.chevron_right),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Month Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: const [
                  _MonthChip('Mar', false),
                  _MonthChip('Apr', false),
                  _MonthChip('May', true),
                  _MonthChip('Jun', false),
                  _MonthChip('Jul', false),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// Extra Stats
            _StatsRow(),

            const SizedBox(height: 16),

            /// Attendance List
            const _AttendanceTile(
              date: 'Mon, May 19',
              status: 'Present',
              checkIn: '12:50:01',
              checkOut: '12:59:46',
              isPresent: true,
            ),
            const _AttendanceTile(
              date: 'Sun, May 18',
              status: 'Absent',
              checkIn: '09:55:35',
              isPresent: false,
            ),
            const _AttendanceTile(
              date: 'Sat, May 17',
              status: 'Present',
              checkIn: '11:25:09',
              checkOut: '18:57:06',
              isPresent: true,
            ),
            const _AttendanceTile(
              date: 'Fri, May 16',
              status: 'Absent',
              checkIn: '12:15:55',
              isPresent: false,
            ),
            const _AttendanceTile(
              date: 'Thu, May 15',
              status: 'Absent',
              checkIn: '18:04:07',
              isPresent: false,
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthChip extends StatelessWidget {
  final String text;
  final bool selected;

  const _MonthChip(this.text, this.selected);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? Colors.indigo : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: selected ? Colors.white : Colors.grey,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _StatItem(title: 'Working Days', value: '23'),
          _StatItem(title: 'Present', value: '0'),
          _StatItem(title: 'Absent', value: '23'),
          _StatItem(title: 'Attendance %', value: '0%'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String title;
  final String value;

  const _StatItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}

class _AttendanceTile extends StatelessWidget {
  final String date;
  final String status;
  final String checkIn;
  final String? checkOut;
  final bool isPresent;

  const _AttendanceTile({
    required this.date,
    required this.status,
    required this.checkIn,
    this.checkOut,
    required this.isPresent,
  });

  @override
  Widget build(BuildContext context) {
    final color = isPresent ? Colors.green : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 80,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '→ $checkIn',
                  style: TextStyle(color: Colors.green.shade700),
                ),
                if (checkOut != null)
                  Text(
                    '← $checkOut',
                    style: TextStyle(color: Colors.red.shade700),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
