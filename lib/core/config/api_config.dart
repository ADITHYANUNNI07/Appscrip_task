import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_manager/core/model/user_model.dart';

class AppDevConfig {
  static const String baseURL = 'https://reqres.in/api';
  static String accessToken = '';
  static String companyName = '';
  static const String baseURLTodo = 'https://jsonplaceholder.typicode.com/';
  static List<UserModel> userList = [];
}

void handleApiError(String source, DioException error) {
  debugPrint(' $source : Request Error: ${error.response}');
  if (error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.receiveTimeout ||
      error.type == DioExceptionType.sendTimeout ||
      error.type == DioExceptionType.connectionError) {
    Fluttertoast.showToast(msg: "No Internet Connection");
  }
}

logApiResponse(Response? response) {
  if (response != null) {
    debugPrint('Response statuscode : ${response.statusCode}');
    debugPrint('request option : ${response.requestOptions.data}');
    debugPrint('Response data: ${response.data}');
  }
}
