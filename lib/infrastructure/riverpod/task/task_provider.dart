import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/infrastructure/domain/demo/tast_state.dart';
import 'package:task_manager/infrastructure/domain/service/task/task_repo.dart';

final taskRepoProvider = Provider<TaskRepo>((ref) {
  return TaskRepo();
});

class TaskNotifier extends StateNotifier<TaskState> {
  final TaskRepo taskRepo;
  TaskNotifier(this.taskRepo) : super(TaskState.initial());

  Future<void> getTodo(WidgetRef ref) async {
    state = TaskState.loading();
    final result = await taskRepo.getTodo(ref);
    if (result == null || result is String) {
      state = TaskState.error(result ?? '');
    } else {
      state = TaskState.success(result);
    }
  }
}

final taskNotifierProvider =
    StateNotifierProvider<TaskNotifier, TaskState>((ref) {
  final taskRepo = ref.watch(taskRepoProvider);
  return TaskNotifier(taskRepo);
});
