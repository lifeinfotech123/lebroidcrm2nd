import 'package:lebroid_crm/feaure/auth/data/services/auth_service.dart';
import 'package:lebroid_crm/feaure/Admin/employees_management/data/model/employee_model.dart';

class EmployeeRepository {
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>> getAllEmployees({int page = 1}) async {
    final response = await _authService.get('employees?page=$page');
    if (response['success'] == true) {
      // The API returns paginated data with nested 'data' key
      final rawData = response['data'];
      List<dynamic> employeeList;
      int lastPage = 1;

      if (rawData is Map && rawData.containsKey('data')) {
        // Paginated response: { data: { current_page: 1, data: [...], last_page: X } }
        employeeList = rawData['data'] as List<dynamic>;
        lastPage = rawData['last_page'] ?? 1;
      } else if (rawData is List) {
        // Simple list response
        employeeList = rawData;
      } else {
        throw Exception('Unexpected response format for employees');
      }

      return {
        'employees': employeeList.map((json) => EmployeeModel.fromJson(json)).toList(),
        'lastPage': lastPage,
      };
    } else {
      throw Exception('Failed to fetch employees');
    }
  }

  Future<EmployeeModel> getSingleEmployee(int id) async {
    final response = await _authService.get('employees/$id');
    if (response['success'] == true) {
      return EmployeeModel.fromJson(response['data']);
    } else {
      throw Exception('Failed to fetch employee details');
    }
  }

  Future<void> createEmployee(Map<String, dynamic> employeeData) async {
    final response = await _authService.postWithToken('employees', employeeData);
    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to create employee');
    }
  }

  Future<void> updateEmployee(int id, Map<String, dynamic> employeeData) async {
    final response = await _authService.put('employees/$id', employeeData);
    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to update employee');
    }
  }

  Future<void> deleteEmployee(int id) async {
    final response = await _authService.delete('employees/$id');
    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to delete employee');
    }
  }
}
