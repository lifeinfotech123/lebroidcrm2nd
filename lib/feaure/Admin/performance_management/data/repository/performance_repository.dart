import 'package:shared_preferences/shared_preferences.dart';
import '../../../../auth/data/services/auth_service.dart';
import '../model/performance_model.dart';

class PerformanceRepository {
  final AuthService _service;
  PerformanceRepository(this._service);

  // ──── PERFORMANCE RATINGS ────

  Future<List<PerformanceModel>> getAllPerformances({String? month, String? year, int? userId}) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';
    final password = prefs.getString('password') ?? '';

    Map<String, String> queryParams = {
      'email': email,
      'password': password,
    };
    if (month != null) queryParams['month'] = month;
    if (year != null) queryParams['year'] = year;
    if (userId != null) queryParams['user_id'] = userId.toString();

    final response = await _service.get('performances', queryParams: queryParams);
    final List data = response['data']['data'] ?? [];
    return data.map((json) => PerformanceModel.fromJson(json)).toList();
  }

  Future<PerformanceModel> getPerformanceById(int id) async {
    final response = await _service.get('performances/$id');
    return PerformanceModel.fromJson(response['data']);
  }

  Future<PerformanceModel> createPerformance(Map<String, dynamic> data) async {
    final response = await _service.postWithToken('performances', data);
    return PerformanceModel.fromJson(response['data']);
  }

  Future<PerformanceModel> updatePerformance(int id, Map<String, dynamic> data) async {
    final response = await _service.put('performances/$id', data);
    return PerformanceModel.fromJson(response['data']);
  }

  Future<void> deletePerformance(int id) async {
    await _service.delete('performances/$id');
  }

  // ──── PERFORMANCE GOALS ────

  Future<List<GoalModel>> getAllGoals() async {
    final response = await _service.get('performance-goals');
    final List data = response['data'] ?? [];
    return data.map((json) => GoalModel.fromJson(json)).toList();
  }

  Future<GoalModel> getGoalById(int id) async {
    final response = await _service.get('performance-goals/$id');
    return GoalModel.fromJson(response['data']);
  }

  Future<GoalModel> createGoal(Map<String, dynamic> data) async {
    final response = await _service.postWithToken('performance-goals', data);
    return GoalModel.fromJson(response['data']);
  }

  Future<GoalModel> updateGoal(int id, Map<String, dynamic> data) async {
    final response = await _service.put('performance-goals/$id', data);
    return GoalModel.fromJson(response['data']);
  }

  Future<void> deleteGoal(int id) async {
    await _service.delete('performance-goals/$id');
  }
}
