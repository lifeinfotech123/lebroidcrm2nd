class LeaveReportModel {
  final String? employeeId;
  final String? name;
  final String? department;
  final String? branch;
  final String? leaveType;
  final String? fromDate;
  final String? toDate;
  final int? days;
  final String? dayType;
  final String? status;
  final String? isPaid;
  final String? reason;
  final String? approvedBy;
  final String? approvedAt;

  LeaveReportModel({
    this.employeeId,
    this.name,
    this.department,
    this.branch,
    this.leaveType,
    this.fromDate,
    this.toDate,
    this.days,
    this.dayType,
    this.status,
    this.isPaid,
    this.reason,
    this.approvedBy,
    this.approvedAt,
  });

  factory LeaveReportModel.fromJson(Map<String, dynamic> json) {
    return LeaveReportModel(
      employeeId: json['employee_id'],
      name: json['name'],
      department: json['department'],
      branch: json['branch'],
      leaveType: json['leave_type'],
      fromDate: json['from_date'],
      toDate: json['to_date'],
      days: json['days'],
      dayType: json['day_type'],
      status: json['status'],
      isPaid: json['is_paid'],
      reason: json['reason'],
      approvedBy: json['approved_by'],
      approvedAt: json['approved_at'],
    );
  }
}
