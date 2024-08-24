import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/infrastructure/domain/demo/tast_state.dart';
import 'package:task_manager/infrastructure/domain/service/task/task_repo.dart';

final taskRepoProvider = Provider<TaskRepo>((ref) {
  return TaskRepo();
});

class TodoNotifier extends StateNotifier<TodoState> {
  final TaskRepo taskRepo;
  TodoNotifier(this.taskRepo) : super(TodoState.initial());

  Future<void> getTodo(WidgetRef ref) async {
    state = TodoState.loading();
    final result = await taskRepo.getTodo(ref);
    if (result == null || result is String) {
      state = TodoState.error(result ?? '');
    } else {
      state = TodoState.success(result);
    }
  }
}

final todoNotifierProvider =
    StateNotifierProvider<TodoNotifier, TodoState>((ref) {
  final taskRepo = ref.watch(taskRepoProvider);
  return TodoNotifier(taskRepo);
});
