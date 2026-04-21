import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import '../../data/model/admin_dashboard_model.dart';
// import '../data/model/admin_dashboard_model.dart';

class BranchAttendanceTodayWidget extends StatelessWidget {
  final List<BranchData> branches;
  const BranchAttendanceTodayWidget({super.key, required this.branches});

  Widget _buildRow({
    required String branch,
    required String manager,
    required int staff,
    required int present,
    required String extra,
    required double rate,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(branch)),
          Expanded(flex: 2, child: Text(manager)),
          Expanded(child: Text("$staff")),
          Expanded(
            child: Row(
              children: [
                Text(
                  "$present",
                  style: const TextStyle(color: Colors.green),
                ),
                if (extra.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      extra,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FractionallySizedBox(
                    widthFactor: rate,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text("${(rate * 100).toInt()}%"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.black54,
        ),
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
              children: const [
                Icon(Icons.location_on_outlined, size: 18),
                SizedBox(width: 8),
                Text(
                  "Branch Attendance Today",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),

            // Table Header
            Row(
              children: [
                _header("BRANCH", flex: 2),
                _header("MANAGER", flex: 2),
                _header("STAFF"),
                _header("PRESENT"),
                _header("RATE"),
              ],
            ),

            const SizedBox(height: 10),

            // Rows
            if (branches.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("No branches available."),
              )
            else
              ...branches.map((branch) => _buildRow(
                    branch: branch.name,
                    manager: branch.manager.isEmpty ? "—" : branch.manager,
                    staff: branch.employees,
                    present: branch.present,
                    extra: "", // If logic dictates late/absent add here
                    rate: branch.employees > 0 ? (branch.present / branch.employees) : 0.0,
                  )),
          ],
        ),
      ),
    );
  }
}