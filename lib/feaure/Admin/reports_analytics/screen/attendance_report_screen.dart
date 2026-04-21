import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/reports_bloc.dart';
import '../bloc/reports_event.dart';
import '../bloc/reports_state.dart';
import '../data/model/attendance_report_model.dart';
import '../widget/report_filter_bar.dart';

class AttendanceReportScreen extends StatefulWidget {
  const AttendanceReportScreen({super.key});

  @override
  State<AttendanceReportScreen> createState() => _AttendanceReportScreenState();
}

class _AttendanceReportScreenState extends State<AttendanceReportScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchReport();
  }

  void _fetchReport() {
    context.read<ReportsBloc>().add(FetchAttendanceReport(
      month: DateFormat('yyyy-MM').format(_selectedDate),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6F8),
      appBar: AppBar(
        title: const Text('Attendance Report', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17)),
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
              onFilterPressed: () {
                // TODO: Show Advanced Filters (Branch/Dept)
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<ReportsBloc, ReportsState>(
              builder: (context, state) {
                if (state is ReportsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AttendanceReportLoaded) {
                  final report = state.report;
                  return RefreshIndicator(
                    onRefresh: () async => _fetchReport(),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          _buildStatsOverview(report.stats),
                          const SizedBox(height: 16),
                          _buildAttendanceTable(report.rows),
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

  Widget _buildStatsOverview(AttendanceReportStats stats) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.2,
      children: [
        _statCard('Avg Attendance', '${stats.avgPct}%', Icons.percent, Colors.blue),
        _statCard('Total Present', '${stats.totalPresent}', Icons.person_add_alt_1_outlined, Colors.green),
        _statCard('Total Late', '${stats.totalLate}', Icons.access_time, Colors.orange),
        _statCard('Below 80%', '${stats.below80pct}', Icons.warning_amber_outlined, Colors.red),
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
                Text(title, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceTable(List<AttendanceReportRow> rows) {
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
          headingRowColor: WidgetStateProperty.all(Colors.indigo.shade50),
          columns: const [
            DataColumn(label: Text('Employee', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
            DataColumn(label: Text('Branch/Dept', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
            DataColumn(label: Text('Present', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
            DataColumn(label: Text('Late', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
            DataColumn(label: Text('Total Hrs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
            DataColumn(label: Text('Score %', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
          ],
          rows: rows.map((row) => DataRow(cells: [
            DataCell(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(row.name ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
                  Text(row.employeeId ?? '-', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                ],
              ),
            ),
            DataCell(Text('${row.branch}\n${row.department}', style: const TextStyle(fontSize: 11))),
            DataCell(Text('${row.present}/${row.workingDays}', style: const TextStyle(fontSize: 12))),
            DataCell(Text('${row.late}', style: const TextStyle(fontSize: 12, color: Colors.orange))),
            DataCell(Text('${row.totalHrs}h', style: const TextStyle(fontSize: 12))),
            DataCell(
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: (row.attendancePct ?? 0) >= 80 ? Colors.green.shade50 : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${row.attendancePct}%',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: (row.attendancePct ?? 0) >= 80 ? Colors.green : Colors.red,
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
