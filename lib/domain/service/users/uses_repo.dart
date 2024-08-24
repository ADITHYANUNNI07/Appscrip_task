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
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }

  Future<List<UserModel>> fetchAllUsers() async {
    final usersPage1 = await fetchUsers(1);
    final usersPage2 = await fetchUsers(2);
    return [...usersPage1, ...usersPage2];
  }
}
