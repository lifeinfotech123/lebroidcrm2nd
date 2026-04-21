import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repository/leave_repository.dart';
import 'leave_type_event.dart';
import 'leave_type_state.dart';

class LeaveTypeBloc extends Bloc<LeaveTypeEvent, LeaveTypeState> {
  final LeaveRepository leaveRepository;

  LeaveTypeBloc({required this.leaveRepository}) : super(const LeaveTypeState()) {
    on<FetchLeaveTypes>(_onFetchLeaveTypes);
    on<CreateLeaveType>(_onCreateLeaveType);
    on<UpdateLeaveType>(_onUpdateLeaveType);
    on<DeleteLeaveType>(_onDeleteLeaveType);
  }

  Future<void> _onFetchLeaveTypes(
    FetchLeaveTypes event,
    Emitter<LeaveTypeState> emit,
  ) async {
    emit(state.copyWith(status: LeaveTypeStatus.loading));
    try {
      final leaveTypes = await leaveRepository.getLeaveTypes();
      emit(state.copyWith(
        status: LeaveTypeStatus.success,
        leaveTypes: leaveTypes,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: LeaveTypeStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onCreateLeaveType(
    CreateLeaveType event,
    Emitter<LeaveTypeState> emit,
  ) async {
    emit(state.copyWith(status: LeaveTypeStatus.loading));
    try {
      await leaveRepository.createLeaveType(event.leaveType);
      emit(state.copyWith(status: LeaveTypeStatus.actionSuccess));
      add(FetchLeaveTypes());
    } catch (e) {
      emit(state.copyWith(
        status: LeaveTypeStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateLeaveType(
    UpdateLeaveType event,
    Emitter<LeaveTypeState> emit,
  ) async {
    emit(state.copyWith(status: LeaveTypeStatus.loading));
    try {
      await leaveRepository.updateLeaveType(event.id, event.data);
      emit(state.copyWith(status: LeaveTypeStatus.actionSuccess));
      add(FetchLeaveTypes());
    } catch (e) {
      emit(state.copyWith(
        status: LeaveTypeStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onDeleteLeaveType(
    DeleteLeaveType event,
    Emitter<LeaveTypeState> emit,
  ) async {
    emit(state.copyWith(status: LeaveTypeStatus.loading));
    try {
      await leaveRepository.deleteLeaveType(event.id);
      emit(state.copyWith(status: LeaveTypeStatus.actionSuccess));
      add(FetchLeaveTypes());
    } catch (e) {
      emit(state.copyWith(
        status: LeaveTypeStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
