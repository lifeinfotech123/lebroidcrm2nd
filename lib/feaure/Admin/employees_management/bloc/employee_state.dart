import 'package:equatable/equatable.dart';
import 'package:lebroid_crm/feaure/Admin/employees_management/data/model/employee_model.dart';

abstract class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object?> get props => [];
}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeLoaded extends EmployeeState {
  final List<EmployeeModel> employees;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;

  const EmployeeLoaded({
    required this.employees,
    this.currentPage = 1,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  EmployeeLoaded copyWith({
    List<EmployeeModel>? employees,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return EmployeeLoaded(
      employees: employees ?? this.employees,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [employees, currentPage, hasMore, isLoadingMore];
}

class SingleEmployeeLoaded extends EmployeeState {
  final EmployeeModel employee;
  const SingleEmployeeLoaded(this.employee);

  @override
  List<Object?> get props => [employee];
}

class EmployeeOperationSuccess extends EmployeeState {
  final String message;
  const EmployeeOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class EmployeeError extends EmployeeState {
  final String message;
  const EmployeeError(this.message);

  @override
  List<Object?> get props => [message];
}
