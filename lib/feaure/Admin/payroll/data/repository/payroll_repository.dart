import '../../../../auth/data/services/auth_service.dart';
import '../model/payroll_model.dart';

class PayrollRepository {
  final AuthService _service;

  PayrollRepository(this._service);

  Future<PayrollSummaryModel> getPayrollSummary({String? month}) async {
    String endpoint = 'payrolls/summary';
    if (month != null) {
      endpoint += '?month=$month';
    }
    
    final response = await _service.get(endpoint);
    return PayrollSummaryModel.fromJson(response['data']);
  }

  Future<List<PayrollModel>> getPayrolls({
    String? month,
    String? status,
    String? search,
  }) async {
    String endpoint = 'payrolls';
    List<String> params = [];
    if (month != null && month.isNotEmpty) params.add('month=$month');
    if (status != null && status.isNotEmpty && status != 'All Status') {
      params.add('status=${status.toLowerCase()}');
    }
    if (search != null && search.isNotEmpty) params.add('search=$search');
    
    if (params.isNotEmpty) {
      endpoint += '?${params.join('&')}';
    }

    final response = await _service.get(endpoint);
    final List data = response['data']['data'] ?? [];
    return data.map((json) => PayrollModel.fromJson(json)).toList();
  }

  Future<List<PayrollPreviewModel>> getPayrollPreview({
    required String month,
    String? branchId,
    String? deptId,
  }) async {
    final body = {
      'month': month,
    };
    if (branchId != null && branchId != 'All Branches') {
      body['branch_id'] = branchId;
    }
    // We expect dept_id if it's not "All Departments" etc, but the API may just need the integer ID. 
    // We will pass it exactly if available.
    if (deptId != null && deptId != 'All Departments') {
      body['dept_id'] = deptId;
    }

    final response = await _service.post('payrolls/preview', body);
    final List data = response['data'] ?? [];
    return data.map((json) => PayrollPreviewModel.fromJson(json)).toList();
  }

  Future<void> processPayroll({
    required String month,
    required List<Map<String, dynamic>> previews,
  }) async {
    final body = {
      'month': month,
      'previews': previews,
    };
    await _service.post('payrolls/process', body);
  }
}
