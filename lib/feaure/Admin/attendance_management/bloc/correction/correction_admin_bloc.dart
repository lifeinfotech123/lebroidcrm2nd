import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/attendance_model.dart';
import '../../data/repository/employee_attendance_repository.dart';
import 'correction_admin_event.dart';
import 'correction_admin_state.dart';

class CorrectionAdminBloc extends Bloc<CorrectionAdminEvent, CorrectionAdminState> {
  final EmployeeAttendanceRepository repository;

  CorrectionAdminBloc({required this.repository}) : super(CorrectionAdminInitial()) {
    on<FetchCorrectionRequests>(_onFetch);
    on<ProcessCorrectionRequest>(_onProcess);
  }

  Future<void> _onFetch(
    FetchCorrectionRequests event,
    Emitter<CorrectionAdminState> emit,
  ) async {
    emit(CorrectionAdminLoading());
    try {
      final requests = await repository.getCorrectionRequests();
      emit(CorrectionAdminLoaded(requests));
    } catch (e) {
      emit(CorrectionAdminError(e.toString()));
    }
  }

  Future<void> _onProcess(
    ProcessCorrectionRequest event,
    Emitter<CorrectionAdminState> emit,
  ) async {
    // Save current list to restore if needed or just show loading on item
    final currentRequests = state is CorrectionAdminLoaded ? (state as CorrectionAdminLoaded).requests : <AttendanceModel>[];
    emit(CorrectionAdminProcessing(event.attendanceId));
    try {
      final data = {
        'action': event.action,
        'note': event.note,
      };
      await repository.processCorrection(event.attendanceId, data);
      emit(CorrectionAdminSuccess('Correction ${event.action} successfully.'));
      // Refresh list
      add(FetchCorrectionRequests());
    } catch (e) {
      emit(CorrectionAdminError(e.toString()));
      emit(CorrectionAdminLoaded(currentRequests));
    }
  }
}

