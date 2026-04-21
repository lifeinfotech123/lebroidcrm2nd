import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import '../../data/model/admin_dashboard_model.dart';

// import '../data/model/admin_dashboard_model.dart';

class PayrollMonthYearWidget extends StatelessWidget {
  final PayrollSummaryData data;
  const PayrollMonthYearWidget({super.key, required this.data});

  Widget _buildStatusItem({
    required String title,
    required int count,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            "$count",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountRow({
    required String title,
    required String amount,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
          const Spacer(),
          Text(
            amount,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.payments_outlined, size: 18),
                const SizedBox(width: 8),
                Text(
                  "Payroll — ${data.targetMonth}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Status Row
            Row(
              children: [
                _buildStatusItem(
                  title: "Processed",
                  count: data.processed,
                  color: Colors.blue,
                ),
                _buildStatusItem(
                  title: "Paid",
                  count: data.paid,
                  color: Colors.green,
                ),
              ],
            ),

            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 10),

            // Amount Details
            _buildAmountRow(
              title: "Net Pay",
              amount: "₹${data.totalNet}",
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}