import 'package:flutter/material.dart';

class OvertimeManagementScreen extends StatefulWidget {
  const OvertimeManagementScreen({super.key});

  @override
  State<OvertimeManagementScreen> createState() => _OvertimeManagementScreenState();
}

class _OvertimeManagementScreenState extends State<OvertimeManagementScreen> {
  String _selectedMonth = 'March, 2026';
  String _selectedStatus = 'All Status';
  String _selectedEmployee = 'All Employees';

  final List<String> _months = ['March, 2026', 'February, 2026', 'January, 2026'];
  final List<String> _statuses = ['All Status', 'Approved', 'Pending', 'Rejected'];
  final List<String> _employees = ['All Employees'];

  // Sample overtime records (empty for now — shows empty state)
  final List<Map<String, dynamic>> _records = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6F8),
      appBar: AppBar(
        title: const Text(
          'Overtime Management',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        shadowColor: Colors.black12,
        surfaceTintColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Add Overtime',
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Stat Cards ──────────────────────────────────────
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.65,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStatCard('Approved Hours', '0.0h', Icons.check_circle_outline, Colors.green),
                _buildStatCard('Approved Amount', '₹0.00', Icons.payments_outlined, Colors.blue),
                _buildStatCard('Pending Requests', '0', Icons.pending_actions, Colors.orange),
                _buildStatCard('Pending Amount', '₹0.00', Icons.account_balance_wallet_outlined, Colors.purple),
              ],
            ),

            const SizedBox(height: 20),

            // ── Filters ─────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  _buildDropdown(
                    label: 'Month',
                    value: _selectedMonth,
                    items: _months,
                    icon: Icons.calendar_month_outlined,
                    onChanged: (v) => setState(() => _selectedMonth = v!),
                  ),
                  const SizedBox(height: 10),
                  _buildDropdown(
                    label: 'Status',
                    value: _selectedStatus,
                    items: _statuses,
                    icon: Icons.tune_outlined,
                    onChanged: (v) => setState(() => _selectedStatus = v!),
                  ),
                  const SizedBox(height: 10),
                  _buildDropdown(
                    label: 'Employee',
                    value: _selectedEmployee,
                    items: _employees,
                    icon: Icons.person_outline,
                    onChanged: (v) => setState(() => _selectedEmployee = v!),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Records ─────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Overtime Records',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black87),
                ),
                Text(
                  '${_records.length} records',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                ),
              ],
            ),
            const SizedBox(height: 12),

            _records.isEmpty ? _buildEmptyState() : _buildRecordList(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── Stat Card ────────────────────────────────────────────────
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 3),
                Text(
                  title,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500, height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Dropdown ─────────────────────────────────────────────────
  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 18, color: Colors.grey.shade500),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.indigo, width: 1.5),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14)))).toList(),
      onChanged: onChanged,
      isExpanded: true,
    );
  }

  // ── Empty State ──────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(
        children: [
          Icon(Icons.access_time_outlined, size: 56, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No Overtime Records',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'No overtime records found for the selected filters.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade400, height: 1.5),
          ),
        ],
      ),
    );
  }

  // ── Record List ──────────────────────────────────────────────
  Widget _buildRecordList() {
    return Column(
      children: _records.map((record) => _buildRecordCard(record)).toList(),
    );
  }

  Widget _buildRecordCard(Map<String, dynamic> record) {
    final status = record['status'] as String;
    Color statusColor;
    Color statusBg;
    switch (status.toLowerCase()) {
      case 'approved':
        statusColor = Colors.green.shade700;
        statusBg = Colors.green.shade50;
        break;
      case 'pending':
        statusColor = Colors.orange.shade700;
        statusBg = Colors.orange.shade50;
        break;
      default:
        statusColor = Colors.red.shade700;
        statusBg = Colors.red.shade50;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.indigo.shade50,
                child: Text(
                  (record['employee'] as String)[0],
                  style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(record['employee'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    Text(record['date'] ?? '', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(20)),
                child: Text(status, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoChip(Icons.timer_outlined, '${record['hours']}h'),
              const SizedBox(width: 12),
              _buildInfoChip(Icons.currency_rupee, record['amount'] ?? '0.00'),
              const Spacer(),
              Row(
                children: [
                  _actionIcon(Icons.check_circle_outline, Colors.green, () {}),
                  const SizedBox(width: 8),
                  _actionIcon(Icons.cancel_outlined, Colors.red, () {}),
                ],
              ),
            ],
          ),
          if ((record['reason'] ?? '').isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              record['reason'],
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade500),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _actionIcon(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}
