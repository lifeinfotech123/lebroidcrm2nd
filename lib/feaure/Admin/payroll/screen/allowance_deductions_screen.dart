import 'package:flutter/material.dart';

class AllowanceDeductionsScreen extends StatelessWidget {
  const AllowanceDeductionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xffF4F6F8),
        appBar: AppBar(
          title: const Text(
            'Allowance & Deductions',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 0,
          surfaceTintColor: Colors.white,
          bottom: TabBar(
            labelColor: Colors.indigo,
            unselectedLabelColor: Colors.grey.shade500,
            indicatorColor: Colors.indigo,
            indicatorWeight: 2.5,
            labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            tabs: const [
              Tab(text: 'Allowances'),
              Tab(text: 'Deductions'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            AllowanceTab(),
            DeductionTab(),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// ALLOWANCE TAB
// ─────────────────────────────────────────────────────────────
class AllowanceTab extends StatefulWidget {
  const AllowanceTab({super.key});

  @override
  State<AllowanceTab> createState() => _AllowanceTabState();
}

class _AllowanceTabState extends State<AllowanceTab> {
  String _month = 'March, 2026';
  String _status = 'All Status';
  String _employee = 'All Employees';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Stat Grid ───────────────────────────────────────
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.65,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _statCard('Total Allowances', '₹0.00', Icons.check_circle_outline, Colors.green),
              _statCard('Approved Amount', '₹0.00', Icons.payments_outlined, Colors.blue),
              _statCard('Pending Requests', '0', Icons.pending_actions, Colors.orange),
              _statCard('Pending Amount', '₹0.00', Icons.account_balance_wallet_outlined, Colors.purple),
            ],
          ),

          const SizedBox(height: 20),

          // ── Filters ─────────────────────────────────────────
          _filtersCard(),

          const SizedBox(height: 20),

          // ── Header ──────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Allowance Records',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black87)),
              Text('0 records', style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
            ],
          ),
          const SizedBox(height: 12),

          // ── Empty State ──────────────────────────────────────
          _emptyState('No allowances found.', Icons.monetization_on_outlined),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _filtersCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Filters',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87)),
          const SizedBox(height: 12),
          _dropdown('Month', _month, ['March, 2026', 'February, 2026'],
              Icons.calendar_month_outlined, (v) => setState(() => _month = v!)),
          const SizedBox(height: 10),
          _dropdown('Status', _status, ['All Status', 'Approved', 'Pending'],
              Icons.tune_outlined, (v) => setState(() => _status = v!)),
          const SizedBox(height: 10),
          _dropdown('Employee', _employee, ['All Employees'],
              Icons.person_outline, (v) => setState(() => _employee = v!)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// DEDUCTION TAB
// ─────────────────────────────────────────────────────────────
class DeductionTab extends StatefulWidget {
  const DeductionTab({super.key});

  @override
  State<DeductionTab> createState() => _DeductionTabState();
}

class _DeductionTabState extends State<DeductionTab> {
  String _employee = 'All Employees';
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _deductionTypes = [
    {'title': 'Absent Deduction (LOP)', 'code': 'LOP', 'type': 'Per day', 'amount': '₹0', 'mandatory': false},
    {'title': 'Advance Salary Recovery', 'code': 'ADVANCE', 'type': 'Fixed', 'amount': '₹0', 'mandatory': false},
    {'title': 'Employee State Insurance', 'code': 'ESI', 'type': 'Percentage', 'amount': '0.75%', 'mandatory': true},
    {'title': 'Late Fine', 'code': 'LATE', 'type': 'Per late', 'amount': '₹100', 'mandatory': false},
    {'title': 'Loan EMI', 'code': 'LOAN', 'type': 'Fixed', 'amount': '₹0', 'mandatory': false},
    {'title': 'Penalty', 'code': 'PEN', 'type': 'Fixed', 'amount': '₹0', 'mandatory': false},
    {'title': 'Professional Tax', 'code': 'PT', 'type': 'Fixed', 'amount': '₹200', 'mandatory': true},
    {'title': 'Provident Fund', 'code': 'PF', 'type': 'Percentage', 'amount': '12.00%', 'mandatory': true},
    {'title': 'Tax Deducted at Source', 'code': 'TDS', 'type': 'Percentage', 'amount': '0.00%', 'mandatory': true},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Deduction Type Cards ─────────────────────────────
          const Text('Deduction Types',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
          const SizedBox(height: 12),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _deductionTypes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) => _deductionCard(_deductionTypes[i]),
          ),

          const SizedBox(height: 20),

          // ── Search + Filter ──────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Filters',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87)),
                const SizedBox(height: 12),
                TextField(
                  controller: _searchCtrl,
                  decoration: InputDecoration(
                    hintText: 'Search employee...',
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    prefixIcon: Icon(Icons.search, size: 18, color: Colors.grey.shade500),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.indigo, width: 1.5)),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                  ),
                ),
                const SizedBox(height: 10),
                _dropdown('Employee', _employee, ['All Employees'],
                    Icons.person_outline, (v) => setState(() => _employee = v!)),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Assigned Deductions ──────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Assigned Deductions',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.black87)),
              Text('0 records', style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
            ],
          ),
          const SizedBox(height: 12),

          _emptyState('No deductions assigned yet.', Icons.remove_circle_outline),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _deductionCard(Map<String, dynamic> d) {
    final bool mandatory = d['mandatory'] as bool;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Code badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              d['code'],
              style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.bold, color: Colors.indigo.shade700),
            ),
          ),
          const SizedBox(width: 12),
          // Title + type
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(d['title'],
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87)),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(d['type'],
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                    if (mandatory) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(4)),
                        child: Text('Mandatory',
                            style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade600)),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          // Amount
          Text(
            d['amount'],
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15, color: Colors.indigo),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// SHARED HELPERS
// ─────────────────────────────────────────────────────────────
Widget _statCard(String title, String value, IconData icon, Color color) {
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
          decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value,
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 3),
              Text(title,
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500, height: 1.3)),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _dropdown(
  String label,
  String value,
  List<String> items,
  IconData icon,
  ValueChanged<String?> onChanged,
) {
  return DropdownButtonFormField<String>(
    value: value,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 18, color: Colors.grey.shade500),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.indigo, width: 1.5)),
      filled: true,
      fillColor: Colors.grey.shade50,
    ),
    items: items
        .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14))))
        .toList(),
    onChanged: onChanged,
    isExpanded: true,
  );
}

Widget _emptyState(String message, IconData icon) {
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
        Icon(icon, size: 56, color: Colors.grey.shade300),
        const SizedBox(height: 16),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 6),
        Text(
          'Try adjusting your filters.',
          style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
        ),
      ],
    ),
  );
}
