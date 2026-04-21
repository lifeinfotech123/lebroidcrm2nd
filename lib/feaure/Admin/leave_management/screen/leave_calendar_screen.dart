import 'package:flutter/material.dart';

class LeaveCalendarScreen extends StatefulWidget {
  const LeaveCalendarScreen({super.key});

  @override
  State<LeaveCalendarScreen> createState() => _LeaveCalendarScreenState();
}

class _LeaveCalendarScreenState extends State<LeaveCalendarScreen> {
  final List<String> _weekdays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  // Days for March 2026 calendar view (starting Mon, Feb 23)
  final List<int> _days = [
    23, 24, 25, 26, 27, 28, 1, // Feb-Mar
    2, 3, 4, 5, 6, 7, 8,
    9, 10, 11, 12, 13, 14, 15,
    16, 17, 18, 19, 20, 21, 22,
    23, 24, 25, 26, 27, 28, 29,
    30, 31, 1, 2, 3, 4, 5,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Leave Calendar',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        shadowColor: Colors.black12,
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCalendarCard(),
            const SizedBox(height: 16),
            _buildLegendCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildCalendarHeader(),
          const Divider(height: 1),
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.chevron_left),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                color: Colors.grey.shade600,
              ),
              const SizedBox(width: 12),
              const Text(
                'March 2026',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(width: 12),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.chevron_right),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                color: Colors.grey.shade600,
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 14,
                  color: Colors.indigo.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  '2 on leave this month',
                  style: TextStyle(
                    color: Colors.indigo.shade700,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    return Column(
      children: [
        // Weekdays Header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: _weekdays.map((day) {
              bool isWeekend = day == 'Sat' || day == 'Sun';
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: isWeekend
                          ? Colors.red.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        // Days Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 0.8, // Make cells taller than wide for content
          ),
          itemCount: _days.length,
          itemBuilder: (context, index) {
            int day = _days[index];
            bool isCurrentMonth = (index >= 6 && index <= 36);
            bool isWeekend = index % 7 == 5 || index % 7 == 6; // Sat or Sun
            bool isToday = day == 20 && isCurrentMonth;
            bool hasLeaveOn7th = day == 7 && isCurrentMonth;

            return Container(
              decoration: BoxDecoration(
                color: isWeekend ? Colors.grey.shade50 : Colors.white,
                border: Border(
                  right: BorderSide(color: Colors.grey.shade100, width: 1),
                  bottom: BorderSide(color: Colors.grey.shade100, width: 1),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: isToday
                          ? BoxDecoration(
                              color: Colors.indigo,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.indigo.withOpacity(0.3),
                                  blurRadius: 4,
                                ),
                              ],
                            )
                          : null,
                      child: Center(
                        child: Text(
                          '$day',
                          style: TextStyle(
                            fontWeight: isToday
                                ? FontWeight.bold
                                : (isCurrentMonth
                                      ? FontWeight.w600
                                      : FontWeight.normal),
                            fontSize: 13,
                            color: isToday
                                ? Colors.white
                                : (isCurrentMonth
                                      ? (isWeekend
                                            ? Colors.red.shade400
                                            : Colors.black87)
                                      : Colors.grey.shade300),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    left: 6,
                    child: isToday
                        ? Text(
                            'Today',
                            style: TextStyle(
                              color: Colors.indigo.shade600,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : (isWeekend && isCurrentMonth
                              ? Text(
                                  'Weekend',
                                  style: TextStyle(
                                    color: Colors.red.shade300,
                                    fontSize: 8,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              : const SizedBox.shrink()),
                  ),
                  if (hasLeaveOn7th)
                    Positioned(
                      bottom: 4,
                      left: 2,
                      right: 2,
                      child: Column(
                        children: [
                          _buildLeaveChip('Amit Kumar', Colors.blue),
                          const SizedBox(height: 2),
                          _buildLeaveChip('Kavita Patel', Colors.blue),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLeaveChip(String name, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.shade200),
      ),
      child: Text(
        name,
        style: TextStyle(
          color: color.shade700,
          fontSize: 7,
          fontWeight: FontWeight.bold,
        ),
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildLegendCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  Icons.palette_outlined,
                  size: 18,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 8),
                Text(
                  'Leave Types Legend',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                _buildLegendItem('Annual Leave', Colors.blue),
                _buildLegendItem('Sick Leave', Colors.red),
                _buildLegendItem('Casual Leave', Colors.orange),
                _buildLegendItem('Unpaid Leave', Colors.grey),
                _buildLegendItem('Maternity Leave', Colors.pink),
                _buildLegendItem('Paternity Leave', Colors.purple),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String title, MaterialColor color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color.shade100,
            border: Border.all(color: color.shade400),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
