import 'package:flutter/material.dart';

class ShowDataContainer extends StatelessWidget {
  final String label;
  final String total;
  final String? progressTitle;
  final double? progressValue;
  final Color backgroundColor;
  final IconData trendIcon;

  const ShowDataContainer({
    super.key,
    required this.label,
    required this.total,
    this.progressTitle,
    this.progressValue,
    required this.backgroundColor,
    required this.trendIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                total,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(trendIcon, color: Colors.white),
            ],
          ),
          if (progressTitle != null && progressValue != null) ...[
            const SizedBox(height: 8),
            Text(
              progressTitle!,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progressValue!.clamp(0.0, 1.0),
                minHeight: 4,
                backgroundColor: Colors.white24,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
