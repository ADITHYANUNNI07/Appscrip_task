import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/api/api_baseservice.dart';
import 'package:task_manager/core/config/api_config.dart';
import 'package:task_manager/core/model/todo_model.dart';

class TodoRepo {
  final Dio dio = Dio();
  String todoEndpoint = '/todos';
  Future<dynamic> getTodo(WidgetRef ref) async {
    try {
      final response = await dio.get(
        '${AppDevConfig.baseURLTodo}$todoEndpoint',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Get successful!::${response.toString()}');
        List<TodoModel> tasks = (response.data as List)
            .map((map) => TodoModel.fromJson(map))
            .toList();

        tasks = tasks.map((task) {
          final user = AppDevConfig.userList.firstWhere(
            (user) => user.id == task.userId,
          );
          return TodoModel(
            userId: task.userId,
            id: task.id,
            title: task.title,
            completed: task.completed,
            user: user,
          );
        }).toList();

        return tasks;
      } else {
        return response.data['error'];
      }
    } catch (e) {
      if (e is DioException) {
        handleApiError('Get', e);
        return e.response?.data['error'];
      } else {
        debugPrint('Get Request Error: $e');
        return e.toString();
      }
    }
  }

  Future<String> createTask(WidgetRef ref, TodoModel newTask) async {
    try {
      final response = await dio.post(
        '${AppDevConfig.baseURLTodo}$todoEndpoint',
        data: newTask.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201) {
        print('Task created successfully: ${response.toString()}');
        return 'success';
      } else {
        return response.data['error'];
      }
    } catch (e) {
      if (e is DioException) {
        handleApiError('Create', e);
        return e.response?.data['error'];
      } else {
        debugPrint('Create Request Error: $e');
        return e.toString();
      }
    }
  }

  Future<String> updateTask(
      WidgetRef ref, int id, TodoModel updatedTask) async {
    try {
      final response = await dio.put(
        '${AppDevConfig.baseURLTodo}$todoEndpoint/$id',
        data: updatedTask.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Task updated successfully: ${response.toString()}');
        return 'success';
      } else {
        return response.data['error'];
      }
    } catch (e) {
      if (e is DioException) {
        handleApiError('Update', e);
        return e.response?.data['error'];
      } else {
        debugPrint('Update Request Error: $e');
        return e.toString();
      }
    }
  }

  Future<String> deleteTodo(WidgetRef ref, TodoModel model) async {
    try {
      final response = await dio.delete(
        '${AppDevConfig.baseURLTodo}$todoEndpoint/${model.id}',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json',
          },
        ),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return 'success';
      } else {
        return response.data;
      }
    } catch (e) {
      if (e is DioException) {
        handleApiError('delete', e);
        return e.response?.data['error'];
      } else {
        debugPrint('delete Request Error: $e');
        return e.toString();
      }
    }
  }
}
