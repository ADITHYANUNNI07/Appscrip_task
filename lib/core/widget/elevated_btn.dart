import 'package:task_manager/core/constant/constant.dart';
import 'package:flutter/material.dart';

class ElevatedBtnWidget extends StatelessWidget {
  const ElevatedBtnWidget({
    super.key,
    required this.onPressed,
    required this.title,
    this.btnColor,
    this.borderColor,
    this.leading,
    this.colorTitle,
  });
  final void Function()? onPressed;
  final String title;
  final Color? btnColor;
  final Color? borderColor;
  final Widget? leading;
  final Color? colorTitle;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: BorderSide(color: borderColor ?? Colors.transparent),
        ),
        backgroundColor: btnColor ?? Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          leading ?? Container(),
          leading != null ? sizedBox10W : Container(),
          Text(
            title,
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.w500, color: colorTitle),
          ),
        ],
      ),
    );
  }
}
