import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieGraphWidget extends StatelessWidget {
  const PieGraphWidget({super.key});

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
              const Text(
                'Conversions',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: const [
                      Text(
                        '960',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        '33.6%',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_upward, size: 14, color: Colors.green),
                    ],
                  ),
                  const SizedBox(height: 4),
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
            ],
          ),

          const SizedBox(height: 20),

          /// Pie chart
          SizedBox(
            height: 180,
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 0,
                sectionsSpace: 2,
                sections: _sections(),
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// Legend
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 8,
            children: const [
              _Legend(color: Color(0xFF60A5FA), text: 'Google'),
              _Legend(color: Color(0xFF3B82F6), text: 'Twitter'),
              _Legend(color: Color(0xFF2563EB), text: 'Instagram'),
              _Legend(color: Color(0xFF1D4ED8), text: 'YouTube'),
            ],
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _sections() {
    return [
      PieChartSectionData(
        value: 28,
        color: const Color(0xFF60A5FA),
        radius: 70,
        showTitle: false,
      ),
      PieChartSectionData(
        value: 22,
        color: const Color(0xFF3B82F6),
        radius: 70,
        showTitle: false,
      ),
      PieChartSectionData(
        value: 30,
        color: const Color(0xFF2563EB),
        radius: 70,
        showTitle: false,
      ),
      PieChartSectionData(
        value: 20,
        color: const Color(0xFF1D4ED8),
        radius: 70,
        showTitle: false,
      ),
    ];
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String text;

  const _Legend({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
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
