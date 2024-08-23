import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/api/api_baseservice.dart';
import 'package:task_manager/core/config/api_config.dart';
import 'package:task_manager/core/model/task_model.dart';

class TaskRepo {
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
        return (response.data as List)
            .map((map) => TaskModel.fromJson(map))
            .toList();
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
}
