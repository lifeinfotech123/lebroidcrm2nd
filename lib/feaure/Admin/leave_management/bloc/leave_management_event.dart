import 'package:equatable/equatable.dart';
import '../data/model/leave_model.dart';

abstract class LeaveManagementEvent extends Equatable {
  const LeaveManagementEvent();

  @override
  List<Object?> get props => [];
}

class FetchLeaveRequests extends LeaveManagementEvent {
  final String? status;
  final int? year;

  const FetchLeaveRequests({this.status, this.year});

  @override
  List<Object?> get props => [status, year];
}

class ApplyLeaveRequest extends LeaveManagementEvent {
  final LeaveModel leave;
  const ApplyLeaveRequest(this.leave);

  @override
  List<Object?> get props => [leave];
}

class ApproveLeaveRequest extends LeaveManagementEvent {
  final int id;
  final String remarks;
  const ApproveLeaveRequest(this.id, this.remarks);

  @override
  List<Object?> get props => [id, remarks];
}

class CancelLeaveRequest extends LeaveManagementEvent {
  final int id;
  const CancelLeaveRequest(this.id);

  @override
  List<Object?> get props => [id];
}

class FetchLeaveBalance extends LeaveManagementEvent {}
