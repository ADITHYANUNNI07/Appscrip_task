import 'package:flutter/material.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toasty_box.dart';

class NotificationHandler {
  static snakBarSuccess(String message, BuildContext context) {
    return ToastService.showSuccessToast(
      context,
      length: ToastLength.medium,
      expandedHeight: 100,
      message: message,
    );
  }

  static snakBarWarning(String message, BuildContext context) {
    return ToastService.showWarningToast(
      context,
      length: ToastLength.medium,
      expandedHeight: 100,
      message: message,
    );
  }

  static snakBarError(String message, BuildContext context) {
    return ToastService.showErrorToast(
      context,
      length: ToastLength.medium,
      expandedHeight: 100,
      message: message,
    );
  }
}
