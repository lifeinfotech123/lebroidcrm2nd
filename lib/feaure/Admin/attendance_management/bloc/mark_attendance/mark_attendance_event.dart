import 'package:equatable/equatable.dart';

abstract class MarkAttendanceEvent extends Equatable {
  const MarkAttendanceEvent();

  @override
  List<Object?> get props => [];
}

class FetchMarkAttendanceInitialData extends MarkAttendanceEvent {}

class SubmitManualAttendance extends MarkAttendanceEvent {
  final int userId;
  final String date;
  final String checkIn;
  final String checkOut;
  final String status;
  final String reason;
  final int shiftId;

  const SubmitManualAttendance({
    required this.userId,
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.status,
    required this.reason,
    required this.shiftId,
  });

  @override
  List<Object?> get props => [userId, date, checkIn, checkOut, status, reason, shiftId];
}
