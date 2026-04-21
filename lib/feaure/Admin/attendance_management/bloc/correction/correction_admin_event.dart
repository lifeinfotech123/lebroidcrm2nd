import 'package:equatable/equatable.dart';

abstract class CorrectionAdminEvent extends Equatable {
  const CorrectionAdminEvent();

  @override
  List<Object?> get props => [];
}

class FetchCorrectionRequests extends CorrectionAdminEvent {}

class ProcessCorrectionRequest extends CorrectionAdminEvent {
  final int attendanceId;
  final String action; // 'approved' or 'rejected'
  final String note;

  const ProcessCorrectionRequest({
    required this.attendanceId,
    required this.action,
    required this.note,
  });

  @override
  List<Object?> get props => [attendanceId, action, note];
}
