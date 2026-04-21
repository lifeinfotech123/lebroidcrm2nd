import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

// import '../data/model/admin_dashboard_model.dart';
import 'package:intl/intl.dart';

import '../../data/model/admin_dashboard_model.dart';

class BranchExpencesMonthYearsWidget extends StatelessWidget {
  final ExpenseSummaryData data;
  const BranchExpencesMonthYearsWidget({super.key, required this.data});

  Widget _buildRow(String title, String amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(title),
          const Spacer(),
          Text(
            amount,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.receipt_long_outlined, size: 18),
                const SizedBox(width: 8),
                Text(
                  "Expenses — M${DateFormat("MM yyyy").format(DateTime.now())}",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("APPROVE"),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),

            _buildRow("Pending", "₹${data.pendingAmount}", Colors.orange),
            _buildRow("Approved", "₹${data.approvedThisMonth}", Colors.green),
          ],
        ),
      ),
    );
  }
}