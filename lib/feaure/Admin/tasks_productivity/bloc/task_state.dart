import 'package:equatable/equatable.dart';
import '../data/model/task_model.dart';

abstract class TaskState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<TaskModel> tasks;
  TaskLoaded(this.tasks);
  @override
  List<Object?> get props => [tasks];
}

class TaskOperationSuccess extends TaskState {
  final String message;
  final TaskModel? task;
  TaskOperationSuccess(this.message, {this.task});
  @override
  List<Object?> get props => [message, task];
}

class TaskError extends TaskState {
  final String message;
  TaskError(this.message);
  @override
  List<Object?> get props => [message];
}
