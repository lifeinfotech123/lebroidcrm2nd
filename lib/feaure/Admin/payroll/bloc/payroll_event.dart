import '../data/model/payroll_model.dart';

abstract class PayrollEvent {}

class FetchPayrollData extends PayrollEvent {
  final String? month;
  final String? status;
  final String? search;

  FetchPayrollData({this.month, this.status, this.search});
}

class GeneratePayrollPreview extends PayrollEvent {
  final String month;
  final String? branchId;
  final String? deptId;

  GeneratePayrollPreview({required this.month, this.branchId, this.deptId});
}

class ProcessPayrollEvent extends PayrollEvent {
  final String month;
  final List<PayrollPreviewModel> previews;

  ProcessPayrollEvent({required this.month, required this.previews});
}
