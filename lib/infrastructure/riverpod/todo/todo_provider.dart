import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final result = await todoRepo.getTodo(ref);
    if (result == null || result is String) {
      state = TodoState.error(result ?? '');
    } else {
      state = TodoState.success(result);
    }
  }
}

final todoNotifierProvider =
    StateNotifierProvider<TodoNotifier, TodoState>((ref) {
  final todo = ref.watch(TodoRepoProvider);
  return TodoNotifier(todo);
});
