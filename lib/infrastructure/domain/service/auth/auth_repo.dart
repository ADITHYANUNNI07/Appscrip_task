import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/core/api/api_baseservice.dart';
import 'package:task_manager/core/config/api_config.dart';
import 'package:task_manager/core/model/user_model.dart';

class AuthRepo {
  final Dio dio = Dio();
  String signupEndpoint = '/register';
  String loginEndpoint = '/login';
  Future<String> signup(UserModel userModel) async {
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

        return 'success';
      } else {
        String errorMessage = '';
        if (response.data['error'] == 'user already exist, sign in') {
          errorMessage = response.data['error'];
        } else {
          errorMessage = response.data['message'];
        }
        log(errorMessage);
        print('Signup failed with status code: ${response.statusCode}');
        return errorMessage;
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
