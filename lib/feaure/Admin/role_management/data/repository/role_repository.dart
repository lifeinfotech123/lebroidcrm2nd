import 'package:lebroid_crm/feaure/auth/data/services/auth_service.dart';
import 'package:lebroid_crm/feaure/Admin/role_management/data/model/role_model.dart';

class RoleRepository {
  final AuthService _authService = AuthService();

  Future<List<RoleModel>> getAllRoles() async {
    final response = await _authService.get('roles');
    if (response['success'] == true) {
      List<dynamic> data = response['data'];
      return data.map((json) => RoleModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch roles');
    }
  }

  Future<RoleModel> getSingleRole(int id) async {
    final response = await _authService.get('roles/$id');
    if (response['success'] == true) {
      return RoleModel.fromJson(response['data']);
    } else {
      throw Exception('Failed to fetch role details');
    }
  }

  Future<void> createRole(Map<String, dynamic> roleData) async {
    final response = await _authService.postWithToken('roles', roleData);
    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to create role');
    }
  }

  Future<void> updateRole(int id, Map<String, dynamic> roleData) async {
    final response = await _authService.put('roles/$id', roleData);
    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to update role');
    }
  }

  Future<void> deleteRole(int id) async {
    final response = await _authService.delete('roles/$id');
    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to delete role');
    }
  }

  Future<void> syncPermissions(int roleId, List<String> permissions) async {
    final response = await _authService.postWithToken('roles/$roleId/sync-permissions', {
      'permissions': permissions,
    });
    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to sync permissions');
    }
  }

  Future<List<PermissionModel>> getAllPermissions() async {
    final response = await _authService.get('permissions');
    if (response['success'] == true) {
      List<dynamic> data = response['data'];
      return data.map((json) => PermissionModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch permissions');
    }
  }

  Future<void> assignRoleToUser(int userId, String roleName) async {
    final response = await _authService.postWithToken('roles/assign-to-user', {
      'user_id': userId,
      'role': roleName,
    });
    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to assign role');
    }
  }
}
