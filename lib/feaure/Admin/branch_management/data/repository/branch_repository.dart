import 'package:lebroid_crm/feaure/auth/data/services/auth_service.dart';
import 'package:lebroid_crm/feaure/Admin/branch_management/data/model/branch_model.dart';

class BranchRepository {
  final AuthService _authService = AuthService();

  Future<List<BranchModel>> getAllBranches() async {
    final response = await _authService.get('branches');
    if (response['success'] == true) {
      List<dynamic> data = response['data'];
      return data.map((json) => BranchModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch branches');
    }
  }

  Future<BranchModel> getSingleBranch(int id) async {
    final response = await _authService.get('branches/$id');
    if (response['success'] == true) {
      return BranchModel.fromJson(response['data']);
    } else {
      throw Exception('Failed to fetch branch details');
    }
  }

  Future<void> createBranch(Map<String, dynamic> branchData) async {
    final response = await _authService.postWithToken('branches', branchData);
    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to create branch');
    }
  }

  Future<void> updateBranch(int id, Map<String, dynamic> branchData) async {
    final response = await _authService.put('branches/$id', branchData);
    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to update branch');
    }
  }

  Future<void> deleteBranch(int id) async {
    final response = await _authService.delete('branches/$id');
    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to delete branch');
    }
  }
}
