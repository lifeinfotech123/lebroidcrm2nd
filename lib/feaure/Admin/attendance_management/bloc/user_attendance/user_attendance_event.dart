import 'package:equatable/equatable.dart';

abstract class UserAttendanceEvent extends Equatable {
  const UserAttendanceEvent();

  @override
  List<Object?> get props => [];
}

/// Fetch calendar attendance for a user
class FetchCalendarAttendance extends UserAttendanceEvent {
  final int userId;

  const FetchCalendarAttendance({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// Check-in event with optional selfie and location
class CheckInEvent extends UserAttendanceEvent {
  final String? selfiePath;
  final double? latitude;
  final double? longitude;

  const CheckInEvent({this.selfiePath, this.latitude, this.longitude});

  @override
  List<Object?> get props => [selfiePath, latitude, longitude];
}

/// Check-out event
class CheckOutEvent extends UserAttendanceEvent {}
