import '../data/model/salary_model.dart';

abstract class SalaryEvent {}

class FetchSalaryOverview extends SalaryEvent {}

class FetchSalaryHistory extends SalaryEvent {
  final int userId;
  FetchSalaryHistory({required this.userId});
}

class SetSalaryEvent extends SalaryEvent {
  final int userId;
  final Map<String, dynamic> body;
  SetSalaryEvent({required this.userId, required this.body});
}

class UpdateSalaryEvent extends SalaryEvent {
  final int userId;
  final Map<String, dynamic> body;
  UpdateSalaryEvent({required this.userId, required this.body});
}

class ReviseSalaryEvent extends SalaryEvent {
  final int userId;
  final Map<String, dynamic> body;
  ReviseSalaryEvent({required this.userId, required this.body});
}

class FetchPayslipEvent extends SalaryEvent {
  final int employeeId;
  FetchPayslipEvent({required this.employeeId});
}

class SalaryRunPayrollEvent extends SalaryEvent {
  final String month;
  final bool previewOnly;
  SalaryRunPayrollEvent({required this.month, this.previewOnly = true});
}

class SalaryProcessPayrollEvent extends SalaryEvent {
  final String month;
  final bool force;
  SalaryProcessPayrollEvent({required this.month, this.force = false});
}
