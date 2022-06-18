import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xffF7F7F7),
  fontFamily: 'CharisSIL',
  colorScheme: const ColorScheme(
    primary: black,
    secondary: black,
    surface: black,
    background: black,
    error: black,
    onPrimary: black,
    onSecondary: black,
    onSurface: black,
    onBackground: black,
    onError: black,
    brightness: Brightness.light,
  ),
  textTheme: const TextTheme(
    bodyText2: TextStyle(color: Color(0xff222831)),
    subtitle1: TextStyle(color: Color(0xff9D9D9D), fontSize: 12),
  ),
);

const black = Color(0xff222831);
final green = Colors.green.shade300;
final orange = Colors.orange.shade300;
