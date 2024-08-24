import 'package:task_manager/core/model/todo_model.dart';

enum TodoStateStatus { initial, loading, success, error }

class TodoState {
  final TodoStateStatus status;
  final List<TodoModel>? tasks;
  final String? errorMessage;

  TodoState._({required this.status, this.tasks, this.errorMessage});

  factory TodoState.initial() => TodoState._(status: TodoStateStatus.initial);

  factory TodoState.loading() => TodoState._(status: TodoStateStatus.loading);

  factory TodoState.success(List<TodoModel> tasks) =>
      TodoState._(status: TodoStateStatus.success, tasks: tasks);

  factory TodoState.error(String errorMessage) =>
      TodoState._(status: TodoStateStatus.error, errorMessage: errorMessage);
}
