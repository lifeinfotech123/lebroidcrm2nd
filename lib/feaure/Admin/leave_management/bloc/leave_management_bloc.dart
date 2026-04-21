import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repository/leave_repository.dart';
import 'leave_management_event.dart';
import 'leave_management_state.dart';

class LeaveManagementBloc extends Bloc<LeaveManagementEvent, LeaveManagementState> {
  final LeaveRepository leaveRepository;

  LeaveManagementBloc({required this.leaveRepository}) : super(const LeaveManagementState()) {
    on<FetchLeaveRequests>(_onFetchLeaveRequests);
    on<ApplyLeaveRequest>(_onApplyLeaveRequest);
    on<ApproveLeaveRequest>(_onApproveLeaveRequest);
    on<CancelLeaveRequest>(_onCancelLeaveRequest);
    on<FetchLeaveBalance>(_onFetchLeaveBalance);
  }

  Future<void> _onFetchLeaveRequests(
    FetchLeaveRequests event,
    Emitter<LeaveManagementState> emit,
  ) async {
    emit(state.copyWith(status: LeaveManagementStatus.loading));
    try {
      final leaves = await leaveRepository.getLeaves(status: event.status, year: event.year);
      emit(state.copyWith(status: LeaveManagementStatus.success, leaves: leaves));
    } catch (e) {
      emit(state.copyWith(status: LeaveManagementStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onApplyLeaveRequest(
    ApplyLeaveRequest event,
    Emitter<LeaveManagementState> emit,
  ) async {
    emit(state.copyWith(status: LeaveManagementStatus.loading));
    try {
      await leaveRepository.applyLeave(event.leave);
      emit(state.copyWith(status: LeaveManagementStatus.actionSuccess));
    } catch (e) {
      emit(state.copyWith(status: LeaveManagementStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onApproveLeaveRequest(
    ApproveLeaveRequest event,
    Emitter<LeaveManagementState> emit,
  ) async {
    emit(state.copyWith(status: LeaveManagementStatus.loading));
    try {
      await leaveRepository.approveLeave(event.id, event.remarks);
      emit(state.copyWith(status: LeaveManagementStatus.actionSuccess));
      add(FetchLeaveRequests()); // Refresh list
    } catch (e) {
      emit(state.copyWith(status: LeaveManagementStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onCancelLeaveRequest(
    CancelLeaveRequest event,
    Emitter<LeaveManagementState> emit,
  ) async {
    emit(state.copyWith(status: LeaveManagementStatus.loading));
    try {
      await leaveRepository.cancelLeave(event.id);
      emit(state.copyWith(status: LeaveManagementStatus.actionSuccess));
      add(FetchLeaveRequests()); // Refresh list
    } catch (e) {
      emit(state.copyWith(status: LeaveManagementStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onFetchLeaveBalance(
    FetchLeaveBalance event,
    Emitter<LeaveManagementState> emit,
  ) async {
    emit(state.copyWith(status: LeaveManagementStatus.loading));
    try {
      final balances = await leaveRepository.getLeaveBalance();
      emit(state.copyWith(status: LeaveManagementStatus.success, balances: balances));
    } catch (e) {
      emit(state.copyWith(status: LeaveManagementStatus.failure, errorMessage: e.toString()));
    }
  }
}
