import 'package:task_manager/core/model/user_model.dart';

class TodoModel {
  final int userId;
  final int? id;
  final String title;
  final bool completed;
  final UserModel? user;

  TodoModel({
    this.user,
    required this.userId,
    this.id,
    required this.title,
    required this.completed,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      completed: json['completed'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'completed': completed,
    };
  }
}
