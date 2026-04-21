import 'package:equatable/equatable.dart';
import '../../data/model/calendar_attendance_model.dart';
import '../../data/model/check_in_out_model.dart';

abstract class UserAttendanceState extends Equatable {
  const UserAttendanceState();

  @override
  List<Object?> get props => [];
}

class UserAttendanceInitial extends UserAttendanceState {}

// ── Calendar States ──

class CalendarLoading extends UserAttendanceState {}

class CalendarLoaded extends UserAttendanceState {
  final List<CalendarDayModel> calendarDays;

  const CalendarLoaded({required this.calendarDays});

  @override
  List<Object?> get props => [calendarDays];
}

class CalendarError extends UserAttendanceState {
  final String message;

  const CalendarError(this.message);

  @override
  List<Object?> get props => [message];
}

// ── Check-In States ──

class CheckInLoading extends UserAttendanceState {}

class CheckInSuccess extends UserAttendanceState {
  final CheckInResponse response;

  const CheckInSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

class CheckInError extends UserAttendanceState {
  final String message;

  const CheckInError(this.message);

  @override
  List<Object?> get props => [message];
}

// ── Check-Out States ──

class CheckOutLoading extends UserAttendanceState {}

class CheckOutSuccess extends UserAttendanceState {
  final CheckOutResponse response;

  const CheckOutSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

class CheckOutError extends UserAttendanceState {
  final String message;

  const CheckOutError(this.message);

  @override
  List<Object?> get props => [message];
}
