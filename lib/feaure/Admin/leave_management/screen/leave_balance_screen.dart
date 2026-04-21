import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/leave_management_bloc.dart';
import '../bloc/leave_management_event.dart';
import '../bloc/leave_management_state.dart';
import '../data/model/leave_balance_model.dart';
import '../data/repository/leave_repository.dart';

class LeaveBalanceScreen extends StatefulWidget {
  const LeaveBalanceScreen({super.key});

  @override
  State<LeaveBalanceScreen> createState() => _LeaveBalanceScreenState();
}

class _LeaveBalanceScreenState extends State<LeaveBalanceScreen> {
  final String _selectedYear = '2026';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LeaveManagementBloc(
        leaveRepository: LeaveRepository(),
      )..add(FetchLeaveBalance()),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text('Leave Balance', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          shadowColor: Colors.black12,
        ),
        body: BlocBuilder<LeaveManagementBloc, LeaveManagementState>(
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildProfileHeader(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                if (state.status == LeaveManagementStatus.loading && state.balances.isEmpty)
                  const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
                else if (state.balances.isEmpty)
                  const SliverFillRemaining(child: Center(child: Text('No leave balance found')))
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 24.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final List<Color> colors = [
                            Colors.blue,
                            Colors.red,
                            Colors.orange,
                            Colors.pink,
                            Colors.purple,
                            Colors.grey,
                            Colors.teal,
                            Colors.deepOrange,
                          ];
                          final color = colors[index % colors.length];
                          return _buildQuotaCard(state.balances[index], color);
                        },
                        childCount: state.balances.length,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.indigo.shade50,
            foregroundColor: Colors.indigo.shade700,
            child: const Text('SY', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'System Administrator',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  'Human Resources · LEB-001',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  'Leave balance for $_selectedYear',
                  style: TextStyle(color: Colors.indigo.shade600, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuotaCard(LeaveBalanceModel q, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                      child: Icon(Icons.pie_chart_outline, color: color, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Text(q.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                Row(
                  children: [
                    if (q.carryForward) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(6)),
                        child: Text(
                          'Carry Forward',
                          style: TextStyle(color: Colors.orange.shade700, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: q.isPaid ? Colors.green.shade50 : Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        q.isPaid ? 'Paid' : 'Unpaid',
                        style: TextStyle(color: q.isPaid ? Colors.green.shade700 : Colors.grey.shade700, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${q.remaining}', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 42, color: color, height: 1.0)),
                          const SizedBox(width: 6),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6.0),
                            child: Text('remaining', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey.shade500)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildMiniStat('Allocated', '${q.allocated}', Colors.blue)),
                          Container(width: 1, height: 24, color: Colors.grey.shade200, margin: const EdgeInsets.symmetric(horizontal: 12)),
                          Expanded(child: _buildMiniStat('Used', '${q.used}', Colors.grey.shade700)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Progress bar showing usage percent
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: q.allocated > 0 ? q.used / q.allocated : 0,
                          backgroundColor: Colors.grey.shade100,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String val, Color valColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(val, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: valColor)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

