import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/reports_bloc.dart';
import '../bloc/reports_event.dart';
import '../bloc/reports_state.dart';
import '../data/model/task_report_model.dart';
import '../widget/report_filter_bar.dart';

class TaskReportScreen extends StatefulWidget {
  const TaskReportScreen({super.key});

  @override
  State<TaskReportScreen> createState() => _TaskReportScreenState();
}

class _TaskReportScreenState extends State<TaskReportScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchReport();
  }

  void _fetchReport() {
    context.read<ReportsBloc>().add(FetchTaskReport(
      month: DateFormat('yyyy-MM').format(_selectedDate),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6F8),
      appBar: AppBar(
        title: const Text('Task Report', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
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
                } else if (state is TaskReportLoaded) {
                  return RefreshIndicator(
                    onRefresh: () async => _fetchReport(),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: state.report.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) => _buildTaskCard(state.report[i]),
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

  Widget _buildTaskCard(TaskReportModel task) {
    Color priorityColor = Colors.grey;
    if (task.priority?.toLowerCase() == 'high') priorityColor = Colors.red;
    if (task.priority?.toLowerCase() == 'medium') priorityColor = Colors.orange;
    if (task.priority?.toLowerCase() == 'low') priorityColor = Colors.green;

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
              Expanded(
                child: Text(
                  task.title ?? 'Untitled Task',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: priorityColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                child: Text(
                  task.priority?.toUpperCase() ?? 'NONE',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: priorityColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Assigned to: ${task.assignedTo}',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoTile('Status', task.status ?? '-'),
              _infoTile('Deadline', task.deadline ?? '-'),
              _infoTile('Overdue', task.isOverdue ?? 'No'),
            ],
          ),
          if (task.isOverdue?.toLowerCase() == 'yes') ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, size: 14, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Mission Critical: This task has passed its deadline.', style: TextStyle(fontSize: 11, color: Colors.red, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
