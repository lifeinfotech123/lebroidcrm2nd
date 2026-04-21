import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/leave_management_bloc.dart';
import '../bloc/leave_management_event.dart';
import '../bloc/leave_management_state.dart';
import '../data/model/leave_model.dart';
import '../data/repository/leave_repository.dart';

class LeaveRequestsScreen extends StatefulWidget {
  const LeaveRequestsScreen({super.key});

  @override
  State<LeaveRequestsScreen> createState() => _LeaveRequestsScreenState();
}

class _LeaveRequestsScreenState extends State<LeaveRequestsScreen> {
  String _selectedStatus = 'All Status';
  String _selectedYear = '2026';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LeaveManagementBloc(
        leaveRepository: LeaveRepository(),
      )..add(FetchLeaveRequests(status: _selectedStatus, year: int.tryParse(_selectedYear))),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text('Leave Requests', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          shadowColor: Colors.black12,
        ),
        body: BlocConsumer<LeaveManagementBloc, LeaveManagementState>(
          listener: (context, state) {
            if (state.status == LeaveManagementStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage ?? 'An error occurred')),
              );
            }
          },
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildStatsGrid(state.leaves),
                        const SizedBox(height: 16),
                        _buildSearchAndFilters(context),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                if (state.status == LeaveManagementStatus.loading && state.leaves.isEmpty)
                  const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
                else if (state.leaves.isEmpty)
                  const SliverFillRemaining(child: Center(child: Text('No leave requests found')))
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 24.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return _buildRequestCard(context, state.leaves[index]);
                        },
                        childCount: state.leaves.length,
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

  Widget _buildStatsGrid(List<LeaveModel> leaves) {
    int total = leaves.length;
    int pending = leaves.where((l) => l.status?.toLowerCase() == 'pending').length;
    int approved = leaves.where((l) => l.status?.toLowerCase() == 'approved').length;
    int rejected = leaves.where((l) => l.status?.toLowerCase() == 'rejected' || l.status?.toLowerCase() == 'cancelled').length;

    return Row(
      children: [
        Expanded(child: _buildSmallStatCard('Total', '$total', Colors.blue, Icons.list_alt_outlined)),
        const SizedBox(width: 8),
        Expanded(child: _buildSmallStatCard('Pending', '$pending', Colors.orange, Icons.access_time_outlined)),
        const SizedBox(width: 8),
        Expanded(child: _buildSmallStatCard('Approved', '$approved', Colors.green, Icons.check_circle_outline)),
        const SizedBox(width: 8),
        Expanded(child: _buildSmallStatCard('Rejected', '$rejected', Colors.red, Icons.cancel_outlined)),
      ],
    );
  }

  Widget _buildSmallStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(title, style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildFilterDropdown(
                value: _selectedStatus,
                items: ['All Status', 'Pending', 'Approved', 'Rejected'],
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedStatus = val);
                    context.read<LeaveManagementBloc>().add(FetchLeaveRequests(status: _selectedStatus, year: int.tryParse(_selectedYear)));
                  }
                },
                icon: Icons.filter_list,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildFilterDropdown(
                value: _selectedYear,
                items: ['2026', '2025', '2024'],
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedYear = val);
                    context.read<LeaveManagementBloc>().add(FetchLeaveRequests(status: _selectedStatus, year: int.tryParse(_selectedYear)));
                  }
                },
                icon: Icons.calendar_today_outlined,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterDropdown({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.indigo),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Icon(icon, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 6),
                  Text(value, style: const TextStyle(fontSize: 12)),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildRequestCard(BuildContext context, LeaveModel req) {
    bool isPending = req.status?.toLowerCase() == 'pending';
    bool isApproved = req.status?.toLowerCase() == 'approved';

    Color statusColor = Colors.grey;
    if (isPending) statusColor = Colors.orange;
    if (isApproved) statusColor = Colors.green;
    if (req.status?.toLowerCase() == 'rejected' || req.status?.toLowerCase() == 'cancelled') statusColor = Colors.red;

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.indigo.shade50,
                  foregroundColor: Colors.indigo.shade700,
                  child: Text(req.user?.name?.substring(0, 1) ?? '?', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(req.user?.name ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)),
                        child: Text(req.user?.employeeId ?? 'N/A', style: TextStyle(color: Colors.grey.shade700, fontSize: 10, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    (req.status ?? 'UNKNOWN').toUpperCase(),
                    style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Leave ID: #${req.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('${req.totalDays} Day(s)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey.shade700)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 6),
                    Text(
                      '${req.fromDate?.toIso8601String().substring(0, 10)} to ${req.toDate?.toIso8601String().substring(0, 10)}',
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Reason', style: TextStyle(color: Colors.grey.shade500, fontSize: 10, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(req.reason ?? '', style: const TextStyle(color: Colors.black87, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isPending) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _onReject(context, req),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: BorderSide(color: Colors.red.shade200),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Reject', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _onApprove(context, req),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Approve', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _onApprove(BuildContext context, LeaveModel leave) {
    final remarksController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Approve Leave'),
        content: TextField(
          controller: remarksController,
          decoration: const InputDecoration(labelText: 'Remarks', hintText: 'Enter approval remarks...'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              context.read<LeaveManagementBloc>().add(ApproveLeaveRequest(leave.id!, remarksController.text));
              Navigator.pop(dialogContext);
            },
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  void _onReject(BuildContext context, LeaveModel leave) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reject Leave'),
        content: const Text('Are you sure you want to reject/cancel this leave request?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('No')),
          TextButton(
            onPressed: () {
              context.read<LeaveManagementBloc>().add(CancelLeaveRequest(leave.id!));
              Navigator.pop(dialogContext);
            },
            child: const Text('Yes, Reject', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
