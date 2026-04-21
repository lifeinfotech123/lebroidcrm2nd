import 'package:flutter/material.dart';

class LeaveApprovalItem {
  final String initials;
  final String name;
  final String department;
  final String leaveType;
  final String durationText;
  final String dateRange;
  final int days;
  final String reason;
  final bool hasDocument;

  LeaveApprovalItem({
    required this.initials,
    required this.name,
    required this.department,
    required this.leaveType,
    required this.durationText,
    required this.dateRange,
    required this.days,
    required this.reason,
    required this.hasDocument,
  });
}

class LeaveApprovalsScreen extends StatefulWidget {
  const LeaveApprovalsScreen({super.key});

  @override
  State<LeaveApprovalsScreen> createState() => _LeaveApprovalsScreenState();
}

class _LeaveApprovalsScreenState extends State<LeaveApprovalsScreen> {
  final List<LeaveApprovalItem> _pendingApprovals = [
    LeaveApprovalItem(
      initials: 'AM',
      name: 'Amit Kumar',
      department: 'Information Technology',
      leaveType: 'Annual Leave',
      durationText: 'Paid',
      dateRange: '24 Mar 2026 - 26 Mar 2026',
      days: 3,
      reason: 'Vacation trip to Goa with family',
      hasDocument: false,
    ),
    LeaveApprovalItem(
      initials: 'KA',
      name: 'Kavita Patel',
      department: 'Sales & Marketing',
      leaveType: 'Annual Leave',
      durationText: 'Paid',
      dateRange: '24 Mar 2026 - 26 Mar 2026',
      days: 3,
      reason: 'Vacation trip to Goa with family',
      hasDocument: false,
    ),
    LeaveApprovalItem(
      initials: 'AM',
      name: 'Amit Kumar',
      department: 'Information Technology',
      leaveType: 'Casual Leave',
      durationText: 'Paid',
      dateRange: '29 Mar 2026 - 29 Mar 2026',
      days: 1,
      reason: 'Personal work at bank',
      hasDocument: false,
    ),
    LeaveApprovalItem(
      initials: 'KA',
      name: 'Kavita Patel',
      department: 'Sales & Marketing',
      leaveType: 'Casual Leave',
      durationText: 'Paid',
      dateRange: '29 Mar 2026 - 29 Mar 2026',
      days: 1,
      reason: 'Personal work at bank',
      hasDocument: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Leave Approvals', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        shadowColor: Colors.black12,
        actions: [
          IconButton(icon: const Icon(Icons.filter_list_outlined), onPressed: () {}),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Pending Queue: ',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                      children: [
                        TextSpan(
                          text: '${_pendingApprovals.length} Requests',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.access_time_filled, size: 14, color: Colors.orange.shade600),
                        const SizedBox(width: 4),
                        Text('Requires Action', style: TextStyle(color: Colors.orange.shade700, fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 24.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildApprovalCard(_pendingApprovals[index]);
                },
                childCount: _pendingApprovals.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalCard(LeaveApprovalItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
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
                  child: Text(item.initials, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.business_center_outlined, size: 12, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              item.department,
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
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
                    Row(
                      children: [
                        Text(item.leaveType, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: Colors.indigo.shade50, borderRadius: BorderRadius.circular(4)),
                          child: Text(item.durationText, style: TextStyle(color: Colors.indigo.shade700, fontSize: 9, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    Text('${item.days} Day(s)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.indigo.shade600)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 6),
                    Text(item.dateRange, style: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.w500)),
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
                      Text('Reason for Leave', style: TextStyle(color: Colors.grey.shade500, fontSize: 10, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(item.reason, style: TextStyle(color: Colors.black87, fontSize: 13, height: 1.4)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.attachment_outlined, size: 14, color: Colors.grey.shade500),
                    const SizedBox(width: 6),
                    Text(
                      'Document: ',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                    Text(
                      item.hasDocument ? 'Attached File' : 'None',
                      style: TextStyle(
                        color: item.hasDocument ? Colors.indigo.shade600 : Colors.grey.shade400,
                        fontSize: 12,
                        fontWeight: item.hasDocument ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.close, size: 16, color: Colors.red.shade600),
                    label: const Text('Reject', style: TextStyle(fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red.shade600,
                      side: BorderSide(color: Colors.red.shade200),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Approve', style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
