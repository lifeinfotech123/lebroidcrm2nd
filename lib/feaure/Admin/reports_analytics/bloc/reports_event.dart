import 'package:equatable/equatable.dart';

abstract class ReportsEvent extends Equatable {
  const ReportsEvent();

  @override
  List<Object?> get props => [];
}

class FetchAttendanceReport extends ReportsEvent {
  final String? month;
  final int? branchId;
  final int? deptId;
  final int? userId;
  const FetchAttendanceReport({this.month, this.branchId, this.deptId, this.userId});
}

class FetchLeaveReport extends ReportsEvent {
  final String? month;
  final String? status;
  final int? typeId;
  const FetchLeaveReport({this.month, this.status, this.typeId});
}

class FetchPayrollReport extends ReportsEvent {
  final String? month;
  final String? status;
  final int? branchId;
  const FetchPayrollReport({this.month, this.status, this.branchId});
}

class FetchExpenseReport extends ReportsEvent {
  final String? month;
  final String? status;
  final int? categoryId;
  const FetchExpenseReport({this.month, this.status, this.categoryId});
}

class FetchTaskReport extends ReportsEvent {
  final String? month;
  final String? status;
  final String? priority;
  const FetchTaskReport({this.month, this.status, this.priority});
}

class FetchPerformanceReport extends ReportsEvent {
  final String? month;
  final String? year;
  const FetchPerformanceReport({this.month, this.year});
}
