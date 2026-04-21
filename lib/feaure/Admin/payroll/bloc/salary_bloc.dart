import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repository/salary_repository.dart';
import 'salary_event.dart';
import 'salary_state.dart';

class SalaryBloc extends Bloc<SalaryEvent, SalaryState> {
  final SalaryRepository _repository;

  SalaryBloc(this._repository) : super(SalaryInitial()) {
    on<FetchSalaryOverview>(_onFetchOverview);
    on<FetchSalaryHistory>(_onFetchHistory);
    on<SetSalaryEvent>(_onSetSalary);
    on<UpdateSalaryEvent>(_onUpdateSalary);
    on<ReviseSalaryEvent>(_onReviseSalary);
    on<FetchPayslipEvent>(_onFetchPayslip);
    on<SalaryRunPayrollEvent>(_onRunPayroll);
    on<SalaryProcessPayrollEvent>(_onProcessPayroll);
  }

  Future<void> _onFetchOverview(
    FetchSalaryOverview event,
    Emitter<SalaryState> emit,
  ) async {
    emit(SalaryOverviewLoading());
    try {
      final overview = await _repository.getSalaryOverview();
      emit(SalaryOverviewLoaded(overview));
    } catch (e) {
      emit(SalaryOverviewError(e.toString()));
    }
  }

  Future<void> _onFetchHistory(
    FetchSalaryHistory event,
    Emitter<SalaryState> emit,
  ) async {
    emit(SalaryHistoryLoading());
    try {
      final history = await _repository.getSalaryHistory(userId: event.userId);
      emit(SalaryHistoryLoaded(history));
    } catch (e) {
      emit(SalaryHistoryError(e.toString()));
    }
  }

  Future<void> _onSetSalary(
    SetSalaryEvent event,
    Emitter<SalaryState> emit,
  ) async {
    emit(SalarySaving());
    try {
      final response = await _repository.setSalary(
        userId: event.userId,
        body: event.body,
      );
      emit(SalarySaved(response.message));
    } catch (e) {
      emit(SalarySaveError(e.toString()));
    }
  }

  Future<void> _onUpdateSalary(
    UpdateSalaryEvent event,
    Emitter<SalaryState> emit,
  ) async {
    emit(SalarySaving());
    try {
      final response = await _repository.updateSalary(
        userId: event.userId,
        body: event.body,
      );
      emit(SalarySaved(response.message));
    } catch (e) {
      emit(SalarySaveError(e.toString()));
    }
  }

  Future<void> _onReviseSalary(
    ReviseSalaryEvent event,
    Emitter<SalaryState> emit,
  ) async {
    emit(SalarySaving());
    try {
      final response = await _repository.reviseSalary(
        userId: event.userId,
        body: event.body,
      );
      emit(SalarySaved(response.message));
    } catch (e) {
      emit(SalarySaveError(e.toString()));
    }
  }

  Future<void> _onFetchPayslip(
    FetchPayslipEvent event,
    Emitter<SalaryState> emit,
  ) async {
    emit(PayslipLoading());
    try {
      final payslip = await _repository.getPayslip(employeeId: event.employeeId);
      emit(PayslipLoaded(payslip));
    } catch (e) {
      emit(PayslipError(e.toString()));
    }
  }

  Future<void> _onRunPayroll(
    SalaryRunPayrollEvent event,
    Emitter<SalaryState> emit,
  ) async {
    emit(SalaryPayrollPreviewLoading());
    try {
      final response = await _repository.runPayroll(
        month: event.month,
        previewOnly: event.previewOnly,
      );
      emit(SalaryPayrollPreviewLoaded(response));
    } catch (e) {
      emit(SalaryPayrollPreviewError(e.toString()));
    }
  }

  Future<void> _onProcessPayroll(
    SalaryProcessPayrollEvent event,
    Emitter<SalaryState> emit,
  ) async {
    emit(SalaryPayrollProcessLoading());
    try {
      final response = await _repository.processPayroll(
        month: event.month,
        force: event.force,
      );
      emit(SalaryPayrollProcessSuccess(response));
    } catch (e) {
      emit(SalaryPayrollProcessError(e.toString()));
    }
  }
}
