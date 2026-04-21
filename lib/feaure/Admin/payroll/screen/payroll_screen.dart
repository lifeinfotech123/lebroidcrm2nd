import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/payroll_bloc.dart';
import '../bloc/payroll_event.dart';
import '../bloc/payroll_state.dart';
import '../data/model/payroll_model.dart';
import 'package:get/get.dart';

class PayrollScreen extends StatefulWidget {
  const PayrollScreen({super.key});

  @override
  State<PayrollScreen> createState() => _PayrollScreenState();
}

class _PayrollScreenState extends State<PayrollScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedMonth = 'April, 2026';
  String _selectedStatus = 'All Status';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    context.read<PayrollBloc>().add(FetchPayrollData(
      month: _selectedMonth,
      status: _selectedStatus == 'All Status' ? null : _selectedStatus,
      search: _searchController.text.trim().isEmpty ? null : _searchController.text.trim(),
    ));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppBar(
        title: const Text('Payroll', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        shadowColor: Colors.black12,
      ),
      body: BlocBuilder<PayrollBloc, PayrollState>(
        builder: (context, state) {
          if (state is PayrollLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PayrollError) {
            return Center(child: Text("Error: ${state.message}", style: const TextStyle(color: Colors.red)));
          }

          if (state is PayrollLoaded) {
            return _buildContent(context, state.summary, state.payrolls);
          }

          return const Center(child: Text('Initializing...'));
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, PayrollSummaryModel summary, List<PayrollModel> payrolls) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsGrid(summary),
                const SizedBox(height: 24),
                _buildFilters(),
                const SizedBox(height: 24),
                Text(
                  '${payrolls.length} Payroll Records',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.grey.shade800),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 24),
          sliver: payrolls.isEmpty
              ? const SliverFillRemaining(
                  child: Center(
                    child: Text('No payroll records found.', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _buildPayrollCard(payrolls[index]);
                    },
                    childCount: payrolls.length,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(PayrollSummaryModel summary) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: [
        _buildStatCard('Total Employees', '${summary.totalRecords}', Icons.people, Colors.blue),
        _buildStatCard('Processed', '${summary.processedCount}', Icons.check_circle_outline, Colors.green),
        _buildStatCard('Total Net Pay', '₹${summary.totalNetPay.toStringAsFixed(2)}', Icons.account_balance_wallet, Colors.orange),
        _buildStatCard('Drafts', '${summary.draftCount}', Icons.drafts_outlined, Colors.red),
      ],
    );
  }

  Widget _buildFilters() {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search employee...',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.indigo)),
          ),
          onSubmitted: (_) => _fetchData(),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                  fillColor: Colors.white,
                  filled: true,
                ),
                isExpanded: true,
                value: _selectedMonth,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13, fontWeight: FontWeight.w500),
                icon: const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey),
                items: ['February, 2026', 'March, 2026', 'April, 2026', 'May, 2026']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) {
                    setState(() => _selectedMonth = v);
                    _fetchData();
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                  fillColor: Colors.white,
                  filled: true,
                ),
                isExpanded: true,
                value: _selectedStatus,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13, fontWeight: FontWeight.w500),
                icon: const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey),
                items: ['All Status', 'processed', 'draft', 'paid', 'approved']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e.capitalizeFirst!)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) {
                    setState(() => _selectedStatus = v);
                    _fetchData();
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 45,
          child: ElevatedButton.icon(
            onPressed: _fetchData, 
            icon: const Icon(Icons.filter_list, size: 18), 
            label: const Text('Apply Filter', style: TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPayrollCard(PayrollModel payroll) {
    Color statusColor;
    if (payroll.status == 'processed' || payroll.status == 'paid') {
      statusColor = Colors.green;
    } else if (payroll.status == 'draft') {
      statusColor = Colors.orange;
    } else {
      statusColor = Colors.blue;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.indigo.shade50,
                  child: Text(
                    payroll.employeeName.isNotEmpty ? payroll.employeeName[0].toUpperCase() : '?', 
                    style: TextStyle(color: Colors.indigo.shade700, fontWeight: FontWeight.bold, fontSize: 16)
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(payroll.employeeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 2),
                      Text('ID: ${payroll.userId} • ${payroll.month}', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                        child: Text(payroll.status.capitalizeFirst!, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Net Pay', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
                    Text('₹${payroll.netPay.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.green)),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: Row(
              children: [
                Expanded(child: _buildMetricCol('Present', '${payroll.presentDays}', 'Days')),
                Container(width: 1, height: 24, color: Colors.grey.shade300),
                Expanded(child: _buildMetricCol('Gross', '₹${payroll.grossPay.toStringAsFixed(0)}', '')),
                Container(width: 1, height: 24, color: Colors.grey.shade300),
                Expanded(child: _buildMetricCol('Deducted', '₹${payroll.totalDeductions.toStringAsFixed(0)}', '', color: Colors.red.shade700)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCol(String label, String value, String suffix, {Color? color}) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color ?? Colors.black87)),
              if (suffix.isNotEmpty) TextSpan(text: ' $suffix', style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 18),
              ),
            ],
          ),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          Text(title, style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
