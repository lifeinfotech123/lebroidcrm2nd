import 'package:equatable/equatable.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object?> get props => [];
}

class LoadEmployeesEvent extends EmployeeEvent {}

class LoadMoreEmployeesEvent extends EmployeeEvent {}

class FetchSingleEmployeeEvent extends EmployeeEvent {
  final int id;
  const FetchSingleEmployeeEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class AddEmployeeEvent extends EmployeeEvent {
  final Map<String, dynamic> employeeData;
  const AddEmployeeEvent(this.employeeData);

  @override
  List<Object?> get props => [employeeData];
}

class UpdateEmployeeEvent extends EmployeeEvent {
  final int id;
  final Map<String, dynamic> employeeData;
  const UpdateEmployeeEvent(this.id, this.employeeData);

  @override
  List<Object?> get props => [id, employeeData];
}

class DeleteEmployeeEvent extends EmployeeEvent {
  final int employeeId;
  const DeleteEmployeeEvent(this.employeeId);

  @override
  List<Object?> get props => [employeeId];
}
