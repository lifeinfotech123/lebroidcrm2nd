import 'package:equatable/equatable.dart';

import '../../data/model/attendance_model.dart';
import '../../data/model/attendance_summary_model.dart';
// import '../data/model/attendance_model.dart';
// import '../data/model/attendance_summary_model.dart';

abstract class EmployeeAttendanceState extends Equatable {
  const EmployeeAttendanceState();

  @override
  List<Object?> get props => [];
}

class EmployeeAttendanceInitial extends EmployeeAttendanceState {}

class EmployeeAttendanceLoading extends EmployeeAttendanceState {}

class EmployeeAttendanceLoaded extends EmployeeAttendanceState {
  final List<AttendanceModel> attendances;
  final AttendanceSummaryModel summary;

  const EmployeeAttendanceLoaded({required this.attendances, required this.summary});

  @override
  List<Object?> get props => [attendances, summary];
}

class EmployeeAttendanceError extends EmployeeAttendanceState {
  final String message;

  const EmployeeAttendanceError(this.message);

  @override
  List<Object?> get props => [message];
}
