import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repository/employee_attendance_repository.dart';
import 'correction_request_event.dart';
import 'correction_request_state.dart';

class CorrectionRequestBloc extends Bloc<CorrectionRequestEvent, CorrectionRequestState> {
  final EmployeeAttendanceRepository repository;

  CorrectionRequestBloc({required this.repository}) : super(CorrectionRequestInitial()) {
    on<SubmitCorrectionRequest>(_onSubmit);
  }

  Future<void> _onSubmit(
    SubmitCorrectionRequest event,
    Emitter<CorrectionRequestState> emit,
  ) async {
    emit(CorrectionRequestSubmitting());
    try {
      final data = {
        'requested_check_in': event.requestedCheckIn,
        'requested_check_out': event.requestedCheckOut,
        'reason': event.reason,
      };
      await repository.requestCorrection(event.attendanceId, data);
      emit(const CorrectionRequestSuccess('Correction requested successfully.'));
    } catch (e) {
      emit(CorrectionRequestError(e.toString()));
    }
  }
}
