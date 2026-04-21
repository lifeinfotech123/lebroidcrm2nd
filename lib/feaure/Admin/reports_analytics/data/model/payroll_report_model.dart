class PayrollReportResponse {
  final List<PayrollReportRow> rows;

  PayrollReportResponse({required this.rows});

  factory PayrollReportResponse.fromJson(Map<String, dynamic> json) {
    return PayrollReportResponse(
      rows: (json['rows'] as List).map((i) => PayrollReportRow.fromJson(i)).toList(),
    );
  }
}

class PayrollReportRow {
  final String? employeeId;
  final String? name;
  final String? department;
  final String? branch;
  final String? month;
  final int? workingDays;
  final int? presentDays;
  final int? absentDays;
  final int? leaveDays;
  final String? overtimeHours;
  final String? basic;
  final String? hra;
  final String? totalAllowances;
  final String? overtimePay;
  final String? grossPay;
  final String? totalDeductions;
  final String? netPay;
  final String? status;
  final String? paidAt;
  final String? paymentRef;

  PayrollReportRow({
    this.employeeId,
    this.name,
    this.department,
    this.branch,
    this.month,
    this.workingDays,
    this.presentDays,
    this.absentDays,
    this.leaveDays,
    this.overtimeHours,
    this.basic,
    this.hra,
    this.totalAllowances,
    this.overtimePay,
    this.grossPay,
    this.totalDeductions,
    this.netPay,
    this.status,
    this.paidAt,
    this.paymentRef,
  });

  factory PayrollReportRow.fromJson(Map<String, dynamic> json) {
    return PayrollReportRow(
      employeeId: json['employee_id'],
      name: json['name'],
      department: json['department'],
      branch: json['branch'],
      month: json['month'],
      workingDays: json['working_days'],
      presentDays: json['present_days'],
      absentDays: json['absent_days'],
      leaveDays: json['leave_days'],
      overtimeHours: json['overtime_hours'],
      basic: json['basic'],
      hra: json['hra'],
      totalAllowances: json['total_allowances'],
      overtimePay: json['overtime_pay'],
      grossPay: json['gross_pay'],
      totalDeductions: json['total_deductions'],
      netPay: json['net_pay'],
      status: json['status'],
      paidAt: json['paid_at'],
      paymentRef: json['payment_ref'],
    );
  }
}
