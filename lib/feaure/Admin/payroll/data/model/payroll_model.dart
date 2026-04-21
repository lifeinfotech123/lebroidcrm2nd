class PayrollSummaryModel {
  final String month;
  final int totalRecords;
  final double totalNetPay;
  final int processedCount;
  final int approvedCount;
  final int paidCount;
  final int draftCount;

  PayrollSummaryModel({
    required this.month,
    required this.totalRecords,
    required this.totalNetPay,
    required this.processedCount,
    required this.approvedCount,
    required this.paidCount,
    required this.draftCount,
  });

  factory PayrollSummaryModel.fromJson(Map<String, dynamic> json) {
    return PayrollSummaryModel(
      month: json['month'] ?? '',
      totalRecords: _toInt(json['total_records']),
      totalNetPay: _toDouble(json['total_net_pay']),
      processedCount: _toInt(json['processed_count']),
      approvedCount: _toInt(json['approved_count']),
      paidCount: _toInt(json['paid_count']),
      draftCount: _toInt(json['draft_count']),
    );
  }

  static int _toInt(dynamic val) {
    if (val == null) return 0;
    if (val is int) return val;
    if (val is double) return val.toInt();
    return int.tryParse(val.toString()) ?? 0;
  }

  static double _toDouble(dynamic val) {
    if (val == null) return 0.0;
    if (val is double) return val;
    if (val is int) return val.toDouble();
    return double.tryParse(val.toString()) ?? 0.0;
  }
}

class PayrollModel {
  final int id;
  final String userId;
  final String branchId;
  final String month;
  final int totalWorkingDays;
  final int presentDays;
  final int leaveDays;
  final int absentDays;
  final double basic;
  final double totalAllowances;
  final double grossPay;
  final double totalDeductions;
  final double netPay;
  final String status;
  final PayrollUserModel? user; // Depending on API response, sometimes might be in 'user' key. Since the given JSON doesn't show it but we need Employee name. 
  // Wait, the API response JSON has "processed_by". We will map that too if needed.
  // We'll also store processed_by.
  final PayrollUserModel? processedBy;

  PayrollModel({
    required this.id,
    required this.userId,
    required this.branchId,
    required this.month,
    required this.totalWorkingDays,
    required this.presentDays,
    required this.leaveDays,
    required this.absentDays,
    required this.basic,
    required this.totalAllowances,
    required this.grossPay,
    required this.totalDeductions,
    required this.netPay,
    required this.status,
    this.user,
    this.processedBy,
  });

  factory PayrollModel.fromJson(Map<String, dynamic> json) {
    return PayrollModel(
      id: json['id'] ?? 0,
      userId: json['user_id']?.toString() ?? '',
      branchId: json['branch_id']?.toString() ?? '',
      month: json['month'] ?? '',
      totalWorkingDays: _toInt(json['total_working_days']),
      presentDays: _toInt(json['present_days']),
      leaveDays: _toInt(json['leave_days']),
      absentDays: _toInt(json['absent_days']),
      basic: _toDouble(json['basic']),
      totalAllowances: _toDouble(json['total_allowances']),
      grossPay: _toDouble(json['gross_pay']),
      totalDeductions: _toDouble(json['total_deductions']),
      netPay: _toDouble(json['net_pay']),
      status: json['status'] ?? '',
      user: json['user'] != null && json['user'] is Map<String, dynamic>
          ? PayrollUserModel.fromJson(json['user'])
          : null,
      processedBy: json['processed_by'] != null && json['processed_by'] is Map<String, dynamic>
          ? PayrollUserModel.fromJson(json['processed_by'])
          : null,
    );
  }

  static int _toInt(dynamic val) {
    if (val == null) return 0;
    if (val is int) return val;
    if (val is double) return val.toInt();
    return int.tryParse(val.toString()) ?? 0;
  }

  static double _toDouble(dynamic val) {
    if (val == null) return 0.0;
    if (val is double) return val;
    if (val is int) return val.toDouble();
    return double.tryParse(val.toString()) ?? 0.0;
  }

  String get employeeName => user?.name ?? (processedBy?.name ?? 'Employee #$userId');
}

class PayrollUserModel {
  final int id;
  final String name;
  final String email;

  PayrollUserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory PayrollUserModel.fromJson(Map<String, dynamic> json) {
    return PayrollUserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class PayrollPreviewModel {
  final String userId;
  final String month;
  final int workingDays;
  final int presentDays;
  final double grossPay;
  final double totalDeductions;
  final double netPay;
  final bool alreadyProcessed;
  final PayrollUserModel? employee;

  PayrollPreviewModel({
    required this.userId,
    required this.month,
    required this.workingDays,
    required this.presentDays,
    required this.grossPay,
    required this.totalDeductions,
    required this.netPay,
    required this.alreadyProcessed,
    this.employee,
  });

  factory PayrollPreviewModel.fromJson(Map<String, dynamic> json) {
    return PayrollPreviewModel(
      userId: json['user_id']?.toString() ?? '',
      month: json['month'] ?? '',
      workingDays: _toInt(json['working_days']),
      presentDays: _toInt(json['present_days']),
      grossPay: _toDouble(json['gross_pay']),
      totalDeductions: _toDouble(json['total_deductions']),
      netPay: _toDouble(json['net_pay']),
      alreadyProcessed: json['already_processed'] ?? false,
      employee: json['employee'] != null && json['employee'] is Map<String, dynamic>
          ? PayrollUserModel.fromJson(json['employee'])
          : null,
    );
  }

  static int _toInt(dynamic val) {
    if (val == null) return 0;
    if (val is int) return val;
    if (val is double) return val.toInt();
    return int.tryParse(val.toString()) ?? 0;
  }

  static double _toDouble(dynamic val) {
    if (val == null) return 0.0;
    if (val is double) return val;
    if (val is int) return val.toDouble();
    return double.tryParse(val.toString()) ?? 0.0;
  }
}
