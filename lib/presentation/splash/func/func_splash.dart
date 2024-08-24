import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/config/api_config.dart';
import 'package:task_manager/infrastructure/domain/service/users/uses_repo.dart';
import 'package:task_manager/infrastructure/helper/shared_preference.dart';
import 'package:task_manager/presentation/home/home.dart';
import 'package:task_manager/presentation/register/register.dart';

void splashtime(BuildContext context, WidgetRef ref) async {
  Future.delayed(
    const Duration(seconds: 2),
    () async {
      final asyncPrefs = ref.watch(sharedPreferencesProvider);

      asyncPrefs.when(
        data: (prefs) async {
          final accessToken = prefs.getString('ACCESSTOKEN');

          if (accessToken == null || accessToken.isEmpty) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const RegisterScrn()),
            );
          } else {
            AppDevConfig.userList = await UsesRepo().fetchAllUsers();
            print(AppDevConfig.userList);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScrn()),
            );
          }
        },
        loading: () {},
        error: (error, stackTrace) {},
      );
    },
  );
}
