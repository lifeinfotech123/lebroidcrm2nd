import 'package:lebroid_crm/feaure/auth/data/services/auth_service.dart';
import '../model/attendance_report_model.dart';
import '../model/leave_report_model.dart';
import '../model/payroll_report_model.dart';
import '../model/expense_report_model.dart';
import '../model/task_report_model.dart';
import '../model/performance_report_model.dart';

class ReportsRepository {
  final AuthService _authService;

  ReportsRepository(this._authService);

  Future<AttendanceReportResponse> getAttendanceReport({
    String? month,
    int? branchId,
    int? deptId,
    int? userId,
  }) async {
    String query = 'reports/attendance?';
    if (month != null) query += 'month=$month&';
    if (branchId != null) query += 'branch_id=$branchId&';
    if (deptId != null) query += 'dept_id=$deptId&';
    if (userId != null) query += 'user_id=$userId&';

    final response = await _authService.get(query);
    if (response['success'] == true) {
      return AttendanceReportResponse.fromJson(response['data']);
    } else {
      throw Exception(response['message'] ?? 'Failed to fetch attendance report');
    }
  }

  Future<List<LeaveReportModel>> getLeaveReport({
    String? month,
    String? status,
    int? typeId,
  }) async {
    String query = 'reports/leave?';
    if (month != null) query += 'month=$month&';
    if (status != null) query += 'status=$status&';
    if (typeId != null) query += 'type_id=$typeId&';

    final response = await _authService.get(query);
    if (response['success'] == true) {
      final List list = response['data'] as List;
      return list.map((e) => LeaveReportModel.fromJson(e)).toList();
    } else {
      throw Exception(response['message'] ?? 'Failed to fetch leave report');
    }
  }

  Future<PayrollReportResponse> getPayrollReport({
    String? month,
    String? status,
    int? branchId,
  }) async {
    String query = 'reports/payroll?';
    if (month != null) query += 'month=$month&';
    if (status != null) query += 'status=$status&';
    if (branchId != null) query += 'branch_id=$branchId&';

    final response = await _authService.get(query);
    if (response['success'] == true) {
      return PayrollReportResponse.fromJson(response['data']);
    } else {
      throw Exception(response['message'] ?? 'Failed to fetch payroll report');
    }
  }

  Future<List<ExpenseReportModel>> getExpenseReport({
    String? month,
    String? status,
    int? categoryId,
  }) async {
    String query = 'reports/expense?';
    if (month != null) query += 'month=$month&';
    if (status != null) query += 'status=$status&';
    if (categoryId != null) query += 'category=$categoryId&';

    final response = await _authService.get(query);
    if (response['success'] == true) {
      final List list = response['data'] as List;
      return list.map((e) => ExpenseReportModel.fromJson(e)).toList();
    } else {
      throw Exception(response['message'] ?? 'Failed to fetch expense report');
    }
  }

  Future<List<TaskReportModel>> getTaskReport({
    String? month,
    String? status,
    String? priority,
  }) async {
    String query = 'reports/task?';
    if (month != null) query += 'month=$month&';
    if (status != null) query += 'status=$status&';
    if (priority != null) query += 'priority=$priority&';

    final response = await _authService.get(query);
    if (response['success'] == true) {
      final List list = response['data'] as List;
      return list.map((e) => TaskReportModel.fromJson(e)).toList();
    } else {
      throw Exception(response['message'] ?? 'Failed to fetch task report');
    }
  }

  Future<List<PerformanceReportModel>> getPerformanceReport({
    String? month,
    String? year,
  }) async {
    String query = 'reports/performance?';
    if (month != null) query += 'month=$month&';
    if (year != null) query += 'year=$year&';

    final response = await _authService.get(query);
    if (response['success'] == true) {
      final List list = response['data'] as List;
      return list.map((e) => PerformanceReportModel.fromJson(e)).toList();
    } else {
      throw Exception(response['message'] ?? 'Failed to fetch performance report');
    }
  }
}
