import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/config/api_config.dart';
import 'package:task_manager/db/database_sqflite.dart';
import 'package:task_manager/domain/demo/tast_state.dart';
import 'package:task_manager/domain/service/todo/todo_repo.dart';

final TodoRepoProvider = Provider<TodoRepo>((ref) {
  return TodoRepo();
});

class TodoNotifier extends StateNotifier<TodoState> {
  final TodoRepo todoRepo;
  TodoNotifier(this.todoRepo) : super(TodoState.initial());

  Future<void> getTodo(WidgetRef ref) async {
    state = TodoState.loading();
    final result = AppDevConfig.isNetwork
        ? await todoRepo.getTodo(ref)
        : await fetchTodos();

    if (result == null || result is String) {
      state = TodoState.error(result ?? '');
    } else {
      await insertTodos(result);
      state = TodoState.success(result);
    }
  }
}

final todoNotifierProvider =
    StateNotifierProvider<TodoNotifier, TodoState>((ref) {
  final todo = ref.watch(TodoRepoProvider);
  return TodoNotifier(todo);
});
