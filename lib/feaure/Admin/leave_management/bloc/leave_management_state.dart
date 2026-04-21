import 'package:equatable/equatable.dart';
import '../data/model/leave_model.dart';
import '../data/model/leave_balance_model.dart';

enum LeaveManagementStatus { initial, loading, success, failure, actionSuccess }

class LeaveManagementState extends Equatable {
  final List<LeaveModel> leaves;
  final List<LeaveBalanceModel> balances;
  final LeaveManagementStatus status;
  final String? errorMessage;

  const LeaveManagementState({
    this.leaves = const [],
    this.balances = const [],
    this.status = LeaveManagementStatus.initial,
    this.errorMessage,
  });

  LeaveManagementState copyWith({
    List<LeaveModel>? leaves,
    List<LeaveBalanceModel>? balances,
    LeaveManagementStatus? status,
    String? errorMessage,
  }) {
    return LeaveManagementState(
      leaves: leaves ?? this.leaves,
      balances: balances ?? this.balances,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [leaves, balances, status, errorMessage];
}
