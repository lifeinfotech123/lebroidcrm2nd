import 'package:equatable/equatable.dart';
import '../data/model/attendance_report_model.dart';
import '../data/model/expense_report_model.dart';
import '../data/model/leave_report_model.dart';
import '../data/model/payroll_report_model.dart';
import '../data/model/performance_report_model.dart';
import '../data/model/task_report_model.dart';


abstract class ReportsState extends Equatable {
  const ReportsState();
  @override
  List<Object?> get props => [];
}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {}

class AttendanceReportLoaded extends ReportsState {
  final AttendanceReportResponse report;
  const AttendanceReportLoaded(this.report);
  @override
  List<Object?> get props => [report];
}

class LeaveReportLoaded extends ReportsState {
  final List<LeaveReportModel> report;
  const LeaveReportLoaded(this.report);
  @override
  List<Object?> get props => [report];
}

class PayrollReportLoaded extends ReportsState {
  final PayrollReportResponse report;
  const PayrollReportLoaded(this.report);
  @override
  List<Object?> get props => [report];
}

class ExpenseReportLoaded extends ReportsState {
  final List<ExpenseReportModel> report;
  const ExpenseReportLoaded(this.report);
  @override
  List<Object?> get props => [report];
}

class TaskReportLoaded extends ReportsState {
  final List<TaskReportModel> report;
  const TaskReportLoaded(this.report);
  @override
  List<Object?> get props => [report];
}

class PerformanceReportLoaded extends ReportsState {
  final List<PerformanceReportModel> report;
  const PerformanceReportLoaded(this.report);
  @override
  List<Object?> get props => [report];
}

class ReportsError extends ReportsState {
  final String message;
  const ReportsError(this.message);
  @override
  List<Object?> get props => [message];
}
