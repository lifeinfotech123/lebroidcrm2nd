import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/reports_bloc.dart';
import '../bloc/reports_event.dart';
import '../bloc/reports_state.dart';
import '../data/model/performance_report_model.dart';
import '../widget/report_filter_bar.dart';

class PerformanceReportScreen extends StatefulWidget {
  const PerformanceReportScreen({super.key});

  @override
  State<PerformanceReportScreen> createState() => _PerformanceReportScreenState();
}

class _PerformanceReportScreenState extends State<PerformanceReportScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchReport();
  }

  void _fetchReport() {
    context.read<ReportsBloc>().add(FetchPerformanceReport(
      month: DateFormat('yyyy-MM').format(_selectedDate),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6F8),
      appBar: AppBar(
        title: const Text('Performance Report', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
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
                } else if (state is PerformanceReportLoaded) {
                  return RefreshIndicator(
                    onRefresh: () async => _fetchReport(),
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: state.report.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) => _buildPerformanceCard(state.report[i]),
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

  Widget _buildPerformanceCard(PerformanceReportModel p) {
    final double avgScore = (
      (p.attendanceScore ?? 0) + 
      (p.taskScore ?? 0) + 
      (p.punctuality ?? 0) + 
      (p.teamwork ?? 0)
    ) / 4.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.indigo.shade50,
                child: const Icon(Icons.person_outline, color: Colors.indigo, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.name ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(p.department ?? '-', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(avgScore.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.indigo)),
                  const Text('AVG SCORE', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _scoreWidget('Attendance', p.attendanceScore ?? 0, Colors.blue),
              _scoreWidget('Tasks', p.taskScore ?? 0, Colors.green),
              _scoreWidget('Punctuality', p.punctuality ?? 0, Colors.orange),
              _scoreWidget('Teamwork', p.teamwork ?? 0, Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _scoreWidget(String label, int score, Color color) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                value: score / 10.0,
                backgroundColor: color.withOpacity(0.1),
                color: color,
                strokeWidth: 4,
              ),
            ),
            Text('$score', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: color)),
          ],
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 9, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
