//lib/helpers/helper.dart
import 'package:flutter/material.dart';

Color cPrimary = const Color(0xff2D336B);
Color cBlack   = const Color(0xff000000);
Color cError   = const Color(0xffFF4545);

OutlineInputBorder enableBorder = OutlineInputBorder(
  borderSide: const BorderSide(color: Colors.black),
  borderRadius: BorderRadius.circular(5),
);
OutlineInputBorder focusedBorder = OutlineInputBorder(
  borderSide: BorderSide(color: cPrimary),
  borderRadius: BorderRadius.circular(5),
);