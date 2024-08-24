import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/model/task_model.dart';
import 'package:task_manager/core/model/user_model.dart';
import 'package:task_manager/db/database_sqflite.dart';

class TaskFormNotifier extends StateNotifier<TaskModel> {
  TaskFormNotifier()
      : super(TaskModel(title: '', description: '', priority: '', status: ''));
  void clearModel() {
    state = state.copyWith(
        title: '',
        description: '',
        priority: '',
        status: '',
        assignedUser: null,
        date: null);
  }

  void updateTitle(String title) {
    state = state.copyWith(title: title);
  }

  void updateDescription(String description) {
    state = state.copyWith(description: description);
  }

  void updateDate(DateTime date) {
    state = state.copyWith(date: date);
  }

  void updatePriority(String priority) {
    state = state.copyWith(priority: priority);
  }

  void updateStatus(String status) {
    state = state.copyWith(status: status);
  }

  void updateAssignedUser(UserModel? user) {
    state = state.copyWith(assignedUser: user);
  }

  bool validateForm() {
    if (state.title.isEmpty ||
        state.description.isEmpty ||
        state.assignedUser == null) {
      return false;
    }
    return true;
  }
}

final taskFormProvider = StateNotifierProvider<TaskFormNotifier, TaskModel>(
  (ref) => TaskFormNotifier(),
);
final selectedDateProvider = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

class TaskNotifier extends StateNotifier<List<TaskModel>> {
  TaskNotifier(super.initialTasks);

  List<TaskModel> filterTasksByDate(DateTime date) {
    return state
        .where(
            (task) => task.createAt != null && isSameDay(task.createAt!, date))
        .toList();
  }

  void addTask(List<TaskModel> task) {
    state = task;
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

final tasksFutureProvider = FutureProvider<List<TaskModel>>((ref) async {
  final tasks = await fetchAllTasks();
  return tasks;
});

final taskProvider =
    StateNotifierProvider<TaskNotifier, List<TaskModel>>((ref) {
  List<TaskModel> tasks = ref.watch(tasksFutureProvider).maybeWhen(
        data: (data) => data,
        orElse: () => [],
      );
  return TaskNotifier(tasks);
});
