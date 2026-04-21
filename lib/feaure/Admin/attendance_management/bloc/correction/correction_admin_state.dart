import 'package:equatable/equatable.dart';
import '../../data/model/attendance_model.dart';

abstract class CorrectionAdminState extends Equatable {
  const CorrectionAdminState();

  @override
  List<Object?> get props => [];
}

class CorrectionAdminInitial extends CorrectionAdminState {}

class CorrectionAdminLoading extends CorrectionAdminState {}

class CorrectionAdminLoaded extends CorrectionAdminState {
  final List<AttendanceModel> requests;
  const CorrectionAdminLoaded(this.requests);

  @override
  List<Object?> get props => [requests];
}

class CorrectionAdminProcessing extends CorrectionAdminState {
  final int attendanceId;
  const CorrectionAdminProcessing(this.attendanceId);

  @override
  List<Object?> get props => [attendanceId];
}

class CorrectionAdminSuccess extends CorrectionAdminState {
  final String message;
  const CorrectionAdminSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class CorrectionAdminError extends CorrectionAdminState {
  final String message;
  const CorrectionAdminError(this.message);

  @override
  List<Object?> get props => [message];
}
