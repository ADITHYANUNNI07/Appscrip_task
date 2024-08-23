import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/api/api_baseservice.dart';
import 'package:task_manager/core/config/api_config.dart';
import 'package:task_manager/core/model/user_model.dart';
import 'package:task_manager/infrastructure/helper/shared_preference.dart';

class AuthRepo {
  final Dio dio = Dio();
  String signupEndpoint = '/register';
  String loginEndpoint = '/login';
  Future<String> signup(UserModel userModel, WidgetRef ref) async {
    try {
      final response = await dio.post(
        '${AppDevConfig.baseURL}$signupEndpoint',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json',
          },
        ),
        data: userModel.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Signup successful!::${response.toString()}');
        print(response.data['token']);
        await setAccessToken(ref, response.data['token']);
        await setUID(ref, response.data['id'].toString());
        return 'success';
      } else {
        log(response.data['error']);
        print('Signup failed with status code: ${response.statusCode}');
        return response.data['error'];
      }
    } catch (e) {
      if (e is DioException) {
        handleApiError('Post', e);
        return e.response?.data['error'];
      } else {
        debugPrint('Get Request Error: $e');
        return e.toString();
      }
    }
  }

  Future<String> login(UserModel userModel, WidgetRef ref) async {
    try {
      final response = await dio.post(
        '${AppDevConfig.baseURL}$loginEndpoint',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'accept': 'application/json',
          },
        ),
        data: userModel.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Login successful!::${response.toString()}');
        print(response.data['token']);
        await setAccessToken(ref, response.data['token']);
        return 'success';
      } else {
        log(response.data['error']);
        print('Signup failed with status code: ${response.statusCode}');
        return response.data['error'];
      }
    } catch (e) {
      if (e is DioException) {
        handleApiError('Post', e);
        return e.response?.data['error'];
      } else {
        debugPrint('Get Request Error: $e');
        return e.toString();
      }
    }
  }
}
