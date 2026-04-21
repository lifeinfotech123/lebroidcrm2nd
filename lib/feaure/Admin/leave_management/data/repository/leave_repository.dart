import 'package:lebroid_crm/feaure/auth/data/services/auth_service.dart';
import '../model/leave_balance_model.dart';
import '../model/leave_model.dart';
import '../model/leave_type_model.dart';

class LeaveRepository {
  final AuthService _authService = AuthService();

  Future<List<LeaveTypeModel>> getLeaveTypes() async {
    final response = await _authService.get('leave-types');
    if (response['success'] == true) {
      List<dynamic> data = response['data'];
      return data.map((json) => LeaveTypeModel.fromJson(json)).toList();
    } else {
      throw Exception(response['message'] ?? 'Failed to fetch leave types');
    }
  }

  Future<LeaveTypeModel> createLeaveType(LeaveTypeModel leaveType) async {
    final response = await _authService.postWithToken('leave-types', leaveType.toJson());
    if (response['success'] == true) {
      return LeaveTypeModel.fromJson(response['data']);
    } else {
      throw Exception(response['message'] ?? 'Failed to create leave type');
    }
  }

  Future<LeaveTypeModel> updateLeaveType(int id, Map<String, dynamic> data) async {
    final response = await _authService.put('leave-types/$id', data);
    if (response['success'] == true) {
      return LeaveTypeModel.fromJson(response['data']);
    } else {
      throw Exception(response['message'] ?? 'Failed to update leave type');
    }
  }

  Future<LeaveModel> applyLeave(LeaveModel leave) async {
    final response = await _authService.postWithToken('leaves/apply', leave.toJson());
    if (response['success'] == true) {
      return LeaveModel.fromJson(response['data']);
    } else {
      throw Exception(response['message'] ?? 'Failed to apply for leave');
    }
  }

  Future<List<LeaveModel>> getLeaves({String? status, int? year}) async {
    String query = '';
    if (status != null && status != 'All Status') query += 'status=${status.toLowerCase()}';
    if (year != null) {
      if (query.isNotEmpty) query += '&';
      query += 'year=$year';
    }
    
    final endpoint = query.isNotEmpty ? 'leaves?$query' : 'leaves';
    final response = await _authService.get(endpoint);
    
    if (response['success'] == true) {
      // The API returns a paginated structure where 'data' is the list inside another 'data' object
      List<dynamic> data;
      if (response['data'] is Map && response['data']['data'] != null) {
        data = response['data']['data'];
      } else {
        data = response['data'];
      }
      return data.map((json) => LeaveModel.fromJson(json)).toList();
    } else {
      throw Exception(response['message'] ?? 'Failed to fetch leaves');
    }
  }

  Future<void> approveLeave(int id, String remarks) async {
    final response = await _authService.put('leaves/$id/approve', {'remarks': remarks});
    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to approve leave');
    }
  }

  Future<void> cancelLeave(int id) async {
    final response = await _authService.put('leaves/$id/cancel', {});
    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to cancel leave');
    }
  }

  Future<List<LeaveBalanceModel>> getLeaveBalance() async {
    final response = await _authService.get('leaves/balance');
    if (response['success'] == true) {
      List<dynamic> data = response['data'];
      return data.map((json) => LeaveBalanceModel.fromJson(json)).toList();
    } else {
      throw Exception(response['message'] ?? 'Failed to fetch leave balance');
    }
  }

  Future<void> deleteLeaveType(int id) async {
    final response = await _authService.delete('leave-types/$id');
    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to delete leave type');
    }
  }
}
