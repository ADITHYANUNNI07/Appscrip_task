import 'package:task_manager/core/model/task_model.dart';

enum TaskStateStatus { initial, loading, success, error }

class TaskState {
  final TaskStateStatus status;
  final List<TaskModel>? tasks;
  final String? errorMessage;

  TaskState._({required this.status, this.tasks, this.errorMessage});

  factory TaskState.initial() => TaskState._(status: TaskStateStatus.initial);

  factory TaskState.loading() => TaskState._(status: TaskStateStatus.loading);

  factory TaskState.success(List<TaskModel> tasks) =>
      TaskState._(status: TaskStateStatus.success, tasks: tasks);

  factory TaskState.error(String errorMessage) =>
      TaskState._(status: TaskStateStatus.error, errorMessage: errorMessage);
}
