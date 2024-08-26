import 'dart:io';

import 'package:dio/dio.dart';
import 'package:task_manager/core/config/api_config.dart';
import 'package:task_manager/core/model/user_model.dart';

class UsesRepo {
  final Dio dio = Dio();
  String todoEndpoint = '/users';
  Future<List<UserModel>> fetchUsers(int page) async {
    try {
      final response = await dio.get('${AppDevConfig.baseURL}$todoEndpoint',
          queryParameters: {'page': page});
      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'];
        return data
            .map((userJson) => UserModel.userListfromJson(userJson))
            .toList();
      } else {
        throw Exception('Failed to load users');
      }
    } on DioError catch (dioError) {
      if (dioError.error is SocketException) {
        throw Exception(
            'Network error: Please check your internet connection.');
      } else if (dioError.type == DioErrorType.connectionTimeout) {
        throw Exception('Connection timed out. Please try again.');
      } else if (dioError.type == DioErrorType.receiveTimeout) {
        throw Exception('Receive timeout in connection. Please try again.');
      } else if (dioError.type == DioErrorType.badResponse) {
        throw Exception(
            'Received invalid status code: ${dioError.response?.statusCode}');
      } else {
        throw Exception('Failed to load users: ${dioError.message}');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<List<UserModel>> fetchAllUsers() async {
    final usersPage1 = await fetchUsers(1);
    final usersPage2 = await fetchUsers(2);
    return [...usersPage1, ...usersPage2];
  }
}
