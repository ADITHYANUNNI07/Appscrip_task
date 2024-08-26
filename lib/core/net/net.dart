import 'package:flutter/material.dart';
import 'package:task_manager/core/config/api_config.dart';
import 'package:task_manager/core/notification/notification.dart';

networkResponseFun(BuildContext context, bool hasInternetAccess) {
  if (!hasInternetAccess) {
    NotificationHandler.snakBarWarning('You are offline', context);
    AppDevConfig.isNetwork = false;
  } else {
    if (!AppDevConfig.isNetwork) {
      NotificationHandler.snakBarSuccess('You are online', context);
      AppDevConfig.isNetwork = true;
    }
  }
}
