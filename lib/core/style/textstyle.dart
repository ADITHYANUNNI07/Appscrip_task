import 'package:task_manager/core/utils/color/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle styleHeaderTop = GoogleFonts.sofiaSansCondensed(
  color: fourthColor,
  fontSize: 13,
);
TextStyle styleHeading = GoogleFonts.sofiaSansCondensed(
    color: fourthColor, fontSize: 30, fontWeight: FontWeight.w600);
TextStyle sizeHeading(
    {required double fontSize, Color? color, FontWeight? fontWeight}) {
  return GoogleFonts.sofiaSans(
    color: color ?? colorWhite,
    fontSize: fontSize,
    fontWeight: fontWeight ?? FontWeight.w800,
  );
}
