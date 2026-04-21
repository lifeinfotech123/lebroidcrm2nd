class AdminDashboardResponse {
  final bool success;
  final DashboardData dashboard;

  AdminDashboardResponse({required this.success, required this.dashboard});

  factory AdminDashboardResponse.fromJson(Map<String, dynamic> json) {
    return AdminDashboardResponse(
      success: json['success'] ?? false,
      dashboard: DashboardData.fromJson(json['dashboard'] ?? {}),
    );
  }
}

class DashboardData {
  final OrganizationData organization;
  final PersonalData personal;
  final SharedData shared;

  DashboardData({
    required this.organization,
    required this.personal,
    required this.shared,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      organization: OrganizationData.fromJson(json['organization'] ?? {}),
      personal: PersonalData.fromJson(json['personal'] ?? {}),
      shared: SharedData.fromJson(json['shared'] ?? {}),
    );
  }
}

class OrganizationData {
  final WorkforceData workforce;
  final List<BranchData> branches;
  final TodayAttendanceData todayAttendance;
  final List<AttendanceTrendData> attendanceTrend;
  final PayrollSummaryData payrollSummary;
  final PendingApprovalsData pendingApprovals;
  final ExpenseSummaryData expenseSummary;
  final TasksOverviewData tasksOverview;
  final List<RecentAuditData> recentAudits;

  OrganizationData({
    required this.workforce,
    required this.branches,
    required this.todayAttendance,
    required this.attendanceTrend,
    required this.payrollSummary,
    required this.pendingApprovals,
    required this.expenseSummary,
    required this.tasksOverview,
    required this.recentAudits,
  });

  factory OrganizationData.fromJson(Map<String, dynamic> json) {
    var branchesList = json['branches'] as List? ?? [];
    var trendList = json['attendance_trend'] as List? ?? [];
    var auditsList = json['recent_audits'] as List? ?? [];

    return OrganizationData(
      workforce: WorkforceData.fromJson(json['workforce'] ?? {}),
      branches: branchesList.map((e) => BranchData.fromJson(e)).toList(),
      todayAttendance: TodayAttendanceData.fromJson(json['today_attendance'] ?? {}),
      attendanceTrend: trendList.map((e) => AttendanceTrendData.fromJson(e)).toList(),
      payrollSummary: PayrollSummaryData.fromJson(json['payroll_summary'] ?? {}),
      pendingApprovals: PendingApprovalsData.fromJson(json['pending_approvals'] ?? {}),
      expenseSummary: ExpenseSummaryData.fromJson(json['expense_summary'] ?? {}),
      tasksOverview: TasksOverviewData.fromJson(json['tasks_overview'] ?? {}),
      recentAudits: auditsList.map((e) => RecentAuditData.fromJson(e)).toList(),
    );
  }
}

class WorkforceData {
  final int total;
  final int onLeave;

  WorkforceData({required this.total, required this.onLeave});

  factory WorkforceData.fromJson(Map<String, dynamic> json) {
    return WorkforceData(
      total: json['total'] ?? 0,
      onLeave: json['onLeave'] ?? 0,
    );
  }
}

class BranchData {
  final String name;
  final int employees;
  final int present;
  final int absent;
  final num pct;
  final String manager;

  BranchData({
    required this.name,
    required this.employees,
    required this.present,
    required this.absent,
    required this.pct,
    required this.manager,
  });

  factory BranchData.fromJson(Map<String, dynamic> json) {
    return BranchData(
      name: json['name'] ?? '',
      employees: json['employees'] ?? 0,
      present: json['present'] ?? 0,
      absent: json['absent'] ?? 0,
      pct: json['pct'] ?? 0,
      manager: json['manager'] ?? '',
    );
  }
}

class TodayAttendanceData {
  final int present;
  final int absent;
  final int late;
  final num pct;

  TodayAttendanceData({
    required this.present,
    required this.absent,
    required this.late,
    required this.pct,
  });

  factory TodayAttendanceData.fromJson(Map<String, dynamic> json) {
    return TodayAttendanceData(
      present: json['present'] ?? 0,
      absent: json['absent'] ?? 0,
      late: json['late'] ?? 0,
      pct: json['pct'] ?? 0,
    );
  }
}

class AttendanceTrendData {
  final String date;
  final int present;
  final int total;

  AttendanceTrendData({
    required this.date,
    required this.present,
    required this.total,
  });

  factory AttendanceTrendData.fromJson(Map<String, dynamic> json) {
    return AttendanceTrendData(
      date: json['date'] ?? '',
      present: json['present'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}

class PayrollSummaryData {
  final String targetMonth;
  final String totalNet;
  final int processed;
  final int paid;

  PayrollSummaryData({
    required this.targetMonth,
    required this.totalNet,
    required this.processed,
    required this.paid,
  });

  factory PayrollSummaryData.fromJson(Map<String, dynamic> json) {
    return PayrollSummaryData(
      targetMonth: json['target_month'] ?? '',
      totalNet: json['total_net']?.toString() ?? '0',
      processed: json['processed'] ?? 0,
      paid: json['paid'] ?? 0,
    );
  }
}

class PendingApprovalsData {
  final int leaves;
  final int expensesCount;
  final int overtime;

  PendingApprovalsData({
    required this.leaves,
    required this.expensesCount,
    required this.overtime,
  });

  factory PendingApprovalsData.fromJson(Map<String, dynamic> json) {
    return PendingApprovalsData(
      leaves: json['leaves'] ?? 0,
      expensesCount: json['expenses_count'] ?? 0,
      overtime: json['overtime'] ?? 0,
    );
  }
}

class ExpenseSummaryData {
  final String pendingAmount;
  final String approvedThisMonth;

  ExpenseSummaryData({
    required this.pendingAmount,
    required this.approvedThisMonth,
  });

  factory ExpenseSummaryData.fromJson(Map<String, dynamic> json) {
    return ExpenseSummaryData(
      pendingAmount: json['pending_amount']?.toString() ?? '0',
      approvedThisMonth: json['approved_this_month']?.toString() ?? '0',
    );
  }
}

class TasksOverviewData {
  final int totalThisMonth;
  final int pending;
  final int inProgress;
  final int completed;
  final int overdue;

  TasksOverviewData({
    required this.totalThisMonth,
    required this.pending,
    required this.inProgress,
    required this.completed,
    required this.overdue,
  });

  factory TasksOverviewData.fromJson(Map<String, dynamic> json) {
    return TasksOverviewData(
      totalThisMonth: json['total_this_month'] ?? 0,
      pending: json['pending'] ?? 0,
      inProgress: json['inProgress'] ?? 0,
      completed: json['completed'] ?? 0,
      overdue: json['overdue'] ?? 0,
    );
  }
}

class RecentAuditData {
  final String event;
  final String module;
  final String createdAt;
  final Map<String, dynamic> user;

  RecentAuditData({
    required this.event,
    required this.module,
    required this.createdAt,
    required this.user,
  });

  factory RecentAuditData.fromJson(Map<String, dynamic> json) {
    return RecentAuditData(
      event: json['event'] ?? '',
      module: json['module'] ?? '',
      createdAt: json['created_at'] ?? '',
      user: json['user'] ?? {},
    );
  }
}

class PersonalData {
  // Not creating all mapping since not explicitly requested on UI
  // Add as needed
  PersonalData();

  factory PersonalData.fromJson(Map<String, dynamic> json) {
    return PersonalData();
  }
}

class SharedData {
  final List<UpcomingHolidayData> upcomingHolidays;

  SharedData({required this.upcomingHolidays});

  factory SharedData.fromJson(Map<String, dynamic> json) {
    var holidaysList = json['upcoming_holidays'] as List? ?? [];
    return SharedData(
      upcomingHolidays: holidaysList.map((e) => UpcomingHolidayData.fromJson(e)).toList(),
    );
  }
}

class UpcomingHolidayData {
  final String name;
  final String date;

  UpcomingHolidayData({required this.name, required this.date});

  factory UpcomingHolidayData.fromJson(Map<String, dynamic> json) {
    return UpcomingHolidayData(
      name: json['name'] ?? '',
      date: json['date'] ?? '',
    );
  }
}
