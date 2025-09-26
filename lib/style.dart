import 'package:flutter/material.dart';
import 'package:shopgoes/context.dart';

Color btcolor = const Color(0xFFFDD079);
Color bgcolor = const Color(0xFFF5F5F5);
const Color txtColor = Color.fromARGB(255, 247, 29, 178);

BoxDecoration deco1(
  BuildContext context, {
  required Color color,
  required bool isborder,
}) => BoxDecoration(
  border: isborder ? Border.all(color: Colors.black, width: 1) : null,
  color: color,
  borderRadius: context.radius(30),
);

TextStyle heading(BuildContext context, {Color? color}) => TextStyle(
  overflow: TextOverflow.ellipsis,
  fontSize: context.sp(20),
  fontWeight: FontWeight.bold,
  color: color ?? txtColor,
);

TextStyle subheading(BuildContext context, {Color? color}) => TextStyle(
  overflow: TextOverflow.ellipsis,
  fontSize: context.sp(16),
  fontWeight: FontWeight.w600,
  color: color ?? Colors.black,
);
TextStyle style167(BuildContext context, {Color? color}) => TextStyle(
  overflow: TextOverflow.ellipsis,
  fontSize: context.sp(16),
  fontWeight: FontWeight.bold,
  color: color ?? Colors.blue,
);

TextStyle style145(BuildContext context, {Color? color}) => TextStyle(
  overflow: TextOverflow.ellipsis,
  fontSize: context.sp(14),
  fontWeight: FontWeight.w500,
  color: color ?? Colors.black,
);

TextStyle planetxt(BuildContext context, {Color? color}) => TextStyle(
  overflow: TextOverflow.ellipsis,
  fontSize: context.sp(12),
  fontWeight: FontWeight.w400,
  color: color ?? Colors.black,
);

TextStyle style1(BuildContext context, {Color? color}) => TextStyle(
  overflow: TextOverflow.ellipsis,
  fontSize: context.sp(12),
  fontWeight: FontWeight.w400,
  color: color ?? Colors.black54,
);
