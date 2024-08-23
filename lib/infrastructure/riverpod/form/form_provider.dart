import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/constant/enum.dart';
import 'package:task_manager/core/model/user_model.dart';

final priorityProvider = StateProvider<Priority>((ref) => Priority.medium);
final statusProvider = StateProvider<Status>((ref) => Status.todo);
final usersProvider = FutureProvider<List<UserModel>>((ref) async {
  final dio = Dio();
  final response = await dio.get('https://your-api-endpoint.com/users');
  if (response.statusCode == 200) {
    final List<dynamic> data = response.data;
    return data.map((json) => UserModel.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load users');
  }
});
