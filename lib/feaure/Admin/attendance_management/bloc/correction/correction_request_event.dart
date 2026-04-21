import 'package:equatable/equatable.dart';

abstract class CorrectionRequestEvent extends Equatable {
  const CorrectionRequestEvent();

  @override
  List<Object?> get props => [];
}

class SubmitCorrectionRequest extends CorrectionRequestEvent {
  final String attendanceId;
  final String requestedCheckIn;
  final String requestedCheckOut;
  final String reason;

  const SubmitCorrectionRequest({
    required this.attendanceId,
    required this.requestedCheckIn,
    required this.requestedCheckOut,
    required this.reason,
  });

  @override
  List<Object?> get props => [attendanceId, requestedCheckIn, requestedCheckOut, reason];
}
