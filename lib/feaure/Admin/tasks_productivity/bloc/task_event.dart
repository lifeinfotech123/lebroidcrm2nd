import 'package:equatable/equatable.dart';

abstract class TaskEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchTasks extends TaskEvent {}

class FetchPendingTasks extends TaskEvent {}

class CreateTask extends TaskEvent {
  final Map<String, dynamic> taskData;
  CreateTask(this.taskData);
  @override
  List<Object?> get props => [taskData];
}

class UpdateTask extends TaskEvent {
  final int id;
  final Map<String, dynamic> updateData;
  UpdateTask(this.id, this.updateData);
  @override
  List<Object?> get props => [id, updateData];
}

class DeleteTask extends TaskEvent {
  final int id;
  DeleteTask(this.id);
  @override
  List<Object?> get props => [id];
}

class SubmitTask extends TaskEvent {
  final int id;
  final String remarks;
  final String? filePath;
  SubmitTask(this.id, this.remarks, this.filePath);
  @override
  List<Object?> get props => [id, remarks, filePath];
}

class ApproveTask extends TaskEvent {
  final int id;
  final String remarks;
  ApproveTask(this.id, this.remarks);
  @override
  List<Object?> get props => [id, remarks];
}

class RejectTask extends TaskEvent {
  final int id;
  final String reason;
  RejectTask(this.id, this.reason);
  @override
  List<Object?> get props => [id, reason];
}
