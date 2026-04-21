class ExpenseReportModel {
  final String? employeeId;
  final String? name;
  final String? department;
  final String? branch;
  final String? category;
  final String? amount;
  final String? expenseDate;
  final String? purpose;
  final String? status;
  final String? policyViolated;
  final String? approvedBy;
  final String? approvedAt;

  ExpenseReportModel({
    this.employeeId,
    this.name,
    this.department,
    this.branch,
    this.category,
    this.amount,
    this.expenseDate,
    this.purpose,
    this.status,
    this.policyViolated,
    this.approvedBy,
    this.approvedAt,
  });

  factory ExpenseReportModel.fromJson(Map<String, dynamic> json) {
    return ExpenseReportModel(
      employeeId: json['employee_id'],
      name: json['name'],
      department: json['department'],
      branch: json['branch'],
      category: json['category'],
      amount: json['amount'],
      expenseDate: json['expense_date'],
      purpose: json['purpose'],
      status: json['status'],
      policyViolated: json['policy_violated'],
      approvedBy: json['approved_by'],
      approvedAt: json['approved_at'],
    );
  }
}
