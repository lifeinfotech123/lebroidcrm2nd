import 'package:shared_preferences/shared_preferences.dart';
import '../../../../auth/data/services/auth_service.dart';
import '../model/task_model.dart';

class TaskRepository {
  final AuthService _service;
  TaskRepository(this._service);

  Future<List<TaskModel>> getAllTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';
    final password = prefs.getString('password') ?? '';

    final response = await _service.get('tasks', queryParams: {
      'email': email,
      'password': password,
    });
    final List data = response['data']['data'] ?? [];
    return data.map((json) => TaskModel.fromJson(json)).toList();
  }

  Future<List<TaskModel>> getPendingTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';
    final password = prefs.getString('password') ?? '';

    final response = await _service.get('tasks/pending', queryParams: {
      'email': email,
      'password': password,
    });
    final List data = response['data']['data'] ?? [];
    return data.map((json) => TaskModel.fromJson(json)).toList();
  }

  Future<TaskModel> createTask(Map<String, dynamic> taskData) async {
    final response = await _service.postWithToken('tasks', taskData);
    return TaskModel.fromJson(response['data']);
  }

  Future<TaskModel> updateTask(int id, Map<String, dynamic> updateData) async {
    final response = await _service.put('tasks/$id', updateData);
    return TaskModel.fromJson(response['data']);
  }

  Future<void> deleteTask(int id) async {
    await _service.delete('tasks/$id');
  }

  Future<TaskModel> submitTask(int id, String remarks, String? filePath) async {
    final Map<String, String> fields = {'Remarks': remarks};
    final response = await _service.postMultipart(
      'tasks/$id/submit',
      fields: fields,
      filePath: filePath,
      fileFieldName: 'Attechment', // Correct spelling based on user's API note
    );
    return TaskModel.fromJson(response['data']);
  }

  Future<TaskModel> approveTask(int id, String remarks) async {
    final response = await _service.put('tasks/$id/approve', {'remarks': remarks});
    return TaskModel.fromJson(response['data']);
  }

  Future<TaskModel> rejectTask(int id, String reason) async {
    final response = await _service.put('tasks/$id/reject', {'reason': reason});
    return TaskModel.fromJson(response['data']);
  }
}
