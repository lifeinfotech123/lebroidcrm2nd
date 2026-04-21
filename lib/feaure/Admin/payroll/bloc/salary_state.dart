import '../data/model/salary_model.dart';

abstract class SalaryState {}

class SalaryInitial extends SalaryState {}

// ─── Overview states ──────────────────
class SalaryOverviewLoading extends SalaryState {}

class SalaryOverviewLoaded extends SalaryState {
  final SalaryOverviewModel overview;
  SalaryOverviewLoaded(this.overview);
}

class SalaryOverviewError extends SalaryState {
  final String message;
  SalaryOverviewError(this.message);
}

// ─── History states ───────────────────
class SalaryHistoryLoading extends SalaryState {}

class SalaryHistoryLoaded extends SalaryState {
  final SalaryHistoryModel history;
  SalaryHistoryLoaded(this.history);
}

class SalaryHistoryError extends SalaryState {
  final String message;
  SalaryHistoryError(this.message);
}

// ─── Set / Update / Revise states ─────
class SalarySaving extends SalaryState {}

class SalarySaved extends SalaryState {
  final String message;
  SalarySaved(this.message);
}

class SalarySaveError extends SalaryState {
  final String message;
  SalarySaveError(this.message);
}

// ─── Payslip states ───────────────────
class PayslipLoading extends SalaryState {}

class PayslipLoaded extends SalaryState {
  final PayslipModel payslip;
  PayslipLoaded(this.payslip);
}

class PayslipError extends SalaryState {
  final String message;
  PayslipError(this.message);
}

// ─── Payroll Run states ────────────────
class SalaryPayrollPreviewLoading extends SalaryState {}

class SalaryPayrollPreviewLoaded extends SalaryState {
  final PayrollRunResponse response;
  SalaryPayrollPreviewLoaded(this.response);
}

class SalaryPayrollPreviewError extends SalaryState {
  final String message;
  SalaryPayrollPreviewError(this.message);
}

// ─── Payroll Process states ────────────
class SalaryPayrollProcessLoading extends SalaryState {}

class SalaryPayrollProcessSuccess extends SalaryState {
  final PayrollProcessResponse response;
  SalaryPayrollProcessSuccess(this.response);
}

class SalaryPayrollProcessError extends SalaryState {
  final String message;
  SalaryPayrollProcessError(this.message);
}
