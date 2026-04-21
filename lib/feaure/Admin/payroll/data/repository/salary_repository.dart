import 'package:shared_preferences/shared_preferences.dart';
import '../../../../auth/data/services/auth_service.dart';
import '../model/salary_model.dart';

class SalaryRepository {
  final AuthService _service;

  SalaryRepository(this._service);

  // ─── GET /salary/overview ────────────────────────────────────────
  Future<SalaryOverviewModel> getSalaryOverview() async {
    final response = await _service.get('salary/overview');
    return SalaryOverviewModel.fromJson(response['data']);
  }

  // ─── POST /salary/user/{id}/set ──────────────────────────────────
  Future<SalarySetResponse> setSalary({
    required int userId,
    required Map<String, dynamic> body,
  }) async {
    final response = await _service.postWithToken('salary/user/$userId/set', body);
    return SalarySetResponse.fromJson(response);
  }

  // ─── PUT /salary/user/{id} ───────────────────────────────────────
  Future<SalarySetResponse> updateSalary({
    required int userId,
    required Map<String, dynamic> body,
  }) async {
    final response = await _service.put('salary/user/$userId', body);
    return SalarySetResponse.fromJson(response);
  }

  // ─── GET /salary/user/{id}/history ───────────────────────────────
  Future<SalaryHistoryModel> getSalaryHistory({required int userId}) async {
    final response = await _service.get('salary/user/$userId/history');
    return SalaryHistoryModel.fromJson(response['data']);
  }

  // ─── POST /salary/user/{id}/revise ───────────────────────────────
  Future<SalaryReviseResponse> reviseSalary({
    required int userId,
    required Map<String, dynamic> body,
  }) async {
    final response = await _service.postWithToken('salary/user/$userId/revise', body);
    return SalaryReviseResponse.fromJson(response);
  }

  // ─── POST /salary/payroll/run (preview) ──────────────────────────
  Future<PayrollRunResponse> runPayroll({
    required String month,
    bool previewOnly = true,
  }) async {
    final response = await _service.postWithToken('salary/payroll/run', {
      'month': month,
      'preview_only': previewOnly,
    });
    return PayrollRunResponse.fromJson(response);
  }

  // ─── POST /salary/payroll/process ────────────────────────────────
  Future<PayrollProcessResponse> processPayroll({
    required String month,
    bool force = false,
  }) async {
    final response = await _service.postWithToken('salary/payroll/process', {
      'month': month,
      'force': force,
    });
    return PayrollProcessResponse.fromJson(response);
  }

  // ─── GET /salary/payslip/{id} ────────────────────────────────────
  Future<PayslipModel> getPayslip({required int employeeId}) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';
    final password = prefs.getString('password') ?? '';

    final response = await _service.get('salary/payslip/$employeeId', queryParams: {
      'email': email,
      'password': password,
    });
    return PayslipModel.fromJson(response['data']);
  }
}
