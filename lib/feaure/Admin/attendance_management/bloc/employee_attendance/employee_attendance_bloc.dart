import 'package:bloc/bloc.dart';
import '../../data/model/attendance_summary_model.dart';
import '../../data/repository/employee_attendance_repository.dart';
import 'employee_attendance_event.dart';
import 'employee_attendance_state.dart';

class EmployeeAttendanceBloc extends Bloc<EmployeeAttendanceEvent, EmployeeAttendanceState> {
  final EmployeeAttendanceRepository repository;

  EmployeeAttendanceBloc({required this.repository}) : super(EmployeeAttendanceInitial()) {
    on<FetchEmployeeAttendances>(_onFetchEmployeeAttendances);
  }

  Future<void> _onFetchEmployeeAttendances(FetchEmployeeAttendances event, Emitter<EmployeeAttendanceState> emit) async {
    emit(EmployeeAttendanceLoading());
    try {
      final summaryResponse = await repository.getAttendanceSummary();
      final attendancesResponse = await repository.getAllAttendances();

      emit(EmployeeAttendanceLoaded(
        attendances: attendancesResponse.data?.data ?? [],
        summary: summaryResponse.data ?? AttendanceSummaryModel(), // Default if null
      ));
    } catch (e) {
      emit(EmployeeAttendanceError(e.toString()));
    }
  }
}
