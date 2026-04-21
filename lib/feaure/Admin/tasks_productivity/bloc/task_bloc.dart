import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repository/task_repository.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository _repository;

  TaskBloc(this._repository) : super(TaskInitial()) {
    on<FetchTasks>((event, emit) async {
      emit(TaskLoading());
      try {
        final tasks = await _repository.getAllTasks();
        emit(TaskLoaded(tasks));
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    });

    on<FetchPendingTasks>((event, emit) async {
      emit(TaskLoading());
      try {
        final tasks = await _repository.getPendingTasks();
        emit(TaskLoaded(tasks));
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    });

    on<CreateTask>((event, emit) async {
      emit(TaskLoading());
      try {
        final task = await _repository.createTask(event.taskData);
        emit(TaskOperationSuccess("Task created successfully", task: task));
        add(FetchTasks());
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    });

    on<UpdateTask>((event, emit) async {
      emit(TaskLoading());
      try {
        final task = await _repository.updateTask(event.id, event.updateData);
        emit(TaskOperationSuccess("Task updated successfully", task: task));
        add(FetchTasks());
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    });

    on<DeleteTask>((event, emit) async {
      emit(TaskLoading());
      try {
        await _repository.deleteTask(event.id);
        emit(TaskOperationSuccess("Task deleted successfully"));
        add(FetchTasks());
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    });

    on<SubmitTask>((event, emit) async {
      emit(TaskLoading());
      try {
        final task = await _repository.submitTask(event.id, event.remarks, event.filePath);
        emit(TaskOperationSuccess("Task submitted for approval", task: task));
        add(FetchTasks());
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    });

    on<ApproveTask>((event, emit) async {
      emit(TaskLoading());
      try {
        final task = await _repository.approveTask(event.id, event.remarks);
        emit(TaskOperationSuccess("Task approved successfully", task: task));
        add(FetchTasks());
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    });

    on<RejectTask>((event, emit) async {
      emit(TaskLoading());
      try {
        final task = await _repository.rejectTask(event.id, event.reason);
        emit(TaskOperationSuccess("Task rejected successfully", task: task));
        add(FetchTasks());
      } catch (e) {
        emit(TaskError(e.toString()));
      }
    });
  }
}
