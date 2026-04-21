import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/employees_management/data/repository/employee_repository.dart';
import '../data/model/employee_model.dart';
import 'employee_event.dart';
import 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeRepository employeeRepository;

  EmployeeBloc({required this.employeeRepository}) : super(EmployeeInitial()) {
    on<LoadEmployeesEvent>(_onLoadEmployees);
    on<LoadMoreEmployeesEvent>(_onLoadMoreEmployees);
    on<FetchSingleEmployeeEvent>(_onFetchSingleEmployee);
    on<AddEmployeeEvent>(_onAddEmployee);
    on<UpdateEmployeeEvent>(_onUpdateEmployee);
    on<DeleteEmployeeEvent>(_onDeleteEmployee);
  }

  Future<void> _onLoadEmployees(
    LoadEmployeesEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoading());
    try {
      final result = await employeeRepository.getAllEmployees(page: 1);
      final employees = result['employees'] as List<EmployeeModel>;
      final lastPage = result['lastPage'] as int;
      emit(EmployeeLoaded(
        employees: employees,
        currentPage: 1,
        hasMore: 1 < lastPage,
      ));
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }

  Future<void> _onLoadMoreEmployees(
    LoadMoreEmployeesEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    final currentState = state;
    if (currentState is EmployeeLoaded && !currentState.isLoadingMore && currentState.hasMore) {
      emit(currentState.copyWith(isLoadingMore: true));
      try {
        final nextPage = currentState.currentPage + 1;
        final result = await employeeRepository.getAllEmployees(page: nextPage);
        final newEmployees = result['employees'] as List<EmployeeModel>;
        final lastPage = result['lastPage'] as int;

        emit(EmployeeLoaded(
          employees: [...currentState.employees, ...newEmployees],
          currentPage: nextPage,
          hasMore: nextPage < lastPage,
          isLoadingMore: false,
        ));
      } catch (e) {
        emit(currentState.copyWith(isLoadingMore: false));
      }
    }
  }

  Future<void> _onFetchSingleEmployee(
    FetchSingleEmployeeEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoading());
    try {
      final employee = await employeeRepository.getSingleEmployee(event.id);
      emit(SingleEmployeeLoaded(employee));
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }

  Future<void> _onAddEmployee(
    AddEmployeeEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoading());
    try {
      await employeeRepository.createEmployee(event.employeeData);
      emit(const EmployeeOperationSuccess('Employee created successfully.'));
      add(LoadEmployeesEvent());
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }

  Future<void> _onUpdateEmployee(
    UpdateEmployeeEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoading());
    try {
      await employeeRepository.updateEmployee(event.id, event.employeeData);
      emit(const EmployeeOperationSuccess('Employee updated successfully.'));
      add(LoadEmployeesEvent());
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }

  Future<void> _onDeleteEmployee(
    DeleteEmployeeEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoading());
    try {
      await employeeRepository.deleteEmployee(event.employeeId);
      emit(const EmployeeOperationSuccess('Employee deleted successfully.'));
      add(LoadEmployeesEvent());
    } catch (e) {
      emit(EmployeeError(e.toString()));
    }
  }
}
