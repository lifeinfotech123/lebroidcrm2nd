import 'package:equatable/equatable.dart';
import '../data/model/leave_type_model.dart';

enum LeaveTypeStatus { initial, loading, success, failure, actionSuccess }

class LeaveTypeState extends Equatable {
  final List<LeaveTypeModel> leaveTypes;
  final LeaveTypeStatus status;
  final String? errorMessage;

  const LeaveTypeState({
    this.leaveTypes = const [],
    this.status = LeaveTypeStatus.initial,
    this.errorMessage,
  });

  LeaveTypeState copyWith({
    List<LeaveTypeModel>? leaveTypes,
    LeaveTypeStatus? status,
    String? errorMessage,
  }) {
    return LeaveTypeState(
      leaveTypes: leaveTypes ?? this.leaveTypes,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [leaveTypes, status, errorMessage];
}
