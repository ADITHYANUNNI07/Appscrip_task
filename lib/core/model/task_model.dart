import 'package:task_manager/core/model/user_model.dart';

class TaskModel {
  final int? id;
  final String title;
  final String description;
  final DateTime? date;
  final String priority;
  final String status;
  final UserModel? assignedUser;
  final DateTime? createAt;
  TaskModel({
    this.createAt,
    this.id,
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

  factory TaskModel.fromMap(
      Map<String, dynamic> map, List<UserModel> userList) {
    UserModel? assignedUser;
    if (map['userId'] != null) {
      assignedUser = userList.firstWhere(
        (user) => user.id == map['userId'],
        orElse: () =>
            UserModel(id: -1, firstName: '', lastName: '', avatar: ''),
      );
    }
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: map['duedate'] != null ? DateTime.parse(map['duedate']) : null,
      priority: map['priority'],
      status: map['status'],
      assignedUser: assignedUser,
      createAt:
          map['createAt'] != null ? DateTime.parse(map['createAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'duedate': date!.toIso8601String(),
      'priority': priority,
      'status': status,
      'userId': assignedUser!.id,
      'createAt': DateTime.now().toIso8601String()
    };
  }
}
