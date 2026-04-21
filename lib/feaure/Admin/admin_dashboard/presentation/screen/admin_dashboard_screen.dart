import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../auth/data/services/auth_service.dart';
import '../../../../auth/data/services/auth_service.dart';
import '../../data/repositories/admin_dashboard_repository.dart';
import '../../logics/admin_dashboard_bloc.dart';


import '../../logics/admin_dashboard_event.dart';
import '../../logics/admin_dashboard_state.dart';
import '../widget/7days_attendace_trend_widget.dart';
import '../widget/TopStatsCardWidget.dart';
import '../widget/admin_dashboard_drawer.dart';
import '../widget/branch_attendace_today_widget.dart';
import '../widget/branch_expences_month_years_widget.dart';
import '../widget/branch_task_month_year_widget.dart';
import '../widget/payroll_month_year_widget.dart';
import '../widget/pending_approvals_widget.dart';
import '../widget/recent_activity_widget.dart';
import '../widget/todays_attendance_widget.dart';
import '../widget/upcoming_holidays_widget.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminDashboardBloc(
        AdminDashboardRepository(AuthService()),
      )..add(FetchAdminDashboardDataEvent()),
      child: const AdminDashboardView(),
    );
  }
}

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminDashboardDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          "Admin Dashboard",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<AdminDashboardBloc, AdminDashboardState>(
        builder: (context, state) {
          if (state is AdminDashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AdminDashboardFailure) {
            return Center(child: Text("Error: ${state.error}"));
          } else if (state is AdminDashboardSuccess) {
            final dash = state.data.dashboard;
            return Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TopStatsSection(data: dash.organization),
                    const SizedBox(height: 25),
                    TodaysAttendanceWidget(data: dash.organization.todayAttendance),
                    const SizedBox(height: 25),
                    PendingApprovalsWidget(data: dash.organization.pendingApprovals),
                    const SizedBox(height: 25),
                    PayrollMonthYearWidget(data: dash.organization.payrollSummary),
                    const SizedBox(height: 25),
                    BranchExpencesMonthYearsWidget(data: dash.organization.expenseSummary),
                    const SizedBox(height: 25),
                    BranchAttendanceTodayWidget(branches: dash.organization.branches),
                    const SizedBox(height: 25),
                    BranchTaskMonthYearWidget(data: dash.organization.tasksOverview),
                    const SizedBox(height: 25),
                    SevenDatsAttendanceTrend(data: dash.organization.attendanceTrend),
                    const SizedBox(height: 16),
                    UpcomingHolidaysWidget(data: dash.shared),
                    const SizedBox(height: 16),
                    RecentActivityWidget(activities: dash.organization.recentAudits),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }
          return const Center(child: Text("No Data"));
        },
      ),
    );
  }
}
