import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraphWidget extends StatelessWidget {
  const GraphWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Left
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Earnings',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Text(
                        '\$8900',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '20.9%',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_upward, size: 14, color: Colors.green),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.blue),
                    ),
                    child: const Text(
                      'In December',
                      style: TextStyle(fontSize: 10, color: Colors.blue),
                    ),
                  ),
                ],
              ),

              /// Right buttons
              Row(
                children: [
                  _chip('This Week', true),
                  const SizedBox(width: 6),
                  _chip('Last Week', false),
                  const SizedBox(width: 6),
                  _iconButton(Icons.open_in_full),
                  const SizedBox(width: 6),
                  _iconButton(Icons.download),
                  const SizedBox(width: 6),
                  _iconButton(Icons.more_horiz),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// Bar chart
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                maxY: 100,
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: false,
                  getDrawingVerticalLine: (value) {
                    return FlLine(color: Colors.grey.shade200, strokeWidth: 1);
                  },
                ),
                borderData: FlBorderData(show: false),
                titlesData: _titles(),
                barGroups: _bars(),
                barTouchData: BarTouchData(enabled: true),
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _Legend(color: Color(0xFF60A5FA), text: 'Income'),
              SizedBox(width: 16),
              _Legend(color: Color(0xFFA78BFA), text: 'Expenses'),
            ],
          ),
        ],
      ),
    );
  }

  /// Weekly bars
  List<BarChartGroupData> _bars() {
    final income = [20, 35, 45, 55, 65, 75, 85];
    final expenses = [25, 40, 50, 60, 70, 80, 90];

    return List.generate(7, (index) {
      return BarChartGroupData(
        x: index,
        barsSpace: 6,
        barRods: [
          BarChartRodData(
            toY: income[index].toDouble(),
            width: 8,
            borderRadius: BorderRadius.circular(6),
            color: const Color(0xFF60A5FA),
          ),
          BarChartRodData(
            toY: expenses[index].toDouble(),
            width: 8,
            borderRadius: BorderRadius.circular(6),
            color: const Color(0xFFA78BFA),
          ),
        ],
      );
    });
  }

  FlTitlesData _titles() {
    return FlTitlesData(
      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                days[value.toInt()],
                style: const TextStyle(fontSize: 11),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _chip(String text, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: active ? Colors.blue : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.blue),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: active ? Colors.white : Colors.blue,
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.blue),
      ),
      child: Icon(icon, size: 14, color: Colors.blue),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String text;

  const _Legend({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
