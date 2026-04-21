import 'package:lebroid_crm/feaure/auth/data/services/auth_service.dart';
import 'package:lebroid_crm/feaure/Admin/department_management/data/model/department_model.dart';

class DepartmentRepository {
  final AuthService _authService = AuthService();

  Future<List<DepartmentModel>> getAllDepartments() async {
    final response = await _authService.get('departments');
    if (response['success'] == true) {
      List<dynamic> data = response['data'];
      return data.map((json) => DepartmentModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch departments');
    }
  }

  Future<DepartmentModel> getSingleDepartment(int id) async {
    final response = await _authService.get('departments/$id');
    if (response['success'] == true) {
      return DepartmentModel.fromJson(response['data']);
    } else {
      throw Exception('Failed to fetch department details');
    }
  }

  Future<void> createDepartment(Map<String, dynamic> departmentData) async {
    final response = await _authService.postWithToken('departments', departmentData);
    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to create department');
    }
  }

  Future<void> updateDepartment(int id, Map<String, dynamic> departmentData) async {
    final response = await _authService.put('departments/$id', departmentData);
    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to update department');
    }
  }

  Future<void> deleteDepartment(int id) async {
    final response = await _authService.delete('departments/$id');
    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to delete department');
    }
  }
}
