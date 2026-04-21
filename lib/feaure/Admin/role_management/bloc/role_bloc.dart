import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lebroid_crm/feaure/Admin/role_management/data/repository/role_repository.dart';
import 'package:lebroid_crm/feaure/Admin/role_management/bloc/role_event.dart';
import 'package:lebroid_crm/feaure/Admin/role_management/bloc/role_state.dart';

class RoleBloc extends Bloc<RoleEvent, RoleState> {
  final RoleRepository roleRepository;

  RoleBloc({required this.roleRepository}) : super(RoleInitial()) {
    on<LoadRolesEvent>(_onLoadRoles);
    on<FetchSingleRoleEvent>(_onFetchSingleRole);
    on<AddRoleEvent>(_onAddRole);
    on<UpdateRoleEvent>(_onUpdateRole);
    on<DeleteRoleEvent>(_onDeleteRole);
    on<SyncPermissionsEvent>(_onSyncPermissions);
    on<FetchPermissionsEvent>(_onFetchPermissions);
  }

  Future<void> _onLoadRoles(
    LoadRolesEvent event,
    Emitter<RoleState> emit,
  ) async {
    emit(RoleLoading());
    try {
      final roles = await roleRepository.getAllRoles();
      emit(RoleLoaded(roles));
    } catch (e) {
      emit(RoleError(e.toString()));
    }
  }

  Future<void> _onFetchSingleRole(
    FetchSingleRoleEvent event,
    Emitter<RoleState> emit,
  ) async {
    emit(RoleLoading());
    try {
      final role = await roleRepository.getSingleRole(event.id);
      emit(SingleRoleLoaded(role));
    } catch (e) {
      emit(RoleError(e.toString()));
    }
  }

  Future<void> _onAddRole(
    AddRoleEvent event,
    Emitter<RoleState> emit,
  ) async {
    emit(RoleLoading());
    try {
      await roleRepository.createRole(event.roleData);
      emit(const RoleOperationSuccess('Role created successfully.'));
      add(LoadRolesEvent());
    } catch (e) {
      emit(RoleError(e.toString()));
    }
  }

  Future<void> _onUpdateRole(
    UpdateRoleEvent event,
    Emitter<RoleState> emit,
  ) async {
    emit(RoleLoading());
    try {
      await roleRepository.updateRole(event.id, event.roleData);
      emit(const RoleOperationSuccess('Role updated successfully.'));
      add(LoadRolesEvent());
    } catch (e) {
      emit(RoleError(e.toString()));
    }
  }

  Future<void> _onDeleteRole(
    DeleteRoleEvent event,
    Emitter<RoleState> emit,
  ) async {
    emit(RoleLoading());
    try {
      await roleRepository.deleteRole(event.roleId);
      emit(const RoleOperationSuccess('Role deleted successfully.'));
      add(LoadRolesEvent());
    } catch (e) {
      emit(RoleError(e.toString()));
    }
  }

  Future<void> _onSyncPermissions(
    SyncPermissionsEvent event,
    Emitter<RoleState> emit,
  ) async {
    emit(RoleLoading());
    try {
      await roleRepository.syncPermissions(event.roleId, event.permissions);
      emit(const RoleOperationSuccess('Permissions synced successfully.'));
      add(FetchSingleRoleEvent(event.roleId));
    } catch (e) {
      emit(RoleError(e.toString()));
    }
  }

  Future<void> _onFetchPermissions(
    FetchPermissionsEvent event,
    Emitter<RoleState> emit,
  ) async {
    emit(RoleLoading());
    try {
      final permissions = await roleRepository.getAllPermissions();
      emit(PermissionsLoaded(permissions));
    } catch (e) {
      emit(RoleError(e.toString()));
    }
  }
}
