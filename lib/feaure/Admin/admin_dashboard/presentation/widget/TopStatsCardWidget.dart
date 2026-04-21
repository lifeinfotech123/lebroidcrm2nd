import 'package:flutter/material.dart';
import '../../data/model/admin_dashboard_model.dart';
// import '../data/model/admin_dashboard_model.dart';

class TopStatsCardWidget extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final String progressText;
  final double progress;
  final Color progressColor;
  final IconData icon;

  const TopStatsCardWidget({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.progressText,
    required this.progress,
    required this.progressColor,
    required this.icon,
  });

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.grey.shade700),
              ),
              const Spacer(),
              const Icon(Icons.more_vert, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Flexible(
                child: Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  progressText,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(progressColor),
            ),
          )
        ],
      ),
    );
  }
}

class TopStatsSection extends StatelessWidget {
  final OrganizationData data;
  const TopStatsSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 900) {
          // Desktop (4 in row)
          return Row(
            children: _buildItems(),
          );
        } else {
          // Tablet + Mobile → 2 per row
          return Column(
            children: [
              Row(
                children: [
                  _buildItem(0),
                  const SizedBox(width: 16),
                  _buildItem(1),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildItem(2),
                  const SizedBox(width: 16),
                  _buildItem(3),
                ],
              ),
            ],
          );
        }
      },
    );
  }

  List<Widget> _buildItems() {
    return [
      _buildItem(0),
      const SizedBox(width: 16),
      _buildItem(1),
      const SizedBox(width: 16),
      _buildItem(2),
      const SizedBox(width: 16),
      _buildItem(3),
    ];
  }

  Widget _buildItem(int index) {
    // We map real data to the stats widgets
    final card = [
      TopStatsCardWidget(
        icon: Icons.people,
        value: "${data.workforce.total}",
        title: "Total Workforce",
        subtitle: "On Leave: ${data.workforce.onLeave}",
        progressText: "Active: ${data.workforce.total - data.workforce.onLeave}",
        progress: data.workforce.total > 0 ? (data.workforce.total - data.workforce.onLeave) / data.workforce.total : 0,
        progressColor: Colors.blue,
      ),
      TopStatsCardWidget(
        icon: Icons.calendar_today,
        value: "${data.todayAttendance.present}/${data.workforce.total}",
        title: "Today's Attendance",
        subtitle: "Absent: ${data.todayAttendance.absent}",
        progressText: "Late: ${data.todayAttendance.late}",
        progress: data.workforce.total > 0 ? (data.todayAttendance.present) / data.workforce.total : 0,
        progressColor: Colors.orange,
      ),
      TopStatsCardWidget(
        icon: Icons.monetization_on,
        value: "₹${data.payrollSummary.totalNet}",
        title: "Payroll Processing",
        subtitle: "Paid: ${data.payrollSummary.paid}",
        progressText: "Processed: ${data.payrollSummary.processed}",
        progress: data.payrollSummary.processed > 0 ? data.payrollSummary.paid / data.payrollSummary.processed : 0,
        progressColor: Colors.green,
      ),
      TopStatsCardWidget(
        icon: Icons.receipt,
        value: "₹${data.expenseSummary.pendingAmount}",
        title: "Pending Expenses",
        subtitle: "Approved (M): ₹${data.expenseSummary.approvedThisMonth}",
        progressText: "",
        progress: 0.5,
        progressColor: Colors.red,
      ),
    ][index];

    return Expanded(child: card);
  }
}




class StatsCardWidget extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final String progressText;
  final double progress;
  final Color progressColor;
  final IconData icon;

  const StatsCardWidget({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.progressText,
    required this.progress,
    required this.progressColor,
    required this.icon,
  });

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
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.grey.shade700),
              ),
              const Spacer(),
              const Icon(Icons.more_vert, size: 18)
            ],
          ),

          const SizedBox(height: 14),

          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            title,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Flexible(
                child: Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  progressText,
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(progressColor),
            ),
          )
        ],
      ),
    );
  }
}




