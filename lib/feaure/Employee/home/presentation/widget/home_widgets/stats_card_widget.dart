import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final String totalProjects;
  final String projects;
  final IconData projectsIcons;

  final String totalCompletedProjects;
  final String completedProjects;
  final IconData completedProjectsIcons;

  final String totalProgressProjects;
  final String progressProjects;
  final IconData totalprogressProjectsIcons;

  const StatCard({
    super.key,
    required this.totalProjects,
    required this.projects,
    required this.projectsIcons,
    required this.totalCompletedProjects,
    required this.completedProjects,
    required this.completedProjectsIcons,
    required this.totalProgressProjects,
    required this.progressProjects,
    required this.totalprogressProjectsIcons,
  });

  Widget _statItem({
    required IconData iconData,
    required String value,
    required String label,
    required Color accentColor,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(iconData, size: 26, color: accentColor),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.grey.shade300,
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF8FAFF), Color(0xFFFFFFFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Tasks Overview',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              _statItem(
                iconData: projectsIcons,
                value: totalProjects,
                label: projects,
                accentColor: Colors.blue,
              ),
              _divider(),
              _statItem(
                iconData: completedProjectsIcons,
                value: totalCompletedProjects,
                label: completedProjects,
                accentColor: Colors.green,
              ),
              _divider(),
              _statItem(
                iconData: totalprogressProjectsIcons,
                value: totalProgressProjects,
                label: progressProjects,
                accentColor: Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
