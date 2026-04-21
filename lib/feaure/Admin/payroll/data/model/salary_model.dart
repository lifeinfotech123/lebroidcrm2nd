// ─── Salary Overview Models ────────────────────────────────────────

class SalaryOverviewTotals {
  final double basic;
  final double gross;
  final double net;
  final double avgNet;

  SalaryOverviewTotals({
    required this.basic,
    required this.gross,
    required this.net,
    required this.avgNet,
  });

  factory SalaryOverviewTotals.fromJson(Map<String, dynamic> json) {
    return SalaryOverviewTotals(
      basic: _toDouble(json['basic']),
      gross: _toDouble(json['gross']),
      net: _toDouble(json['net']),
      avgNet: _toDouble(json['avg_net']),
    );
  }
}

class SalaryBranchSummary {
  final String branchName;
  final int employeeCount;
  final double totalBasic;
  final double totalGross;
  final double totalNet;
  final double avgNet;

  SalaryBranchSummary({
    required this.branchName,
    required this.employeeCount,
    required this.totalBasic,
    required this.totalGross,
    required this.totalNet,
    required this.avgNet,
  });

  factory SalaryBranchSummary.fromJson(String name, Map<String, dynamic> json) {
    return SalaryBranchSummary(
      branchName: name,
      employeeCount: _toInt(json['employee_count']),
      totalBasic: _toDouble(json['total_basic']),
      totalGross: _toDouble(json['total_gross']),
      totalNet: _toDouble(json['total_net']),
      avgNet: _toDouble(json['avg_net']),
    );
  }
}

class SalaryEmployeeModel {
  final int employeeId;
  final String name;
  final String? empCode;
  final String? department;
  final String? branch;
  final double basicSalary;
  final double grossSalary;
  final double netSalary;
  final String salaryType;

  SalaryEmployeeModel({
    required this.employeeId,
    required this.name,
    this.empCode,
    this.department,
    this.branch,
    required this.basicSalary,
    required this.grossSalary,
    required this.netSalary,
    required this.salaryType,
  });

  factory SalaryEmployeeModel.fromJson(Map<String, dynamic> json) {
    return SalaryEmployeeModel(
      employeeId: _toInt(json['employee_id']),
      name: json['name'] ?? '',
      empCode: json['emp_code'],
      department: json['department'],
      branch: json['branch'],
      basicSalary: _toDouble(json['basic_salary']),
      grossSalary: _toDouble(json['gross_salary']),
      netSalary: _toDouble(json['net_salary']),
      salaryType: json['salary_type'] ?? 'monthly',
    );
  }

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase() : '??';
  }
}

class SalaryOverviewModel {
  final int totalEmployees;
  final SalaryOverviewTotals totals;
  final List<SalaryBranchSummary> branches;
  final List<SalaryEmployeeModel> employees;

  SalaryOverviewModel({
    required this.totalEmployees,
    required this.totals,
    required this.branches,
    required this.employees,
  });

  factory SalaryOverviewModel.fromJson(Map<String, dynamic> json) {
    // Parse branches from map
    final branchMap = json['by_branch'] as Map<String, dynamic>? ?? {};
    final branches = branchMap.entries
        .map((e) => SalaryBranchSummary.fromJson(e.key, e.value))
        .toList();

    // Parse employees
    final empList = json['employees'] as List? ?? [];
    final employees =
        empList.map((e) => SalaryEmployeeModel.fromJson(e)).toList();

    return SalaryOverviewModel(
      totalEmployees: _toInt(json['total_employees']),
      totals: SalaryOverviewTotals.fromJson(json['totals'] ?? {}),
      branches: branches,
      employees: employees,
    );
  }
}

// ─── Salary Allowances & Deductions (shared sub-models) ───────────

class SalaryAllowances {
  final double hra;
  final double transportAllowance;
  final double medicalAllowance;
  final double otherAllowances;
  final double total;

  SalaryAllowances({
    required this.hra,
    required this.transportAllowance,
    required this.medicalAllowance,
    required this.otherAllowances,
    required this.total,
  });

  factory SalaryAllowances.fromJson(Map<String, dynamic> json) {
    return SalaryAllowances(
      hra: _toDouble(json['hra']),
      transportAllowance: _toDouble(json['transport_allowance']),
      medicalAllowance: _toDouble(json['medical_allowance']),
      otherAllowances: _toDouble(json['other_allowances']),
      total: _toDouble(json['total']),
    );
  }
}

class SalaryDeductions {
  final double pfDeduction;
  final double taxDeduction;
  final double otherDeductions;
  final double total;

  SalaryDeductions({
    required this.pfDeduction,
    required this.taxDeduction,
    required this.otherDeductions,
    required this.total,
  });

  factory SalaryDeductions.fromJson(Map<String, dynamic> json) {
    return SalaryDeductions(
      pfDeduction: _toDouble(json['pf_deduction']),
      taxDeduction: _toDouble(json['tax_deduction']),
      otherDeductions: _toDouble(json['other_deductions']),
      total: _toDouble(json['total']),
    );
  }
}

// ─── Salary Structure (used in Set, Update, Revise, History) ──────

class SalaryStructureModel {
  final int id;
  final String salaryType;
  final String calculationType;
  final double basicSalary;
  final SalaryAllowances allowances;
  final SalaryDeductions deductions;
  final double grossSalary;
  final double netSalary;
  final double otMultiplier;
  final String? effectiveFrom;
  final String? effectiveTo;
  final bool isCurrent;
  final String? revisionNote;

  SalaryStructureModel({
    required this.id,
    required this.salaryType,
    required this.calculationType,
    required this.basicSalary,
    required this.allowances,
    required this.deductions,
    required this.grossSalary,
    required this.netSalary,
    required this.otMultiplier,
    this.effectiveFrom,
    this.effectiveTo,
    required this.isCurrent,
    this.revisionNote,
  });

  factory SalaryStructureModel.fromJson(Map<String, dynamic> json) {
    return SalaryStructureModel(
      id: _toInt(json['id']),
      salaryType: json['salary_type'] ?? 'monthly',
      calculationType: json['calculation_type'] ?? 'monthly',
      basicSalary: _toDouble(json['basic_salary']),
      allowances: SalaryAllowances.fromJson(json['allowances'] ?? {}),
      deductions: SalaryDeductions.fromJson(json['deductions'] ?? {}),
      grossSalary: _toDouble(json['gross_salary']),
      netSalary: _toDouble(json['net_salary']),
      otMultiplier: _toDouble(json['ot_multiplier']),
      effectiveFrom: json['effective_from'],
      effectiveTo: json['effective_to'],
      isCurrent: json['is_current'] ?? false,
      revisionNote: json['revision_note'],
    );
  }
}

// ─── Salary History Response ──────────────────────────────────────

class SalaryHistoryEmployee {
  final int id;
  final String name;
  final String? employeeId;

  SalaryHistoryEmployee({
    required this.id,
    required this.name,
    this.employeeId,
  });

  factory SalaryHistoryEmployee.fromJson(Map<String, dynamic> json) {
    return SalaryHistoryEmployee(
      id: _toInt(json['id']),
      name: json['name'] ?? '',
      employeeId: json['employee_id'],
    );
  }
}

class SalaryHistoryModel {
  final SalaryHistoryEmployee employee;
  final int totalRevisions;
  final List<SalaryStructureModel> history;

  SalaryHistoryModel({
    required this.employee,
    required this.totalRevisions,
    required this.history,
  });

  factory SalaryHistoryModel.fromJson(Map<String, dynamic> json) {
    final historyList = json['history'] as List? ?? [];
    return SalaryHistoryModel(
      employee: SalaryHistoryEmployee.fromJson(json['employee'] ?? {}),
      totalRevisions: _toInt(json['total_revisions']),
      history: historyList
          .map((e) => SalaryStructureModel.fromJson(e))
          .toList(),
    );
  }
}

// ─── Salary Set / Update Response ─────────────────────────────────

class SalarySetResponse {
  final String message;
  final SalaryStructureModel data;

  SalarySetResponse({required this.message, required this.data});

  factory SalarySetResponse.fromJson(Map<String, dynamic> json) {
    return SalarySetResponse(
      message: json['message'] ?? '',
      data: SalaryStructureModel.fromJson(json['data'] ?? {}),
    );
  }
}

// ─── Salary Revise Response ───────────────────────────────────────

class SalaryReviseResponse {
  final String message;
  final SalaryStructureModel newSalary;
  final double oldNetSalary;
  final double newNetSalary;
  final double incrementAmount;
  final double incrementPct;

  SalaryReviseResponse({
    required this.message,
    required this.newSalary,
    required this.oldNetSalary,
    required this.newNetSalary,
    required this.incrementAmount,
    required this.incrementPct,
  });

  factory SalaryReviseResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return SalaryReviseResponse(
      message: json['message'] ?? '',
      newSalary: SalaryStructureModel.fromJson(data['new_salary'] ?? {}),
      oldNetSalary: _toDouble(data['old_net_salary']),
      newNetSalary: _toDouble(data['new_net_salary']),
      incrementAmount: _toDouble(data['increment_amount']),
      incrementPct: _toDouble(data['increment_pct']),
    );
  }
}

// ─── Payslip Models ───────────────────────────────────────────────

class PayslipInfo {
  final int payrollId;
  final String month;
  final String monthLabel;
  final String status;
  final String? processedAt;
  final String? paidAt;
  final String? processedBy;
  final String? notes;

  PayslipInfo({
    required this.payrollId,
    required this.month,
    required this.monthLabel,
    required this.status,
    this.processedAt,
    this.paidAt,
    this.processedBy,
    this.notes,
  });

  factory PayslipInfo.fromJson(Map<String, dynamic> json) {
    return PayslipInfo(
      payrollId: _toInt(json['payroll_id']),
      month: json['month'] ?? '',
      monthLabel: json['month_label'] ?? '',
      status: json['status'] ?? '',
      processedAt: json['processed_at'],
      paidAt: json['paid_at'],
      processedBy: json['processed_by'],
      notes: json['notes'],
    );
  }
}

class PayslipEmployee {
  final int id;
  final String name;
  final String? employeeId;
  final String? department;
  final String? branch;
  final String? designation;

  PayslipEmployee({
    required this.id,
    required this.name,
    this.employeeId,
    this.department,
    this.branch,
    this.designation,
  });

  factory PayslipEmployee.fromJson(Map<String, dynamic> json) {
    return PayslipEmployee(
      id: _toInt(json['id']),
      name: json['name'] ?? '',
      employeeId: json['employee_id'],
      department: json['department'],
      branch: json['branch'],
      designation: json['designation'],
    );
  }
}

class PayslipAttendanceSummary {
  final int totalWorkingDays;
  final int presentDays;
  final int leaveDays;
  final int absentDays;
  final String lateCount;
  final double overtimeHours;
  final double workedHours;

  PayslipAttendanceSummary({
    required this.totalWorkingDays,
    required this.presentDays,
    required this.leaveDays,
    required this.absentDays,
    required this.lateCount,
    required this.overtimeHours,
    required this.workedHours,
  });

  factory PayslipAttendanceSummary.fromJson(Map<String, dynamic> json) {
    return PayslipAttendanceSummary(
      totalWorkingDays: _toInt(json['total_working_days']),
      presentDays: _toInt(json['present_days']),
      leaveDays: _toInt(json['leave_days']),
      absentDays: _toInt(json['absent_days']),
      lateCount: json['late_count']?.toString() ?? '0',
      overtimeHours: _toDouble(json['overtime_hours']),
      workedHours: _toDouble(json['worked_hours']),
    );
  }
}

class PayslipEarnings {
  final double basic;
  final double hra;
  final double overtimePay;
  final double bonus;
  final double totalAllowances;
  final double grossPay;

  PayslipEarnings({
    required this.basic,
    required this.hra,
    required this.overtimePay,
    required this.bonus,
    required this.totalAllowances,
    required this.grossPay,
  });

  factory PayslipEarnings.fromJson(Map<String, dynamic> json) {
    return PayslipEarnings(
      basic: _toDouble(json['basic']),
      hra: _toDouble(json['hra']),
      overtimePay: _toDouble(json['overtime_pay']),
      bonus: _toDouble(json['bonus']),
      totalAllowances: _toDouble(json['total_allowances']),
      grossPay: _toDouble(json['gross_pay']),
    );
  }
}

class PayslipDeductions {
  final double lateDeduction;
  final double lopDeduction;
  final double totalDeductions;

  PayslipDeductions({
    required this.lateDeduction,
    required this.lopDeduction,
    required this.totalDeductions,
  });

  factory PayslipDeductions.fromJson(Map<String, dynamic> json) {
    return PayslipDeductions(
      lateDeduction: _toDouble(json['late_deduction']),
      lopDeduction: _toDouble(json['lop_deduction']),
      totalDeductions: _toDouble(json['total_deductions']),
    );
  }
}

class PayslipAdjustment {
  final int id;
  final String mode;
  final String type;
  final double amount;
  final String? description;

  PayslipAdjustment({
    required this.id,
    required this.mode,
    required this.type,
    required this.amount,
    this.description,
  });

  factory PayslipAdjustment.fromJson(Map<String, dynamic> json) {
    return PayslipAdjustment(
      id: _toInt(json['id']),
      mode: json['mode'] ?? '',
      type: json['type'] ?? '',
      amount: _toDouble(json['amount']),
      description: json['description'],
    );
  }
}

class PayslipModel {
  final PayslipInfo payslip;
  final PayslipEmployee employee;
  final PayslipAttendanceSummary attendanceSummary;
  final PayslipEarnings earnings;
  final PayslipDeductions deductions;
  final List<PayslipAdjustment> adjustments;
  final double netPay;
  final SalaryStructureModel salaryStructure;

  PayslipModel({
    required this.payslip,
    required this.employee,
    required this.attendanceSummary,
    required this.earnings,
    required this.deductions,
    required this.adjustments,
    required this.netPay,
    required this.salaryStructure,
  });

  factory PayslipModel.fromJson(Map<String, dynamic> json) {
    final adjustList = json['adjustments'] as List? ?? [];
    return PayslipModel(
      payslip: PayslipInfo.fromJson(json['payslip'] ?? {}),
      employee: PayslipEmployee.fromJson(json['employee'] ?? {}),
      attendanceSummary:
          PayslipAttendanceSummary.fromJson(json['attendance_summary'] ?? {}),
      earnings: PayslipEarnings.fromJson(json['earnings'] ?? {}),
      deductions: PayslipDeductions.fromJson(json['deductions'] ?? {}),
      adjustments:
          adjustList.map((e) => PayslipAdjustment.fromJson(e)).toList(),
      netPay: _toDouble(json['net_pay']),
      salaryStructure:
          SalaryStructureModel.fromJson(json['salary_structure'] ?? {}),
    );
  }
}

// ─── Helper functions ──────────────────────────────────────────────

int _toInt(dynamic val) {
  if (val == null) return 0;
  if (val is int) return val;
  if (val is double) return val.toInt();
  return int.tryParse(val.toString()) ?? 0;
}

double _toDouble(dynamic val) {
  if (val == null) return 0.0;
  if (val is double) return val;
  if (val is int) return val.toDouble();
  return double.tryParse(val.toString()) ?? 0.0;
}

// ─── Payroll Run / Process Models ─────────────────────────────────

class PayrollPreviewRecord {
  final int employeeId;
  final String employeeName;
  final double grossPay;
  final double totalDeductions;
  final double netPay;
  final SalaryStructureModel salaryStructure;

  PayrollPreviewRecord({
    required this.employeeId,
    required this.employeeName,
    required this.grossPay,
    required this.totalDeductions,
    required this.netPay,
    required this.salaryStructure,
  });

  factory PayrollPreviewRecord.fromJson(Map<String, dynamic> json) {
    final emp = json['employee'] ?? {};
    return PayrollPreviewRecord(
      employeeId: _toInt(emp['id']),
      employeeName: emp['name'] ?? '',
      grossPay: _toDouble(json['gross_pay']),
      totalDeductions: _toDouble(json['total_deductions']),
      netPay: _toDouble(json['net_pay']),
      salaryStructure: SalaryStructureModel.fromJson(json['salary_structure'] ?? {}),
    );
  }
}

class PayrollRunResponse {
  final String message;
  final int processedCount;
  final List<PayrollPreviewRecord> previews;
  final bool isFinal;

  PayrollRunResponse({
    required this.message,
    required this.processedCount,
    required this.previews,
    required this.isFinal,
  });

  factory PayrollRunResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final list = data['previews'] as List? ?? [];
    return PayrollRunResponse(
      message: json['message'] ?? '',
      processedCount: _toInt(data['processed_count']),
      previews: list.map((e) => PayrollPreviewRecord.fromJson(e)).toList(),
      isFinal: data['is_final'] ?? false,
    );
  }
}

class PayrollProcessResponse {
  final String message;
  final String month;
  final int processedRecords;
  final int skippedRecords;
  final double totalNetPayout;
  final bool alreadyExists;

  PayrollProcessResponse({
    required this.message,
    required this.month,
    required this.processedRecords,
    required this.skippedRecords,
    required this.totalNetPayout,
    required this.alreadyExists,
  });

  factory PayrollProcessResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return PayrollProcessResponse(
      message: json['message'] ?? '',
      month: data['month'] ?? '',
      processedRecords: _toInt(data['processed_records']),
      skippedRecords: _toInt(data['skipped_records']),
      totalNetPayout: _toDouble(data['total_net_payout']),
      alreadyExists: data['already_exists'] ?? false,
    );
  }
}
