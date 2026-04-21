import 'package:equatable/equatable.dart';
import 'package:lebroid_crm/feaure/Admin/role_management/data/model/role_model.dart';

abstract class RoleState extends Equatable {
  const RoleState();

  @override
  List<Object?> get props => [];
}

class RoleInitial extends RoleState {}

class RoleLoading extends RoleState {}

class RoleLoaded extends RoleState {
  final List<RoleModel> roles;
  const RoleLoaded(this.roles);

  @override
  List<Object?> get props => [roles];
}

class SingleRoleLoaded extends RoleState {
  final RoleModel role;
  const SingleRoleLoaded(this.role);

  @override
  List<Object?> get props => [role];
}

class RoleOperationSuccess extends RoleState {
  final String message;
  const RoleOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class RoleError extends RoleState {
  final String message;
  const RoleError(this.message);

  @override
  List<Object?> get props => [message];
}

class PermissionsLoaded extends RoleState {
  final List<PermissionModel> permissions;
  const PermissionsLoaded(this.permissions);

  @override
  List<Object?> get props => [permissions];
}
