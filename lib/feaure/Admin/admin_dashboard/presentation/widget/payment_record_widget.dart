import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PaymentRecordWidget extends StatelessWidget {
  const PaymentRecordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Payment Record",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.more_vert, color: Colors.grey.shade600),
              ],
            ),

            const SizedBox(height: 20),

            /// CHART
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 70,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text("${value.toInt()}K",
                              style: const TextStyle(fontSize: 10));
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const months = [
                            "JAN",
                            "FEB",
                            "MAR",
                            "APR",
                            "MAY",
                            "JUN",
                            "JUL",
                            "AUG",
                            "SEP",
                            "OCT",
                            "NOV",
                            "DEC"
                          ];
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              months[value.toInt()],
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: false),
                  barGroups: _buildBarData(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// SUMMARY CARDS
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  return Row(
                    children: [
                      _buildInfoCard("Awaiting", "\$5,486", Colors.blue),
                      const SizedBox(width: 12),
                      _buildInfoCard("Completed", "\$9,275", Colors.green),
                      const SizedBox(width: 12),
                      _buildInfoCard("Rejected", "\$3,868", Colors.red),
                      const SizedBox(width: 12),
                      _buildInfoCard("Revenue", "\$50,668", Colors.black87),
                    ],
                  );
                } else {
                  // 2x2 Grid for mobile
                  return Column(
                    children: [
                      Row(
                        children: [
                          _buildInfoCard("Awaiting", "\$5,486", Colors.blue),
                          const SizedBox(width: 12),
                          _buildInfoCard("Completed", "\$9,275", Colors.green),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildInfoCard("Rejected", "\$3,868", Colors.red),
                          const SizedBox(width: 12),
                          _buildInfoCard("Revenue", "\$50,668", Colors.black87),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, Color color) {
    return Expanded(
      child: _InfoCard(
        title: title,
        value: value,
        color: color,
      ),
    );
  }

  List<BarChartGroupData> _buildBarData() {
    final data = [
      22, 10, 21, 27, 12, 21, 36, 20, 43, 21, 29, 20
    ];

    return List.generate(data.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data[index].toDouble(),
            width: 10,
            borderRadius: BorderRadius.circular(4),
            color: Colors.blue,
          ),
        ],
      );
    });
  }
}

/// INFO CARD WIDGET
class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 10),
          Container(
            height: 4,
            width: double.infinity,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          )
        ],
      ),
    );
  }
}