import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../auth/data/services/permission_service.dart';
import '../../../attendance_management/bloc/user_attendance/user_attendance_bloc.dart';
import '../../../attendance_management/data/repository/employee_attendance_repository.dart';
import 'package:lebroid_crm/feaure/Admin/attendance_management/screen/attendance_calender_screen.dart';
import 'package:lebroid_crm/feaure/Admin/attendance_management/screen/mark_attendance_screen.dart';
import 'package:lebroid_crm/feaure/Admin/expense_management/screen/expence_approvals_screen.dart';
import 'package:lebroid_crm/feaure/Admin/expense_management/screen/expence_category_screen.dart';

import '../../../../Employee/bottom_navigation_bar/presentation/screens/profile_screen.dart';
import '../../../administration/screen/multi_branch_location_screen.dart';
import '../../../administration/screen/notifications_screen.dart';
import '../../../administration/screen/permissions_screen.dart';
import '../../../administration/screen/user_roles_screen.dart';
import '../../../attendance_management/screen/attendance_reports_screen.dart';
import '../../../attendance_management/screen/attendance_summary_screen.dart';
import '../../../attendance_management/screen/attendence_correction_screen.dart';
import '../../../attendance_management/screen/employee_attendance_screen.dart';
import '../../../attendance_management/screen/geo_fence_screen.dart';
import '../../../attendance_management/screen/my_break_time_screen.dart';
import '../../../attendance_management/screen/selfie_attendance_screen.dart';
import '../../../attendance_management/screen/shift_working_hours_screen.dart';
import '../../../branch_management/screen/add_branch_screen.dart';
import '../../../branch_management/screen/branch_list_screen.dart';
import '../../../break_management/screen/break_types_screen.dart';
import '../../../break_management/screen/breaks_screen.dart';
import '../../../department_management/presentation/screen/add_department_screen.dart';
import '../../../department_management/presentation/screen/department_list_screen.dart';
import '../../../employees_management/screen/add_employee_screen.dart';
import '../../../employees_management/screen/employee_list_screen.dart';
import '../../../expense_management/screen/add_expense_screen.dart';
import '../../../expense_management/screen/expence_list_screen.dart';
import '../../../help_support/screen/documentation_screen.dart';
import '../../../help_support/screen/help_center_screen.dart';
import '../../../help_support/screen/user_assistance_screen.dart';
import '../../../leave_management/screen/apply_for_leave_screen.dart';
import '../../../leave_management/screen/leave_approvals_screen.dart';
import '../../../leave_management/screen/leave_balance_screen.dart';
import '../../../leave_management/screen/leave_calendar_screen.dart';
import '../../../leave_management/screen/leave_requests_screen.dart';
import '../../../leave_management/screen/leave_type_list_screen.dart';
import '../../../payroll/screen/allowance_deductions_screen.dart';
import '../../../payroll/screen/overtime_management_screen.dart';
import '../../../payroll/screen/payroll_approval_screen.dart';
import '../../../payroll/screen/payroll_drafts_screen.dart';
import '../../../payroll/screen/payroll_process_screen.dart';
import '../../../payroll/screen/payroll_reports_screen.dart';
import '../../../payroll/screen/payroll_screen.dart';
import '../../../payroll/screen/salary_management_screen.dart';
import '../../../performance_management/screen/goal_tracking_screen.dart';
import '../../../performance_management/screen/kpi_manager_screen.dart';
import '../../../performance_management/screen/performance_monitoring_screen.dart';
import '../../../performance_management/screen/performance_ratings_screen.dart';
import '../../../reports_analytics/screen/dashboard_insights_screen.dart';
import '../../../reports_analytics/screen/attendance_report_screen.dart';
import '../../../reports_analytics/screen/leave_report_screen.dart';
import '../../../reports_analytics/screen/payroll_report_screen.dart';
import '../../../reports_analytics/screen/expense_report_screen.dart';
import '../../../reports_analytics/screen/task_report_screen.dart';
import '../../../reports_analytics/screen/performance_report_screen.dart';
import '../../../role_management/screen/add_role_screen.dart';
import '../../../role_management/screen/role_list_screen.dart';
import '../../../role_management/screen/role_permissions_screen.dart';
import '../../../system_settings/screen/break_category_screen.dart';
import '../../../system_settings/screen/business_settings_screen.dart';
import '../../../system_settings/screen/compliance_audit_screen.dart';
import '../../../system_settings/screen/department_settings_screen.dart';
import '../../../system_settings/screen/leave_type_settings_screen.dart';
import '../../../system_settings/screen/offline_sync_screen.dart';
import '../../../system_settings/screen/role_settings_screen.dart';
import '../../../system_settings/screen/security_access_screen.dart';
import '../../../system_settings/screen/shift_settings_screen.dart';
import '../../../tasks_productivity/screen/create_task_screen.dart';
import '../../../tasks_productivity/screen/task_approvals_screen.dart';
import '../../../tasks_productivity/screen/task_assignment_screen.dart';
import '../../../tasks_productivity/screen/task_board_screen.dart';

class AdminDashboardDrawer extends StatefulWidget {
  const AdminDashboardDrawer({super.key});

  @override
  State<AdminDashboardDrawer> createState() => _AdminDashboardDrawerState();
}

class _AdminDashboardDrawerState extends State<AdminDashboardDrawer> {
  List<String> _permissions = [];
  String _userName = '';
  String _userEmail = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final permissions = await PermissionService.getPermissions();
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _permissions = permissions;
        _userName = prefs.getString('name') ?? 'User';
        _userEmail = prefs.getString('email') ?? '';
        _isLoading = false;
      });
    }
  }

  /// Check if user has ANY permission starting with any of the given prefixes
  bool _hasPrefixes(List<String> prefixes) {
    return PermissionService.hasAnyPermissionWithPrefixes(_permissions, prefixes);
  }

  bool _hasPermission(String name) {
    return PermissionService.hasPermission(_permissions, name);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Drawer(child: Center(child: CircularProgressIndicator()));
    }

    return Drawer(
      backgroundColor: const Color(0xffF4F6F8),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// 🔹 PROFILE HEADER
              InkWell(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen())),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Row(
                    children: [
                      const CircleAvatar(radius: 28, backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=3")),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text(_userEmail, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16)
                    ],
                  ),
                ),
              ),

              const Divider(height: 1),

              if (_hasPrefixes(['branch.']))
                DrawerExpandable(icon: Icons.location_on_outlined, title: "Branch Management", children: [
                  if (_hasPermission('branch.create'))
                    DrawerChild(title: "Add Branch", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddBranchScreen()))),
                  if (_hasPermission('branch.viewAny'))
                    DrawerChild(title: "Branch List", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BranchListScreen()))),
                ]),

              if (_hasPrefixes(['department.']))
                DrawerExpandable(icon: Icons.layers_outlined, title: "Department Management", children: [
                  if (_hasPermission('department.create'))
                    DrawerChild(title: "Add Department", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddDepartmentScreen()))),
                  if (_hasPermission('department.viewAny'))
                    DrawerChild(title: "Department List", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DepartmentListScreen()))),
                ]),

              if (_hasPrefixes(['role.']))
                DrawerExpandable(icon: Icons.manage_accounts_outlined, title: "Role Management", children: [
                  if (_hasPermission('role.create'))
                    DrawerChild(title: "Add Role", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddRoleScreen()))),
                  if (_hasPermission('role.viewAny'))
                    DrawerChild(title: "Role List", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RoleListScreen()))),
                  if (_hasPermission('role.update') || _hasPermission('role.delete'))
                    DrawerChild(title: "Role Permissions", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RolePermissionsScreen()))),
                ]),

              if (_hasPrefixes(['employee.']))
                DrawerExpandable(icon: Icons.group_outlined, title: "Employees Management", children: [
                  if (_hasPermission('employee.create'))
                    DrawerChild(title: "Add Employee", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEmployeeScreen()))),
                  if (_hasPermission('employee.viewAny'))
                    DrawerChild(title: "Employee List", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmployeeListScreen()))),
                ]),

              if (_hasPrefixes(['attendance.', 'shift.']))
                DrawerExpandable(icon: Icons.access_time_outlined, title: "Attendance Management", children: [
                  DrawerChild(title: "Employee Attendance", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmployeeAttendanceScreen()))),
                  DrawerChild(title: "Mark Attendance", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MarkAttendanceScreen()))),
                  DrawerChild(title: "Attendance Calender", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BlocProvider(create: (_) => UserAttendanceBloc(repository: EmployeeAttendanceRepository()), child: const AttendanceCalenderScreen())))),
                  DrawerChild(title: "Selfie Attendance", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BlocProvider(create: (_) => UserAttendanceBloc(repository: EmployeeAttendanceRepository()), child: const SelfieAttendanceScreen())))),
                  DrawerChild(title: "Attendance Summary", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AttendanceSummaryScreen()))),
                  DrawerChild(title: "Correction", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AttendanceCorrectionScreen()))),
                  DrawerChild(title: "Geo Fence", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GeoFenceScreen()))),
                  DrawerChild(title: "Shift & Working Hours", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ShiftWorkingHoursScreen()))),
                  DrawerChild(title: "My Break Time", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyBreakTimeScreen()))),
                  DrawerChild(title: "Attendance Reports", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AttendanceReportsScreen()))),
                ]),

              if (_hasPrefixes(['leave.']))
                DrawerExpandable(icon: Icons.calendar_month_outlined, title: "Leave Management", children: [
                  DrawerChild(title: "Apply for Leave", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ApplyForLeaveScreen()))),
                  DrawerChild(title: "Leave Requests", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaveRequestsScreen()))),
                  DrawerChild(title: "Leave Approvals", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaveApprovalsScreen()))),
                  DrawerChild(title: "Leave Balance", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaveBalanceScreen()))),
                  DrawerChild(title: "Leave Calendar", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaveCalendarScreen()))),
                  DrawerChild(title: "Leave Type Manager", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaveTypeListScreen()))),
                ]),

              if (_hasPrefixes(['break.', 'breakType.']))
                DrawerExpandable(icon: Icons.free_breakfast_outlined, title: "Break Management", children: [
                  DrawerChild(title: "Breaks", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BreaksScreen()))),
                  DrawerChild(title: "Break Types", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BreakTypesScreen()))),
                ]),

              if (_hasPrefixes(['task.']))
                DrawerExpandable(icon: Icons.task_alt_outlined, title: "Tasks & Productivity", children: [
                  if (_hasPermission('task.create'))
                    DrawerChild(title: "Create Task", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateTaskScreen()))),
                  if (_hasPermission('task.viewAny') || _hasPermission('task.reassign'))
                    DrawerChild(title: "Task Assignment", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TaskAssignmentScreen()))),
                  if (_hasPermission('task.view') || _hasPermission('task.viewOwn'))
                    DrawerChild(title: "Task Board", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TaskBoardScreen()))),
                  if (_hasPermission('task.approve'))
                    DrawerChild(title: "Task Approvals", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TaskApprovalsScreen()))),
                ]),

              if (_hasPrefixes(['performance.']))
                DrawerExpandable(icon: Icons.workspace_premium_outlined, title: "Performance Management", children: [
                  DrawerChild(title: "Performance Monitoring", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PerformanceMonitoringScreen()))),
                  DrawerChild(title: "Goal Tracking", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GoalTrackingScreen()))),
                  DrawerChild(title: "KPI Manager", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const KPIManagerScreen()))),
                  DrawerChild(title: "Performance Ratings", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PerformanceRatingsScreen()))),
                ]),

              if (_hasPrefixes(['payroll.', 'salary.', 'allowance.', 'deduction.', 'overtime.']))
                DrawerExpandable(icon: Icons.attach_money_outlined, title: "Payroll", children: [
                  if (_hasPermission('payroll.viewAny') || _hasPermission('payroll.view'))
                    DrawerChild(title: "Payroll", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PayrollScreen()))),
                  if (_hasPermission('payroll.create') || _hasPermission('payroll.update'))
                    DrawerChild(title: "Payroll Process", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PayrollProcessScreen()))),
                  if (_hasPermission('payroll.viewAny') || _hasPermission('payroll.view'))
                    DrawerChild(title: "Payroll Drafts", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PayrollDraftsScreen()))),
                  if (_hasPermission('payroll.approve'))
                    DrawerChild(title: "Payroll Approval", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PayrollApprovalScreen()))),
                  if (_hasPrefixes(['salary.']))
                    DrawerChild(title: "Salary Management", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SalaryManagementScreen()))),
                  if (_hasPrefixes(['overtime.']))
                    DrawerChild(title: "Overtime Management", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OvertimeManagementScreen()))),
                  if (_hasPrefixes(['allowance.', 'deduction.']))
                    DrawerChild(title: "Allowance & Deductions", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AllowanceDeductionsScreen()))),
                  if (_hasPermission('payroll.export') || _hasPermission('payroll.viewAny'))
                    DrawerChild(title: "Payroll Reports", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PayrollReportsScreen()))),
                ]),

              if (_hasPrefixes(['expense.']))
                DrawerExpandable(icon: Icons.receipt_long_outlined, title: "Expense Management", children: [
                  DrawerChild(title: "Add Expense", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddExpenseScreen()))),
                  DrawerChild(title: "Expense List", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExpenceListScreen()))),
                  DrawerChild(title: "Expense Approvals", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExpenceApprovalsScreen()))),
                  DrawerChild(title: "Expense Category", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExpenceCategoryScreen()))),
                ]),

              if (_hasPrefixes(['report.', 'audit.']))
                DrawerExpandable(icon: Icons.bar_chart_outlined, title: "Reports & Analytics", children: [
                  DrawerChild(title: "Attendance Reports", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AttendanceReportScreen()))),
                  DrawerChild(title: "Leave Reports", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaveReportScreen()))),
                  DrawerChild(title: "Payroll Reports", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PayrollReportScreen()))),
                  DrawerChild(title: "Expense Reports", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ExpenseReportScreen()))),
                  DrawerChild(title: "Task Reports", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TaskReportScreen()))),
                  DrawerChild(title: "Performance Reports", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PerformanceReportScreen()))),
                  DrawerChild(title: "Dashboard Insights", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DashboardInsightsScreen()))),
                ]),

              if (_hasPrefixes(['admin.']))
                DrawerExpandable(icon: Icons.admin_panel_settings_outlined, title: "Administration", children: [
                  DrawerChild(title: "User Roles", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UserRolesScreen()))),
                  DrawerChild(title: "Permissions", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PermissionsScreen()))),
                  DrawerChild(title: "Notifications", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()))),
                  DrawerChild(title: "Multi Branch / Location", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MultiBranchLocationScreen()))),
                ]),

              if (_hasPrefixes(['admin.systemConfig']))
                DrawerExpandable(icon: Icons.settings_outlined, title: "System Settings", children: [
                  DrawerChild(title: "Business Settings", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BusinessSettingsScreen()))),
                  DrawerChild(title: "Offline Sync", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OfflineSyncScreen()))),
                  DrawerChild(title: "Break Category", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BreakCategoryScreen()))),
                  DrawerChild(title: "Security & Access", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SecurityAccessScreen()))),
                  DrawerChild(title: "Compliance & Audit", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ComplianceAuditScreen()))),
                  DrawerChild(title: "Department Settings", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DepartmentSettingsScreen()))),
                  DrawerChild(title: "Role Settings", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RoleSettingsScreen()))),
                  DrawerChild(title: "Shift Settings", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ShiftSettingsScreen()))),
                  DrawerChild(title: "Leave Type Settings", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaveTypeSettingsScreen()))),
                ]),

              // Help & Support - always visible (no permission check needed)
              DrawerExpandable(icon: Icons.support_agent_outlined, title: "Help & Support", children: [
                DrawerChild(title: "Help Center", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpCenterScreen()))),
                DrawerChild(title: "User Assistance", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UserAssistanceScreen()))),
                DrawerChild(title: "Documentation", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DocumentationScreen()))),
              ]),

            ],
          ),
        ),
      ),
    );
  }
}


class DrawerExpandable extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;

  const DrawerExpandable({
    super.key,
    required this.icon,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(icon, size: 22),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      childrenPadding: const EdgeInsets.only(left: 40),
      children: children,
    );
  }
}

class DrawerChild extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const DrawerChild({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Text(
        title,
        style: const TextStyle(fontSize: 13),
      ),
      onTap: onTap,
    );
  }
}