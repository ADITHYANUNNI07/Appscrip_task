import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_manager/core/config/api_config.dart';
import 'package:task_manager/core/model/user_model.dart';
import 'package:task_manager/core/notification/notification.dart';
import 'package:task_manager/infrastructure/riverpod/auth/auth_provider.dart';

loginFun(UserModel userModel, WidgetRef ref, BuildContext context) async {
  if (AppDevConfig.isNetwork) {
    if (userModel.isValid &&
        userModel.email.isNotEmpty &&
        userModel.password.isNotEmpty) {
      log('Email: ${userModel.email}');
      log('Password: ${userModel.password}');
      ref.read(authNotifierProvider.notifier).login(userModel, ref);
    } else {
      if (userModel.email.isEmpty && userModel.password.isEmpty) {
        Fluttertoast.showToast(
          msg: 'Please Enter the E-mail and Password',
        );
      }
    }
  } else {
    NotificationHandler.snakBarWarning('You are offline', context);
  }
}
