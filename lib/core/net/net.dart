import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_manager/core/config/api_config.dart';
import 'package:task_manager/core/notification/notification.dart';
import 'package:task_manager/infrastructure/riverpod/todo/todo_provider.dart';

networkResponseFun(BuildContext context, bool hasInternetAccess,
    {WidgetRef? ref}) {
  if (!hasInternetAccess) {
    NotificationHandler.snakBarWarning('You are offline', context);
    AppDevConfig.isNetwork = false;
  } else {
    if (!AppDevConfig.isNetwork) {
      if (ref != null) {
        ref.read(todoNotifierProvider.notifier).getTodo(ref);
      }
      NotificationHandler.snakBarSuccess('You are online', context);
      AppDevConfig.isNetwork = true;
    }
  }
}
