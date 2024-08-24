import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task_manager/core/constant/constant.dart';
import 'package:task_manager/core/utils/color/color.dart';

class TextFormWidget extends StatelessWidget {
  const TextFormWidget({
    super.key,
    required this.label,
    this.controller,
    this.validator,
    required this.icon,
    this.suffixicon,
    this.suffixOnpress,
    this.obscurebool = false,
    this.onChanged,
    this.hintText,
    this.keyboardType,
    this.suffixIconColor,
    this.isPassword = false,
    this.errorText,
    this.maxLength,
    this.maxLines,
    this.isNolabel = false,
  });

  final String label;
  final String? hintText;
  final String? errorText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final IconData icon;
  final IconData? suffixicon;
  final void Function()? suffixOnpress;
  final void Function(String?)? onChanged;
  final bool obscurebool;
  final Color? suffixIconColor;
  final TextInputType? keyboardType;
  final bool isPassword;
  final int? maxLength;
  final int? maxLines;
  final bool isNolabel;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        !isNolabel ? sizedBox15H : Container(),
        !isNolabel
            ? Row(
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              )
            : Container(),
        !isNolabel ? sizedBox10H : Container(),
        TextFormField(
          maxLines: maxLines ?? 1,
          maxLength: maxLength,
          keyboardType: keyboardType,
          style: const TextStyle(color: colorBlack),
          onChanged: onChanged,
          obscureText: isPassword,
          controller: controller,
          decoration: InputDecoration(
            errorText: errorText,
            filled: true,
            fillColor: colorWhite,
            suffixIcon: IconButton(
              onPressed: suffixOnpress,
              icon: FaIcon(
                suffixicon,
                color: suffixIconColor,
              ),
            ),
            prefixIcon: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(icon),
              ],
            ),
            labelText: label,
            hintText: hintText,
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: colorApp,
              ),
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
          ),
          validator: validator,
        ),
      ],
    );
  }
}
