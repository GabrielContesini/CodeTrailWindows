import 'package:flutter/material.dart';

double responsiveDialogWidth(
  BuildContext context, {
  required double ideal,
  double min = 320,
  double horizontalMargin = 96,
}) {
  final available = MediaQuery.sizeOf(context).width - horizontalMargin;
  if (available <= min) {
    return min;
  }
  if (available >= ideal) {
    return ideal;
  }
  return available;
}
