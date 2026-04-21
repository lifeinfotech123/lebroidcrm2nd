import 'package:equatable/equatable.dart';

abstract class DepartmentEvent extends Equatable {
  const DepartmentEvent();

  @override
  List<Object?> get props => [];
}

class LoadDepartmentsEvent extends DepartmentEvent {}

class FetchSingleDepartmentEvent extends DepartmentEvent {
  final int id;
  const FetchSingleDepartmentEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class AddDepartmentEvent extends DepartmentEvent {
  final Map<String, dynamic> departmentData;
  const AddDepartmentEvent(this.departmentData);

  @override
  List<Object?> get props => [departmentData];
}

class UpdateDepartmentEvent extends DepartmentEvent {
  final int id;
  final Map<String, dynamic> departmentData;
  const UpdateDepartmentEvent(this.id, this.departmentData);

  @override
  List<Object?> get props => [id, departmentData];
}

class DeleteDepartmentEvent extends DepartmentEvent {
  final int departmentId;
  const DeleteDepartmentEvent(this.departmentId);

  @override
  List<Object?> get props => [departmentId];
}
