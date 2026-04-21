import 'package:shared_preferences/shared_preferences.dart';
import 'package:lebroid_crm/feaure/auth/data/services/auth_service.dart';
import '../model/expense_model.dart';
import '../model/expense_category_model.dart';

class ExpenseRepository {
  final AuthService _authService;

  ExpenseRepository(this._authService);

  // ── Expenses ──────────────────────────────────────────────────────────────

  Future<ExpensePaginatedResponse> getExpenses({
    String? status,
    String? month,
    int page = 1,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';
    final password = prefs.getString('password') ?? '';

    String query = 'expenses?page=$page&email=$email&password=$password';
    if (status != null && status != 'All Status') {
      query += '&status=${status.toLowerCase()}';
    }
    if (month != null) {
      query += '&month=$month';
    }

    final response = await _authService.get(query);
    if (response['success'] == true) {
      return ExpensePaginatedResponse.fromJson(response['data']);
    } else {
      throw Exception(response['message'] ?? 'Failed to fetch expenses');
    }
  }

  Future<ExpenseModel> getExpense(int id) async {
    final response = await _authService.get('expenses/$id');
    if (response['success'] == true) {
      return ExpenseModel.fromJson(response['data']);
    } else {
      throw Exception(response['message'] ?? 'Failed to fetch expense details');
    }
  }

  Future<void> createExpense(Map<String, dynamic> data, {String? filePath}) async {
    if (filePath != null) {
      final fields = data.map((key, value) => MapEntry(key, value.toString()));
      final response = await _authService.postMultipart('expenses', fields: fields, filePath: filePath, fileFieldName: 'receipt');
      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to create expense');
      }
    } else {
      final response = await _authService.postWithToken('expenses', data);
      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to create expense');
      }
    }
  }

  Future<void> updateExpense(int id, Map<String, dynamic> data, {String? filePath}) async {
    if (filePath != null) {
      // NOTE: API might need POST with _method=PUT for multipart updates, but AuthService postMultipart uses POST.
      // We'll stick to POST if the API endpoint handles it for updates or check if PUT works with multipart.
      // Usually, Laravel (likely backend) needs _method=PUT in fields for multipart PUT.
      final fields = data.map((key, value) => MapEntry(key, value.toString()));
      fields['_method'] = 'PUT';
      final response = await _authService.postMultipart('expenses/$id', fields: fields, filePath: filePath, fileFieldName: 'receipt');
      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to update expense');
      }
    } else {
      final response = await _authService.put('expenses/$id', data);
      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to update expense');
      }
    }
  }

  Future<void> approveExpense(int id) async {
    final response = await _authService.put('expenses/$id/approve', {});
    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to approve expense');
    }
  }

  Future<void> rejectExpense(int id, String reason) async {
    final response = await _authService.put('expenses/$id/reject', {'reason': reason});
    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to reject expense');
    }
  }

  Future<void> reimburseExpense(int id) async {
    final response = await _authService.put('expenses/$id/reimburse', {});
    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to reimburse expense');
    }
  }

  Future<void> deleteExpense(int id) async {
    final response = await _authService.delete('expenses/$id');
    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to delete expense');
    }
  }

  // ── Categories ────────────────────────────────────────────────────────────

  Future<List<ExpenseCategoryModel>> getExpenseCategories() async {
    final response = await _authService.get('expense-categories');
    if (response['success'] == true) {
      final List<dynamic> list = response['data'] as List;
      return list.map((e) => ExpenseCategoryModel.fromJson(e)).toList();
    } else {
      throw Exception(response['message'] ?? 'Failed to fetch expense categories');
    }
  }

  Future<void> createExpenseCategory(Map<String, dynamic> data) async {
    final response = await _authService.postWithToken('expense-categories', data);
    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to create expense category');
    }
  }

  Future<void> updateExpenseCategory(int id, Map<String, dynamic> data) async {
    final response = await _authService.put('expense-categories/$id', data);
    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to update expense category');
    }
  }

  Future<void> deleteExpenseCategory(int id) async {
    final response = await _authService.delete('expense-categories/$id');
    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to delete expense category');
    }
  }
}
