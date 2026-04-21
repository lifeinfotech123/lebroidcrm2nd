import 'package:equatable/equatable.dart';

abstract class RoleEvent extends Equatable {
  const RoleEvent();

  @override
  List<Object?> get props => [];
}

class LoadRolesEvent extends RoleEvent {}

class FetchSingleRoleEvent extends RoleEvent {
  final int id;
  const FetchSingleRoleEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class AddRoleEvent extends RoleEvent {
  final Map<String, dynamic> roleData;
  const AddRoleEvent(this.roleData);

  @override
  List<Object?> get props => [roleData];
}

class UpdateRoleEvent extends RoleEvent {
  final int id;
  final Map<String, dynamic> roleData;
  const UpdateRoleEvent(this.id, this.roleData);

  @override
  List<Object?> get props => [id, roleData];
}

class DeleteRoleEvent extends RoleEvent {
  final int roleId;
  const DeleteRoleEvent(this.roleId);

  @override
  List<Object?> get props => [roleId];
}

class SyncPermissionsEvent extends RoleEvent {
  final int roleId;
  final List<String> permissions;
  const SyncPermissionsEvent(this.roleId, this.permissions);

  @override
  List<Object?> get props => [roleId, permissions];
}

class FetchPermissionsEvent extends RoleEvent {}
