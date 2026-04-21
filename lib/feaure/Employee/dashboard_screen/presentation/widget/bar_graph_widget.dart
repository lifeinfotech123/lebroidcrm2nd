import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BarGraphWidget extends StatelessWidget {
  const BarGraphWidget({super.key});

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
          const Text(
            'Visitors',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 280,
            child: BarChart(
              BarChartData(
                maxY: 100,
                barTouchData: BarTouchData(enabled: true),
                titlesData: _titlesData(),
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: _barGroups(),
                extraLinesData: ExtraLinesData(horizontalLines: []),
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _Legend(color: Color(0xFF60A5FA), text: 'Visitors'),
              SizedBox(width: 16),
              _Legend(color: Color(0xFFA78BFA), text: 'Conversions'),
              SizedBox(width: 16),
              _Legend(color: Color(0xFF93C5FD), text: 'Revenue'),
            ],
          ),
        ],
      ),
    );
  }

  /// Bar groups (monthly data)
  List<BarChartGroupData> _barGroups() {
    final visitors = [70, 80, 90, 80, 90, 80, 90, 80, 90, 80, 90, 80];
    final conversions = [60, 70, 80, 70, 80, 70, 80, 70, 80, 70, 80, 70];
    final revenue = [50, 60, 70, 60, 70, 60, 70, 60, 70, 60, 70, 60];

    return List.generate(12, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: conversions[index].toDouble(),
            width: 8,
            borderRadius: BorderRadius.circular(6),
            color: const Color(0xFFA78BFA),
          ),
          BarChartRodData(
            toY: revenue[index].toDouble(),
            width: 8,
            borderRadius: BorderRadius.circular(6),
            color: const Color(0xFF93C5FD),
          ),
        ],
      );
    });
  }

  FlTitlesData _titlesData() {
    return FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 20,
          getTitlesWidget: (value, meta) {
            return Text(
              value.toInt().toString(),
              style: const TextStyle(fontSize: 10),
            );
          },
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            const months = [
              'Jan',
              'Feb',
              'Mar',
              'Apr',
              'May',
              'Jun',
              'Jul',
              'Aug',
              'Sep',
              'Oct',
              'Nov',
              'Dec',
            ];
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                months[value.toInt()],
                style: const TextStyle(fontSize: 10),
              ),
            );
          },
        ),
      ),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
