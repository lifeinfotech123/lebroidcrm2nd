import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/reports_bloc.dart';
import '../bloc/reports_event.dart';
import '../bloc/reports_state.dart';
import '../data/model/payroll_report_model.dart';
import '../widget/report_filter_bar.dart';

class PayrollReportScreen extends StatefulWidget {
  const PayrollReportScreen({super.key});

  @override
  State<PayrollReportScreen> createState() => _PayrollReportScreenState();
}

class _PayrollReportScreenState extends State<PayrollReportScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchReport();
  }

  void _fetchReport() {
    context.read<ReportsBloc>().add(FetchPayrollReport(
      month: DateFormat('yyyy-MM').format(_selectedDate),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6F8),
      appBar: AppBar(
        title: const Text('Payroll Report', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ReportFilterBar(
              selectedDate: _selectedDate,
              onDateSelected: (date) {
                setState(() => _selectedDate = date);
                _fetchReport();
              },
              onFilterPressed: () {},
            ),
          ),
          Expanded(
            child: BlocBuilder<ReportsBloc, ReportsState>(
              builder: (context, state) {
                if (state is ReportsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PayrollReportLoaded) {
                  return RefreshIndicator(
                    onRefresh: () async => _fetchReport(),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          _buildSummaryStrip(state.report.rows),
                          const SizedBox(height: 16),
                          _buildPayrollTable(state.report.rows),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  );
                } else if (state is ReportsError) {
                  return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                }
                return const Center(child: Text('Select month to view report'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStrip(List<PayrollReportRow> rows) {
    final totalNet = rows.fold(0.0, (sum, row) => sum + (double.tryParse(row.netPay ?? '0') ?? 0.0));
    final totalGross = rows.fold(0.0, (sum, row) => sum + (double.tryParse(row.grossPay ?? '0') ?? 0.0));
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo.shade600,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _summaryItem('Net Pay', '₹${NumberFormat('#,##,###').format(totalNet)}', Colors.white),
          Container(width: 1, height: 30, color: Colors.white24),
          _summaryItem('Gross Pay', '₹${NumberFormat('#,##,###').format(totalGross)}', Colors.white70),
          Container(width: 1, height: 30, color: Colors.white24),
          _summaryItem('Employees', '${rows.length}', Colors.white70),
        ],
      ),
    );
  }

  Widget _summaryItem(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: valueColor, fontWeight: FontWeight.bold, fontSize: 15)),
      ],
    );
  }

  Widget _buildPayrollTable(List<PayrollReportRow> rows) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 45,
          horizontalMargin: 16,
          columnSpacing: 20,
          headingRowColor: WidgetStateProperty.all(Colors.grey.shade50),
          columns: const [
            DataColumn(label: Text('Employee', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
            DataColumn(label: Text('Basic', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
            DataColumn(label: Text('Gross', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
            DataColumn(label: Text('Net Pay', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
            DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
          ],
          rows: rows.map((row) => DataRow(cells: [
            DataCell(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(row.name ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
                  Text('${row.branch} • ${row.department}', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                ],
              ),
            ),
            DataCell(Text('₹${row.basic}', style: const TextStyle(fontSize: 12))),
            DataCell(Text('₹${row.grossPay}', style: const TextStyle(fontSize: 12))),
            DataCell(Text('₹${row.netPay}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green))),
            DataCell(
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: row.status?.toLowerCase() == 'paid' ? Colors.green.shade50 : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  row.status ?? 'Pending',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: row.status?.toLowerCase() == 'paid' ? Colors.green : Colors.orange,
                  ),
                ),
              ),
            ),
          ])).toList(),
        ),
      ),
    );
  }
}
