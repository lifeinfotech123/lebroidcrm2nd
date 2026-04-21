import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/employee_attendance_repository.dart';
import '../../../employees_management/data/repository/employee_repository.dart';
import '../../../employees_management/data/model/employee_model.dart';
import '../../data/model/manual_attendance_model.dart';
import 'mark_attendance_event.dart';
import 'mark_attendance_state.dart';

class MarkAttendanceBloc extends Bloc<MarkAttendanceEvent, MarkAttendanceState> {
  final EmployeeAttendanceRepository attendanceRepository;
  final EmployeeRepository employeeRepository;

  MarkAttendanceBloc({
    required this.attendanceRepository,
    required this.employeeRepository,
  }) : super(MarkAttendanceInitial()) {
    on<FetchMarkAttendanceInitialData>(_onFetchInitialData);
    on<SubmitManualAttendance>(_onSubmitManualAttendance);
  }

  Future<void> _onFetchInitialData(
    FetchMarkAttendanceInitialData event,
    Emitter<MarkAttendanceState> emit,
  ) async {
    emit(MarkAttendanceLoading());
    try {
      final result = await employeeRepository.getAllEmployees();
      final employees = result['employees'] as List<EmployeeModel>;
      final shifts = await attendanceRepository.getShifts();
      emit(MarkAttendanceDataLoaded(employees: employees, shifts: shifts));
    } catch (e) {
      emit(MarkAttendanceError('Failed to load initial data: ${e.toString()}'));
    }
  }

  Future<void> _onSubmitManualAttendance(
    SubmitManualAttendance event,
    Emitter<MarkAttendanceState> emit,
  ) async {
    emit(MarkAttendanceSubmitting());
    try {
      final request = ManualAttendanceRequest(
        userId: event.userId,
        date: event.date,
        checkIn: event.checkIn,
        checkOut: event.checkOut,
        status: event.status,
        reason: event.reason,
        shiftId: event.shiftId,
      );
      final response = await attendanceRepository.markAttendanceManually(request);
      if (response.success) {
        emit(MarkAttendanceSuccess(response.message));
      } else {
        emit(MarkAttendanceError(response.message));
      }
    } catch (e) {
      emit(MarkAttendanceError(e.toString()));
    }
  }
}
