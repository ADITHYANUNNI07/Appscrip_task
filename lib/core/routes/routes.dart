import 'package:flutter/material.dart';
import 'package:task_manager/core/constant/enum.dart';

class NavigationHandler {
  static void navigateTo(BuildContext context, Widget screen) =>
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => screen),
      );

  static void navigateOff(BuildContext context, Widget screen) =>
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );

  static void navigateKill(BuildContext context, Widget screen) =>
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => screen),
        (route) => false,
      );

  static void pop(BuildContext context,
      {ScreenPopCount screenPopCount = ScreenPopCount.one}) {
    int pops = screenPopCount.index + 1;
    Navigator.of(context).popUntil((route) => pops-- <= 0);
  }
}
