import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repository/reports_repository.dart';
import 'reports_event.dart';
import 'reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  final ReportsRepository reportsRepository;

  ReportsBloc({required this.reportsRepository}) : super(ReportsInitial()) {
    on<FetchAttendanceReport>(_onFetchAttendance);
    on<FetchLeaveReport>(_onFetchLeave);
    on<FetchPayrollReport>(_onFetchPayroll);
    on<FetchExpenseReport>(_onFetchExpense);
    on<FetchTaskReport>(_onFetchTask);
    on<FetchPerformanceReport>(_onFetchPerformance);
  }

  Future<void> _onFetchAttendance(FetchAttendanceReport event, Emitter<ReportsState> emit) async {
    try {
      emit(ReportsLoading());
      final report = await reportsRepository.getAttendanceReport(
        month: event.month,
        branchId: event.branchId,
        deptId: event.deptId,
        userId: event.userId,
      );
      emit(AttendanceReportLoaded(report));
    } catch (e) {
      emit(ReportsError(e.toString()));
    }
  }

  Future<void> _onFetchLeave(FetchLeaveReport event, Emitter<ReportsState> emit) async {
    try {
      emit(ReportsLoading());
      final report = await reportsRepository.getLeaveReport(
        month: event.month,
        status: event.status,
        typeId: event.typeId,
      );
      emit(LeaveReportLoaded(report));
    } catch (e) {
      emit(ReportsError(e.toString()));
    }
  }

  Future<void> _onFetchPayroll(FetchPayrollReport event, Emitter<ReportsState> emit) async {
    try {
      emit(ReportsLoading());
      final report = await reportsRepository.getPayrollReport(
        month: event.month,
        status: event.status,
        branchId: event.branchId,
      );
      emit(PayrollReportLoaded(report));
    } catch (e) {
      emit(ReportsError(e.toString()));
    }
  }

  Future<void> _onFetchExpense(FetchExpenseReport event, Emitter<ReportsState> emit) async {
    try {
      emit(ReportsLoading());
      final report = await reportsRepository.getExpenseReport(
        month: event.month,
        status: event.status,
        categoryId: event.categoryId,
      );
      emit(ExpenseReportLoaded(report));
    } catch (e) {
      emit(ReportsError(e.toString()));
    }
  }

  Future<void> _onFetchTask(FetchTaskReport event, Emitter<ReportsState> emit) async {
    try {
      emit(ReportsLoading());
      final report = await reportsRepository.getTaskReport(
        month: event.month,
        status: event.status,
        priority: event.priority,
      );
      emit(TaskReportLoaded(report));
    } catch (e) {
      emit(ReportsError(e.toString()));
    }
  }

  Future<void> _onFetchPerformance(FetchPerformanceReport event, Emitter<ReportsState> emit) async {
    try {
      emit(ReportsLoading());
      final report = await reportsRepository.getPerformanceReport(
        month: event.month,
        year: event.year,
      );
      emit(PerformanceReportLoaded(report));
    } catch (e) {
      emit(ReportsError(e.toString()));
    }
  }
}
