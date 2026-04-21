import 'package:lebroid_crm/feaure/auth/data/services/auth_service.dart';
import '../model/break_model.dart';

class BreakRepository {
  final AuthService _authService;

  BreakRepository({AuthService? authService})
      : _authService = authService ?? AuthService();

  Future<List<BreakRecord>> getBreaks() async {
    final response = await _authService.get('breaks');
    if (response['success'] == true) {
      final List<dynamic> data = response['data'];
      return data.map((e) => BreakRecord.fromJson(e)).toList();
    } else {
      throw Exception(response['message'] ?? 'Failed to get breaks');
    }
  }

  Future<BreakRecord> getSingleBreak(int id) async {
    final response = await _authService.get('breaks/$id');
    if (response['success'] == true) {
      return BreakRecord.fromJson(response['data']);
    } else {
      throw Exception(response['message'] ?? 'Failed to get break details');
    }
  }

  Future<BreakRecord> createBreak(Map<String, dynamic> data) async {
    final response = await _authService.postWithToken('breaks', data);
    if (response['success'] == true) {
      return BreakRecord.fromJson(response['data']);
    } else {
      throw Exception(response['message'] ?? 'Failed to create break');
    }
  }

  Future<BreakRecord> updateBreak(int id, Map<String, dynamic> data) async {
    final response = await _authService.put('breaks/$id', data);
    if (response['success'] == true) {
      return BreakRecord.fromJson(response['data']);
    } else {
      throw Exception(response['message'] ?? 'Failed to update break');
    }
  }

  Future<bool> deleteBreak(int id) async {
    final response = await _authService.delete('breaks/$id');
    return response['success'] == true;
  }

  Future<List<BreakType>> getBreakTypes() async {
    // Note: The user provided /breaks for break types, but usually it's /break-types or similar.
    // I'll try /break-types as a fallback if the user wants dedicated types.
    // For now, I'll implement it as /breaks and let the user know if categories are different.
    // Actually, I'll try /breaks first as per their documentation titled "Get Break Types".
    final response = await _authService.get('breaks');
    if (response['success'] == true) {
      final List<dynamic> data = response['data'];
      // Extract unique break types from the logs if a dedicated endpoint is missing
      final typesMap = <int, BreakType>{};
      for (var item in data) {
        if (item['break_type'] != null) {
          final bt = BreakType.fromJson(item['break_type']);
          typesMap[bt.id] = bt;
        }
      }
      return typesMap.values.toList();
    } else {
      throw Exception(response['message'] ?? 'Failed to get break types');
    }
  }
}
