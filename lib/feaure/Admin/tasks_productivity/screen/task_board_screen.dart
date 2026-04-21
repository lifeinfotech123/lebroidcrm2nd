import 'package:flutter/material.dart';
class TaskBoardItem {
  final String id;
  final String title;
  final String initials;
  final String assignee;
  final String date;
  final String priority;

  TaskBoardItem({
    required this.id,
    required this.title,
    required this.initials,
    required this.assignee,
    required this.date,
    required this.priority,
  });
}
class TaskBoardScreen extends StatelessWidget {
   TaskBoardScreen({super.key});

  final Map<String, List<TaskBoardItem>> _boardData = {
    'Pending': [
      TaskBoardItem(id: '1', title: 'Prepare Monthly Payroll Report', initials: 'KA', assignee: 'Kavita Patel', date: '22 Mar', priority: 'High'),
      TaskBoardItem(id: '5', title: 'Conduct Branch Performance Review', initials: 'RA', assignee: 'Ravi Gupta', date: '02 Apr', priority: 'Medium'),
    ],
    'In Progress': [
      TaskBoardItem(id: '3', title: 'Update Employee Handbook Q1 2025', initials: 'AM', assignee: 'Amit Kumar', date: '26 Mar', priority: 'High'),
    ],
    'Awaiting Approval': [
      TaskBoardItem(id: '2', title: 'System Maintenance & Security Audit', initials: 'NE', assignee: 'Neha Singh', date: '24 Mar', priority: 'High'),
      TaskBoardItem(id: '4', title: 'Client Proposal for Medical Equipment', initials: 'SU', assignee: 'Suresh Nair', date: '29 Mar', priority: 'Medium'),
    ],
    'On Hold': [],
    'Approved': [],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Task Management', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        shadowColor: Colors.black12,
        actions: [
          IconButton(icon: const Icon(Icons.add_task), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildStatsScroll(),
                const SizedBox(height: 16),
                _buildSearchAndFilters(),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(16),
              children: [
                _buildBoardColumn('Pending', Icons.radio_button_unchecked, Colors.grey.shade600),
                const SizedBox(width: 16),
                _buildBoardColumn('In Progress', Icons.play_circle_outline, Colors.blue.shade600),
                const SizedBox(width: 16),
                _buildBoardColumn('Awaiting Approval', Icons.access_time, Colors.orange.shade600),
                const SizedBox(width: 16),
                _buildBoardColumn('On Hold', Icons.pause_circle_outline, Colors.red.shade500),
                const SizedBox(width: 16),
                _buildBoardColumn('Approved', Icons.check_circle_outline, Colors.green.shade600),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsScroll() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildStatPill('Total', '5', Colors.blue),
          _buildStatPill('Pending', '2', Colors.grey),
          _buildStatPill('In Progress', '1', Colors.indigo),
          _buildStatPill('Awaiting Approval', '2', Colors.orange),
          _buildStatPill('Overdue', '0', Colors.red),
        ],
      ),
    );
  }

  Widget _buildStatPill(String title, String value, MaterialColor color) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.shade200),
      ),
      child: Row(
        children: [
          Text(title, style: TextStyle(color: color.shade700, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Text(value, style: TextStyle(color: color.shade700, fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search tasks...',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
              prefixIcon: Icon(Icons.search, color: Colors.grey.shade400, size: 20),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.filter_list),
          style: IconButton.styleFrom(backgroundColor: Colors.grey.shade100, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        ),
      ],
    );
  }

  Widget _buildBoardColumn(String status, IconData icon, Color color) {
    List<TaskBoardItem> items = _boardData[status] ?? [];
    return SizedBox(
      width: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.shade200)),
            child: Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 8),
                Expanded(child: Text(status, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey.shade800))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(4)),
                  child: Text('${items.length}', style: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: items.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 32, color: Colors.grey.shade300),
                  const SizedBox(height: 8),
                  Text('No tasks', style: TextStyle(color: Colors.grey.shade400, fontSize: 13, fontWeight: FontWeight.w500)),
                ],
              ),
            )
                : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return _buildTaskCard(items[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(TaskBoardItem item) {
    Color priorityColor = item.priority == 'High' ? Colors.red : (item.priority == 'Medium' ? Colors.orange : Colors.green);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87, height: 1.3),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: Colors.indigo.shade50,
                child: Text(item.initials, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.indigo.shade700)),
              ),
              const SizedBox(width: 8),
              Text(item.assignee, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Text(item.date, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                  const SizedBox(width: 8),
                  Container(
                    width: 8, height: 8,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: priorityColor),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.arrow_forward_rounded, size: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
