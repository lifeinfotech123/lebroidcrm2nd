import 'package:bloc/bloc.dart';
import '../../data/repository/employee_attendance_repository.dart';
import 'user_attendance_event.dart';
import 'user_attendance_state.dart';

class UserAttendanceBloc extends Bloc<UserAttendanceEvent, UserAttendanceState> {
  final EmployeeAttendanceRepository repository;

  UserAttendanceBloc({required this.repository}) : super(UserAttendanceInitial()) {
    on<FetchCalendarAttendance>(_onFetchCalendar);
    on<CheckInEvent>(_onCheckIn);
    on<CheckOutEvent>(_onCheckOut);
  }

  Future<void> _onFetchCalendar(
    FetchCalendarAttendance event,
    Emitter<UserAttendanceState> emit,
  ) async {
    emit(CalendarLoading());
    try {
      final response = await repository.getCalendarAttendance(event.userId);
      emit(CalendarLoaded(calendarDays: response.data?.calendar ?? []));
    } catch (e) {
      emit(CalendarError(e.toString()));
    }
  }

  Future<void> _onCheckIn(
    CheckInEvent event,
    Emitter<UserAttendanceState> emit,
  ) async {
    emit(CheckInLoading());
    try {
      final response = await repository.checkIn(
        selfiePath: event.selfiePath,
        latitude: event.latitude,
        longitude: event.longitude,
      );
      emit(CheckInSuccess(response: response));
    } catch (e) {
      emit(CheckInError(e.toString()));
    }
  }

  Future<void> _onCheckOut(
    CheckOutEvent event,
    Emitter<UserAttendanceState> emit,
  ) async {
    emit(CheckOutLoading());
    try {
      final response = await repository.checkOut();
      emit(CheckOutSuccess(response: response));
    } catch (e) {
      emit(CheckOutError(e.toString()));
    }
  }
}
