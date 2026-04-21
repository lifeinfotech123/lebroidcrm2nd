import 'package:equatable/equatable.dart';
import '../data/model/leave_type_model.dart';

abstract class LeaveTypeEvent extends Equatable {
  const LeaveTypeEvent();

  @override
  List<Object?> get props => [];
}

class FetchLeaveTypes extends LeaveTypeEvent {}

class CreateLeaveType extends LeaveTypeEvent {
  final LeaveTypeModel leaveType;
  const CreateLeaveType(this.leaveType);

  @override
  List<Object?> get props => [leaveType];
}

class UpdateLeaveType extends LeaveTypeEvent {
  final int id;
  final Map<String, dynamic> data;
  const UpdateLeaveType(this.id, this.data);

  @override
  List<Object?> get props => [id, data];
}

class DeleteLeaveType extends LeaveTypeEvent {
  final int id;
  const DeleteLeaveType(this.id);

  @override
  List<Object?> get props => [id];
}
