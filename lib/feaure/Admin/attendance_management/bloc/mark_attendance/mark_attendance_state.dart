import 'package:equatable/equatable.dart';
import '../../data/model/manual_attendance_model.dart';
import '../../../employees_management/data/model/employee_model.dart';

abstract class MarkAttendanceState extends Equatable {
  const MarkAttendanceState();

  @override
  List<Object?> get props => [];
}

class MarkAttendanceInitial extends MarkAttendanceState {}

class MarkAttendanceLoading extends MarkAttendanceState {}

class MarkAttendanceDataLoaded extends MarkAttendanceState {
  final List<EmployeeModel> employees;
  final List<ShiftModel> shifts;

  const MarkAttendanceDataLoaded({required this.employees, required this.shifts});

  @override
  List<Object?> get props => [employees, shifts];
}

class MarkAttendanceSubmitting extends MarkAttendanceState {}

class MarkAttendanceSuccess extends MarkAttendanceState {
  final String message;

  const MarkAttendanceSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class MarkAttendanceError extends MarkAttendanceState {
  final String message;

  const MarkAttendanceError(this.message);

  @override
  List<Object?> get props => [message];
}
