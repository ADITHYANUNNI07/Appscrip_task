import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/model/task_model.dart';
import 'package:task_manager/core/model/user_model.dart';

class TaskFormNotifier extends StateNotifier<TaskModel> {
  TaskFormNotifier()
      : super(TaskModel(
            title: '', description: '', priority: 'Low', status: 'To-Do'));

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

  void updateAssignedUser(UserModel user) {
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
