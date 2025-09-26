import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;

  double get screenHeight => MediaQuery.of(this).size.height;

  double px(double value) => screenWidth * (value / 375);

  double pxHeight(double value) => screenHeight * (value / 812);

   double sp(double value) => px(value); 

  BorderRadius radius(double value) => BorderRadius.circular(px(value));

  SizedBox sbHeight(double value) => SizedBox(height: pxHeight(value));
  SizedBox sbWidth(double value) => SizedBox(width: px(value));
}

extension StringCasingExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
