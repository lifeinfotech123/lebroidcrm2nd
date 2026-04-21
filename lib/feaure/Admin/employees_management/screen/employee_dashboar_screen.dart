import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../admin_dashboard/presentation/widget/admin_dashboard_drawer.dart';
import '../../attendance_management/bloc/employee_attendance/employee_attendance_bloc.dart';
import '../../attendance_management/bloc/employee_attendance/employee_attendance_event.dart';
import '../../attendance_management/bloc/employee_attendance/employee_attendance_state.dart';
import '../../attendance_management/data/repository/employee_attendance_repository.dart';
import '../../attendance_management/data/model/attendance_summary_model.dart';
import '../../tasks_productivity/bloc/task_bloc.dart';
import '../../tasks_productivity/bloc/task_event.dart';
import '../../tasks_productivity/bloc/task_state.dart';
import '../../tasks_productivity/data/model/task_model.dart';
import '../../performance_management/bloc/performance_bloc.dart';
import '../../performance_management/bloc/performance_event.dart';
import '../../performance_management/bloc/performance_state.dart';
import '../../expense_management/bloc/expense_bloc.dart';
import '../../expense_management/bloc/expense_event.dart';
import '../../expense_management/bloc/expense_state.dart';
import '../../payroll/bloc/salary_bloc.dart';
import '../../payroll/bloc/salary_event.dart';
import '../../payroll/bloc/salary_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class EmployeeDashboarScreen extends StatefulWidget {
  const EmployeeDashboarScreen({super.key});

  @override
  State<EmployeeDashboarScreen> createState() => _EmployeeDashboarScreenState();
}

class _EmployeeDashboarScreenState extends State<EmployeeDashboarScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchInitialData();
    });
  }

  void _fetchInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    final adminId = prefs.getString('admin_id');
    if (adminId != null) {
      final userId = int.tryParse(adminId);
      if (userId != null) {
        if (mounted) {
          context.read<PerformanceBloc>().add(FetchPerformances(userId: userId));
          context.read<SalaryBloc>().add(FetchPayslipEvent(employeeId: userId));
          context.read<ExpenseBloc>().add(const FetchExpenses(isRefresh: true));
          context.read<TaskBloc>().add(FetchTasks());
          context.read<EmployeeAttendanceBloc>().add(FetchEmployeeAttendances());
        }
      }
    }
  }

  Future<void> _onRefresh() async {
    _fetchInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Employee Dashboard'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      drawer: const AdminDashboardDrawer(),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Summary Cards (Attendance dependent)
              BlocBuilder<EmployeeAttendanceBloc, EmployeeAttendanceState>(
                builder: (context, state) {
                  if (state is EmployeeAttendanceLoaded) {
                    final summary = state.summary;
                    return GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 1.5,
                      children: [
                        _buildTopCard(Icons.people_outline, Colors.indigo, '2', 'Branch Staff'),
                        _buildTopCard(Icons.check_circle_outline, Colors.green,
                            (summary.present ?? 0).toString(), 'Present Today',
                            subtitle: '0%'),
                        _buildTopCard(Icons.cancel_outlined, Colors.redAccent,
                            (summary.absent ?? 0).toString(), 'Absent Today'),
                        _buildTopCard(Icons.info_outline, Colors.orange, '0', 'Pending Actions'),
                      ],
                    );
                  }
                  return const SizedBox(
                    height: 100,
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Today's Attendance
              BlocBuilder<EmployeeAttendanceBloc, EmployeeAttendanceState>(
                builder: (context, state) {
                  if (state is EmployeeAttendanceLoaded) {
                    return _buildAttendanceCard(state.summary);
                  }
                  return const SizedBox();
                },
              ),
              const SizedBox(height: 16),

              // Quick Actions
              _buildQuickActionsCard(),
              const SizedBox(height: 16),

              // Expenses
              _buildExpensesCard(),
              const SizedBox(height: 16),

              // Tasks
              _buildTasksCard(),
              const SizedBox(height: 16),

              // Performance
              _buildPerformanceCard(),
              const SizedBox(height: 16),

              // Latest Payslip
              _buildLatestPayslipCard(),
              const SizedBox(height: 16),

              // Today's Summary
              BlocBuilder<EmployeeAttendanceBloc, EmployeeAttendanceState>(
                builder: (context, state) {
                  if (state is EmployeeAttendanceLoaded) {
                    return _buildTodaysSummaryCard(state.summary);
                  }
                  return const SizedBox();
                },
              ),
              const SizedBox(height: 16),

              // Team This Week
              _buildTeamThisWeekCard(),
              const SizedBox(height: 16),

              // Pending Leave Requests
              _buildPendingLeaveCard(),
              const SizedBox(height: 16),

              // Upcoming Holidays
              _buildUpcomingHolidaysCard(),
              const SizedBox(height: 16),

              // Daily Sales & Calls Report
              _buildDailySalesReportCard(),
              const SizedBox(height: 16),

              // 7-Day Trend
              _buildSevenDayTrendCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopCard(IconData icon, Color color, String value, String title, {String? subtitle}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(color: Colors.grey[400], fontSize: 10)),
          ]
        ],
      ),
    );
  }

  Widget _buildTodaysSummaryCard(AttendanceSummaryModel summary) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 18, color: Colors.indigo),
                    const SizedBox(width: 8),
                    const Text("Today's Summary",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                  ],
                ),
                Text(DateFormat('dd MMM yyyy').format(DateTime.now()),
                    style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.0,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                _buildSummaryStatBlock(
                    Colors.green[50]!, Colors.green[800]!, (summary.present ?? 0).toString(), 'Present'),
                _buildSummaryStatBlock(
                    Colors.red[50]!, Colors.red[800]!, (summary.absent ?? 0).toString(), 'Absent'),
                _buildSummaryStatBlock(
                    Colors.orange[50]!, Colors.orange[800]!, (summary.late ?? 0).toString(), 'Late'),
                _buildSummaryStatBlock(
                    Colors.teal[50]!, Colors.teal[800]!, (summary.onLeave ?? 0).toString(), 'On Leave'),
              ],
            ),
            const SizedBox(height: 24),
            const Text("PENDING REVIEWS",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 8),
            _buildReviewRow('Leave Requests', '0'),
            const Divider(),
            _buildReviewRow('Expenses', '0'),
            const Divider(),
            _buildReviewRow('Task Completions', '0'),
            const Divider(),
            _buildReviewRow('Overtime', '0'),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryStatBlock(Color bgColor, Color textColor, String value, String label) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
          Text(label, style: TextStyle(fontSize: 12, color: textColor)),
        ],
      ),
    );
  }

  Widget _buildReviewRow(String title, String count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
          Text(count, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildTeamThisWeekCard() {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.people_alt_outlined, size: 18, color: Colors.indigo),
                    const SizedBox(width: 8),
                    const Text("Team This Week",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                  ],
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    minimumSize: const Size(0, 30),
                  ),
                  child: const Text("VIEW ALL", style: TextStyle(fontSize: 10)),
                )
              ],
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowHeight: 40,
                columnSpacing: 24,
                columns: const [
                  DataColumn(label: Text('EMPLOYEE', style: TextStyle(fontSize: 10, color: Colors.grey))),
                  DataColumn(label: Text('DEPARTMENT', style: TextStyle(fontSize: 10, color: Colors.grey))),
                  DataColumn(label: Text('DAYS PRESENT', style: TextStyle(fontSize: 10, color: Colors.grey))),
                  DataColumn(label: Text('ATTENDANCE', style: TextStyle(fontSize: 10, color: Colors.grey))),
                  DataColumn(label: Text('VIEW', style: TextStyle(fontSize: 10, color: Colors.grey))),
                ],
                rows: [
                  _buildTeamRow('NE', 'Neeraj', '—', '0/1', 0.0),
                  _buildTeamRow('EM', 'EMP', '—', '0/1', 0.0),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  DataRow _buildTeamRow(String initials, String name, String dept, String days, double attendance) {
    return DataRow(cells: [
      DataCell(Row(
        children: [
          CircleAvatar(
              radius: 12,
              backgroundColor: Colors.indigo[50],
              child: Text(initials, style: const TextStyle(fontSize: 10, color: Colors.indigo))),
          const SizedBox(width: 8),
          Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      )),
      DataCell(Text(dept, style: const TextStyle(color: Colors.grey))),
      DataCell(Text(days, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold))),
      DataCell(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            height: 4,
            child: LinearProgressIndicator(
              value: attendance,
              backgroundColor: Colors.grey[200],
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 4),
          Text('${(attendance * 100).toInt()}%',
              style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      )),
      DataCell(
        Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(4)),
            child: const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey)),
      ),
    ]);
  }

  Widget _buildTasksCard() {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        int total = 0;
        int pending = 0;
        int inProgress = 0;
        int completed = 0;
        int overdue = 0;

        if (state is TaskLoaded) {
          final tasks = state.tasks;
          total = tasks.length;
          pending = tasks.where((t) => t.status.toLowerCase() == 'pending').length;
          inProgress = tasks.where((t) => t.status.toLowerCase() == 'in_progress').length;
          completed = tasks.where((t) => t.status.toLowerCase() == 'approved').length;

          final now = DateTime.now();
          overdue = tasks.where((t) {
            if (t.status.toLowerCase() == 'approved') return false;
            try {
              final deadline = DateTime.parse(t.deadline);
              return deadline.isBefore(now);
            } catch (e) {
              return false;
            }
          }).length;
        }

        return Card(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_box_outlined, size: 18, color: Colors.indigo),
                        const SizedBox(width: 8),
                        const Text("Tasks",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                      ],
                    ),
                    if (state is TaskLoading)
                      const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(strokeWidth: 2))
                    else
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                          minimumSize: const Size(0, 30),
                        ),
                        child: const Text("ALL", style: TextStyle(fontSize: 10)),
                      )
                  ],
                ),
                const SizedBox(height: 16),
                _buildTaskRow('Total', total.toString(), Colors.grey),
                _buildTaskRow('Pending', pending.toString(), Colors.grey),
                _buildTaskRow('In Progress', inProgress.toString(), Colors.blue),
                _buildTaskRow('Completed', completed.toString(), Colors.green),
                _buildTaskRow('Overdue \u26A0', overdue.toString(), Colors.red),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTaskRow(String title, String count, Color countColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: countColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child:
                Text(count, style: TextStyle(fontWeight: FontWeight.bold, color: countColor, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingLeaveCard() {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.beach_access_outlined, size: 18, color: Colors.teal),
                    const SizedBox(width: 8),
                    const Text("Pending Leave Requests",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                  ],
                ),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    minimumSize: const Size(0, 30),
                  ),
                  child: const Text("ALL", style: TextStyle(fontSize: 10)),
                )
              ],
            ),
            const SizedBox(height: 32),
            const Icon(Icons.check_circle_outline, size: 48, color: Colors.green),
            const SizedBox(height: 16),
            const Text("No pending leave requests.", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingHolidaysCard() {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.calendar_month_outlined, size: 18, color: Colors.redAccent),
                const SizedBox(width: 8),
                const Text("Upcoming Holidays",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text("01",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red[800])),
                      Text("May", style: TextStyle(fontSize: 10, color: Colors.red[800])),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Labour Day", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text("Friday", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDailySalesReportCard() {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bar_chart, size: 18, color: Colors.indigo),
                    const SizedBox(width: 8),
                    const Text("Daily Sales & Calls Report",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.indigo[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text("Last 7 days",
                      style: TextStyle(fontSize: 10, color: Colors.indigo, fontWeight: FontWeight.bold)),
                )
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child: _buildSalesStatBlock(Colors.indigo[50]!, Colors.indigo[800]!,
                        Icons.inventory_2_outlined, 'PREP ORDERS', '0', 'Today')),
                const SizedBox(width: 8),
                Expanded(
                    child: _buildSalesStatBlock(Colors.green[50]!, Colors.green[800]!,
                        Icons.local_shipping_outlined, 'COD ORDERS', '0', 'Today')),
                const SizedBox(width: 8),
                Expanded(
                    child: _buildSalesStatBlock(Colors.orange[50]!, Colors.orange[800]!,
                        Icons.phone_outlined, 'TOTAL CALLS', '0', 'Today')),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              height: 200,
              child: _buildChart(),
            ),
            const SizedBox(height: 24),
            Center(
              child: Column(
                children: [
                  const Icon(Icons.inbox_outlined, color: Colors.grey),
                  const SizedBox(height: 8),
                  Text("No sales reports submitted today.",
                      style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSalesStatBlock(
      Color bgColor, Color iconColor, IconData icon, String title, String value, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 12, color: iconColor),
              const SizedBox(width: 4),
              Flexible(
                  child: Text(title,
                      style: TextStyle(fontSize: 9, color: iconColor, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: iconColor)),
          Text(subtitle, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 100,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey[200],
              strokeWidth: 1,
            );
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(fontSize: 10, color: Colors.grey);
                Widget text;
                switch (value.toInt()) {
                  case 0:
                    text = const Text('Tue, 14 Apr', style: style);
                    break;
                  case 2:
                    text = const Text('Thu, 16 Apr', style: style);
                    break;
                  case 4:
                    text = const Text('Sat, 18 Apr', style: style);
                    break;
                  case 6:
                    text = const Text('Mon, 20 Apr', style: style);
                    break;
                  default:
                    text = const Text('', style: style);
                    break;
                }
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: text,
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 100,
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString(),
                    style: const TextStyle(fontSize: 10, color: Colors.grey));
              },
              reservedSize: 30,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 6,
        minY: 0,
        maxY: 600,
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 50),
              FlSpot(1, 150),
              FlSpot(2, 580),
              FlSpot(3, 50),
              FlSpot(4, 50),
              FlSpot(5, 50),
              FlSpot(6, 50),
            ],
            isCurved: true,
            color: Colors.orange,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard(AttendanceSummaryModel summary) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 18, color: Colors.indigo),
                    const SizedBox(width: 8),
                    const Text("Today's Attendance",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                  ],
                ),
                Text(DateFormat('dd MMM yyyy').format(DateTime.now()),
                    style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                shape: BoxShape.circle,
              ),
              child: Image.asset('assets/images/clock_icon.png',
                  height: 40,
                  errorBuilder: (c, e, s) => const Icon(Icons.alarm, size: 40, color: Colors.orange)),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Late", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text("Late 117m",
                      style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text("12:12 PM",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[800])),
                        Text("Check In", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.indigo[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text("—",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo[800])),
                        Text("Check Out", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsCard() {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.flash_on, size: 18, color: Colors.orange),
                const SizedBox(width: 8),
                const Text("Quick Actions",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
              ],
            ),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.8,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _buildQuickActionBtn(Icons.beach_access_outlined, "APPLY LEAVE", Colors.indigo),
                _buildQuickActionBtn(Icons.attach_money, "SUBMIT EXPENSE", Colors.green),
                _buildQuickActionBtn(Icons.check_box_outlined, "MY TASKS", Colors.teal),
                _buildQuickActionBtn(Icons.description_outlined, "VIEW PAYSLIP", Colors.orange),
                _buildQuickActionBtn(Icons.access_time, "SUBMIT OVERTIME", Colors.blueGrey),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionBtn(IconData icon, String label, Color color) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Flexible(
              child: Text(label,
                  style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  Widget _buildExpensesCard() {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        double pendingAmt = 0;
        double approvedAmt = 0;
        int thisMonthCount = 0;

        if (state is ExpenseLoaded) {
          final expenses = state.expenses;
          pendingAmt = expenses
              .where((e) => e.status!.toLowerCase() == 'pending')
              .fold(0.0, (sum, e) => sum + double.parse(e.amount.toString()));
          approvedAmt = expenses
              .where((e) => e.status!.toLowerCase() == 'approved')
              .fold(0.0, (sum, e) => sum + double.parse(e.amount.toString()));

          final now = DateTime.now();
          thisMonthCount = expenses.where((e) {
            try {
              final date = DateTime.parse(e.expenseDate.toString());
              return date.month == now.month && date.year == now.year;
            } catch (e) {
              return false;
            }
          }).length;
        }

        return Card(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.shopping_bag_outlined, size: 18, color: Colors.orange),
                        const SizedBox(width: 8),
                        const Text("Expenses",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                      ],
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        minimumSize: const Size(0, 30),
                      ),
                      child: const Text("ALL", style: TextStyle(fontSize: 10)),
                    )
                  ],
                ),
                const SizedBox(height: 24),
                if (state is ExpenseLoading)
                  const SizedBox(
                    height: 100,
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state is ExpenseError)
                  SizedBox(
                    height: 100,
                    child: Center(child: Text(state.message, style: const TextStyle(color: Colors.red, fontSize: 12))),
                  )
                else ...[
                  _buildValueRow('Pending', '₹${pendingAmt.toStringAsFixed(0)}', Colors.orange),
                  _buildValueRow('Approved', '₹${approvedAmt.toStringAsFixed(0)}', Colors.green),
                  _buildValueRow('This Month', '$thisMonthCount items', Colors.indigo),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, size: 16, color: Colors.orange),
                    label:
                        const Text("SUBMIT", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.orange),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildValueRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          Text(value,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: valueColor)),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard() {
    return BlocBuilder<PerformanceBloc, PerformanceState>(
      builder: (context, state) {
        return Card(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.emoji_events_outlined, size: 18, color: Colors.green),
                        const SizedBox(width: 8),
                        const Text("Performance",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                      ],
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        minimumSize: const Size(0, 30),
                      ),
                      child: const Text("VIEW", style: TextStyle(fontSize: 10)),
                    )
                  ],
                ),
                const SizedBox(height: 40),
                if (state is PerformanceLoading)
                  const SizedBox(
                    height: 80,
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state is PerformanceError)
                  SizedBox(
                    height: 80,
                    child: Center(child: Text(state.message, style: const TextStyle(color: Colors.red, fontSize: 12))),
                  )
                else if (state is PerformancesLoaded && state.performances.isNotEmpty)
                  Column(
                    children: [
                      Text(state.performances.first.grade,
                          style: const TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold, color: Colors.indigo)),
                      Text("Total Score: ${state.performances.first.totalScore}",
                          style: const TextStyle(color: Colors.grey)),
                    ],
                  )
                else
                  const Column(
                    children: [
                      Icon(Icons.military_tech_outlined, size: 48, color: Colors.grey),
                      SizedBox(height: 8),
                      Text("No rating yet.", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLatestPayslipCard() {
    return BlocBuilder<SalaryBloc, SalaryState>(
      builder: (context, state) {
        return Card(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.attach_money, size: 18, color: Colors.green),
                        const SizedBox(width: 8),
                        const Text("Latest Payslip",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                      ],
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        minimumSize: const Size(0, 30),
                      ),
                      child: const Text("ALL", style: TextStyle(fontSize: 10)),
                    )
                  ],
                ),
                const SizedBox(height: 40),
                if (state is PayslipLoading)
                  const SizedBox(
                    height: 80,
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state is PayslipError)
                  SizedBox(
                    height: 80,
                    child: Center(child: Text(state.message, style: const TextStyle(color: Colors.red, fontSize: 12))),
                  )
                else if (state is PayslipLoaded)
                  Column(
                    children: [
                      const Icon(Icons.description_outlined, size: 48, color: Colors.indigo),
                      const SizedBox(height: 16),
                      Text(state.payslip.payslip.monthLabel,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text("Net Pay: ₹${state.payslip.netPay.toStringAsFixed(2)}",
                          style:
                              const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    ],
                  )
                else
                  const Column(
                    children: [
                      Icon(Icons.description_outlined, size: 48, color: Colors.grey),
                      SizedBox(height: 8),
                      Text("No payroll records yet.", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSevenDayTrendCard() {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.trending_up, size: 18, color: Colors.green),
                const SizedBox(width: 8),
                const Text("7-Day Trend",
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
            const SizedBox(height: 16),
            _buildTrendRow('Tue', 0, 2),
            _buildTrendRow('Wed', 0, 2),
            _buildTrendRow('Thu', 0, 2),
            _buildTrendRow('Fri', 0, 2),
            _buildTrendRow('Sat', 0, 2),
            _buildTrendRow('Sun', 0, 2),
            _buildTrendRow('Mon', 0, 2),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendRow(String day, int current, int max) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
              width: 40, child: Text(day, style: const TextStyle(fontSize: 12, color: Colors.grey))),
          Expanded(
            child: LinearProgressIndicator(
              value: max > 0 ? current / max : 0,
              backgroundColor: Colors.grey[100],
              color: Colors.indigo[100],
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 16),
          Text('$current/$max', style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
