import 'package:equatable/equatable.dart';
// import '../data/model/attendance_model.dart';
// import '../data/model/attendance_summary_model.dart';

abstract class EmployeeAttendanceEvent extends Equatable {
  const EmployeeAttendanceEvent();

  @override
  List<Object?> get props => [];
}

class FetchEmployeeAttendances extends EmployeeAttendanceEvent {}
