import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/config/api_config.dart';
import 'package:task_manager/db/database_sqflite.dart';
import 'package:task_manager/domain/service/users/uses_repo.dart';
import 'package:task_manager/infrastructure/helper/shared_preference.dart';
import 'package:task_manager/presentation/dashboard/dashboard_screen.dart';
import 'package:task_manager/presentation/login/login_screen.dart';
import 'package:task_manager/presentation/welcome/welcome_screen.dart';

void splashtime(BuildContext context, WidgetRef ref) async {
  Future.delayed(
    const Duration(seconds: 1),
    () async {
      final asyncPrefs = ref.watch(sharedPreferencesProvider);
      AppDevConfig.isNetwork = await checkInternetConnectivity();
      asyncPrefs.when(
        data: (prefs) async {
          final accessToken = prefs.getString('ACCESSTOKEN');
          AppDevConfig.isNetwork = await checkInternetConnectivity();
          if (accessToken == null) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const WelcomeScrn()),
            );
          } else if (accessToken.isEmpty) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginScrn()),
            );
          } else {
            AppDevConfig.userList = AppDevConfig.isNetwork
                ? await UsesRepo().fetchAllUsers()
                : await fetchAllUsers();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const DashboardScrn()),
            );
          }
        },
        loading: () {},
        error: (error, stackTrace) {},
      );
    },
  );
}

Future<bool> checkInternetConnectivity() async {
  try {
    final result = await InternetAddress.lookup('https://google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  }
  return false;
}
