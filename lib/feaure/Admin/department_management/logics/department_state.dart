import 'package:equatable/equatable.dart';
import 'package:lebroid_crm/feaure/Admin/department_management/data/model/department_model.dart';

abstract class DepartmentState extends Equatable {
  const DepartmentState();

  @override
  List<Object?> get props => [];
}

class DepartmentInitial extends DepartmentState {}

class DepartmentLoading extends DepartmentState {}

class DepartmentLoaded extends DepartmentState {
  final List<DepartmentModel> departments;
  const DepartmentLoaded(this.departments);

  @override
  List<Object?> get props => [departments];
}

class SingleDepartmentLoaded extends DepartmentState {
  final DepartmentModel department;
  const SingleDepartmentLoaded(this.department);

  @override
  List<Object?> get props => [department];
}

class DepartmentOperationSuccess extends DepartmentState {
  final String message;
  const DepartmentOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class DepartmentError extends DepartmentState {
  final String message;
  const DepartmentError(this.message);

  @override
  List<Object?> get props => [message];
}
