import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/employee_attendance/employee_attendance_bloc.dart';
import '../bloc/employee_attendance/employee_attendance_event.dart';
import '../bloc/employee_attendance/employee_attendance_state.dart';
import '../data/model/attendance_model.dart';
import '../data/model/attendance_summary_model.dart';
import '../data/repository/employee_attendance_repository.dart';

class EmployeeSummaryModel {
  final String avatarInitial;
  final String name;
  final String empCode;
  final String department;
  final int workingDays;
  final int present;
  final int absent;
  final int late;
  final int onLeave;
  final String avgHrs;
  final String attendancePercentage;

  EmployeeSummaryModel({
    required this.avatarInitial,
    required this.name,
    required this.empCode,
    required this.department,
    required this.workingDays,
    required this.present,
    required this.absent,
    required this.late,
    required this.onLeave,
    required this.avgHrs,
    required this.attendancePercentage,
  });
}

class AttendanceSummaryScreen extends StatefulWidget {
  const AttendanceSummaryScreen({super.key});

  @override
  State<AttendanceSummaryScreen> createState() => _AttendanceSummaryScreenState();
}

class _AttendanceSummaryScreenState extends State<AttendanceSummaryScreen> {
  String _selectedMonth = 'March, 2026';
  String _selectedDepartment = 'All Departments';
  String _selectedEmployee = 'All Employees';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EmployeeAttendanceBloc(repository: EmployeeAttendanceRepository())..add(FetchEmployeeAttendances()),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const Text('Attendance Summary', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 1,
          shadowColor: Colors.black12,
          actions: [
            IconButton(icon: const Icon(Icons.download_outlined), onPressed: () {}),
          ],
        ),
        body: BlocBuilder<EmployeeAttendanceBloc, EmployeeAttendanceState>(
          builder: (context, state) {
            if (state is EmployeeAttendanceLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EmployeeAttendanceError) {
              return Center(child: Text('Error: ${state.message}', style: const TextStyle(color: Colors.red)));
            } else if (state is EmployeeAttendanceLoaded) {
              final summary = state.summary;
              final attendances = state.attendances;

              // Aggregate records by employee for the breakdown
              final Map<String, List<AttendanceModel>> grouped = {};
              for (var record in attendances) {
                final userId = record.userId ?? 'unknown';
                if (!grouped.containsKey(userId)) grouped[userId] = [];
                grouped[userId]!.add(record);
              }

              final List<EmployeeSummaryModel> summaries = grouped.values.map((recs) {
                final first = recs.first;
                final name = first.user?.name ?? 'Unknown';
                final empId = first.user?.empId ?? '—';
                
                int p = 0, a = 0, l = 0, lv = 0;
                double totalHrs = 0;
                
                for (var r in recs) {
                  final status = r.status?.toLowerCase() ?? '';
                  if (status == 'present') p++;
                  else if (status == 'absent') a++;
                  else if (status == 'late') l++;
                  else if (status == 'leave') lv++;
                  
                  if (r.workingMinutes != null) totalHrs += r.workingMinutes! / 60;
                }
                
                final totalDays = p + a + l;
                final pct = totalDays > 0 ? (p + l) / totalDays * 100 : 0.0;
                final avg = recs.length > 0 ? totalHrs / recs.length : 0.0;

                return EmployeeSummaryModel(
                  avatarInitial: name.isNotEmpty ? name[0].toUpperCase() : '?',
                  name: name,
                  empCode: empId,
                  department: first.branchId ?? 'N/A', // Using branch as placeholder for dept if not in model
                  workingDays: totalDays,
                  present: p,
                  absent: a,
                  late: l,
                  onLeave: lv,
                  avgHrs: '${avg.toStringAsFixed(1)}h',
                  attendancePercentage: '${pct.toStringAsFixed(1)}%',
                );
              }).toList();

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<EmployeeAttendanceBloc>().add(FetchEmployeeAttendances());
                },
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Overview', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 12),
                            _buildStatsGrid(summary),
                            const SizedBox(height: 24),
                            const Text('Employee Breakdown', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 24.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return _buildEmployeeCard(summaries[index]);
                          },
                          childCount: summaries.length,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildStatsGrid(AttendanceSummaryModel summary) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildStatCard('Present Days', (summary.present ?? 0).toString(), Colors.green, Icons.check_circle_outline),
        _buildStatCard('Absent Days', (summary.absent ?? 0).toString(), Colors.red, Icons.cancel_outlined),
        _buildStatCard('Late Arrivals', (summary.late ?? 0).toString(), Colors.orange, Icons.timer_outlined),
        _buildStatCard('On Leave', (summary.onLeave ?? 0).toString(), Colors.purple, Icons.beach_access_outlined),
        _buildStatCard('Avg Working Hours', '${summary.avgWorkingHrs ?? 0}h', Colors.blue, Icons.av_timer_outlined),
        _buildStatCard('Half Days', (summary.halfDay ?? 0).toString(), Colors.teal, Icons.wb_sunny_outlined),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(title, style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeCard(EmployeeSummaryModel employee) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.indigo.shade50,
                  foregroundColor: Colors.indigo.shade700,
                  child: Text(employee.avatarInitial, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(employee.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(employee.empCode, style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.w600)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6.0),
                            child: Icon(Icons.circle, size: 4, color: Colors.grey.shade400),
                          ),
                          Expanded(
                            child: Text(
                              employee.department,
                              style: TextStyle(color: Colors.grey[500], fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const Text('Attendance', style: TextStyle(fontSize: 10, color: Colors.indigo)),
                      const SizedBox(height: 2),
                      Text(
                        employee.attendancePercentage,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.indigo),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 14.0),
              child: Divider(height: 1),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMiniStat('WD', employee.workingDays.toString(), Colors.blueGrey),
                _buildMiniStat('P', employee.present.toString(), Colors.green),
                _buildMiniStat('A', employee.absent.toString(), Colors.red),
                _buildMiniStat('L', employee.late.toString(), Colors.orange),
                _buildMiniStat('Lv', employee.onLeave.toString(), Colors.purple),
                _buildMiniStat('Avg', employee.avgHrs, Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, MaterialColor color) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.shade50,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            value,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: color.shade800),
          ),
        ),
      ],
    );
  }
}
