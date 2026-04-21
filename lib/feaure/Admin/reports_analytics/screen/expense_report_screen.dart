import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/reports_bloc.dart';
import '../bloc/reports_event.dart';
import '../bloc/reports_state.dart';
import '../data/model/expense_report_model.dart';
import '../widget/report_filter_bar.dart';

class ExpenseReportScreen extends StatefulWidget {
  const ExpenseReportScreen({super.key});

  @override
  State<ExpenseReportScreen> createState() => _ExpenseReportScreenState();
}

class _ExpenseReportScreenState extends State<ExpenseReportScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchReport();
  }

  void _fetchReport() {
    context.read<ReportsBloc>().add(FetchExpenseReport(
      month: DateFormat('yyyy-MM').format(_selectedDate),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6F8),
      appBar: AppBar(
        title: const Text('Expense Report', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
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
                } else if (state is ExpenseReportLoaded) {
                  return RefreshIndicator(
                    onRefresh: () async => _fetchReport(),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: state.report.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) => _buildExpenseCard(state.report[i]),
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

  Widget _buildExpenseCard(ExpenseReportModel expense) {
    Color statusColor = Colors.orange;
    if (expense.status?.toLowerCase() == 'approved') statusColor = Colors.green;
    if (expense.status?.toLowerCase() == 'rejected') statusColor = Colors.red;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.indigo.shade50, shape: BoxShape.circle),
                child: const Icon(Icons.receipt_long_outlined, color: Colors.indigo, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(expense.category ?? 'Other', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(expense.name ?? 'Unknown', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
              ),
              Text(
                '₹${expense.amount}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Status', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                  const SizedBox(height: 2),
                  Text(
                    expense.status?.toUpperCase() ?? 'PENDING',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: statusColor),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Date', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                  const SizedBox(height: 2),
                  Text(expense.expenseDate ?? '-', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Purpose: ${expense.purpose ?? "-"}',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          if (expense.policyViolated?.toLowerCase() == 'yes') ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(4)),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.warning_amber_rounded, size: 14, color: Colors.red),
                  SizedBox(width: 4),
                  Text('Policy Violated', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
