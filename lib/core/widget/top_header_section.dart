import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/style/textstyle.dart';
import 'package:task_manager/core/utils/color/color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconTextRowWidget extends StatelessWidget {
  const IconTextRowWidget({super.key, required this.icon, required this.title});
  final IconData icon;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FaIcon(icon, color: fourthColor),
        sizedBox5W,
        Text(title, style: styleHeaderTop)
      ],
    );
  }
}
