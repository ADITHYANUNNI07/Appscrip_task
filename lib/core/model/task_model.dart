import 'package:task_manager/core/model/user_model.dart';

class TaskModel {
  final String title;
  final String description;
  final DateTime? date;
  final String priority;
  final String status;
  final UserModel? assignedUser;

  TaskModel({
    required this.title,
    required this.description,
    this.date,
    required this.priority,
    required this.status,
    this.assignedUser,
  });

  TaskModel copyWith({
    String? title,
    String? description,
    DateTime? date,
    String? priority,
    String? status,
    UserModel? assignedUser,
  }) {
    return TaskModel(
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      assignedUser: assignedUser ?? this.assignedUser,
    );
  }
}
