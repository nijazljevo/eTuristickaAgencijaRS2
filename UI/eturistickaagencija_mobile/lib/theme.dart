import 'package:flutter/material.dart';

class MyTheme {
  static const white = Color.fromRGBO(255, 255, 255, 1.0);
  static const black = Color.fromRGBO(0, 0, 0, 1.0);
  static const gray = Color.fromRGBO(173, 172, 172, 1.0);
  static const lightGray = Color.fromRGBO(243, 243, 243, 1.0);
  static const darkBlue = Color.fromRGBO(30, 64, 175, 0.2);

  static const green = Color.fromRGBO(132, 204, 22, 1.0);
  static const onlineGreen = Color.fromRGBO(101, 163, 13, 1.0);
  static const orange = Color.fromRGBO(249, 115, 22, 1.0);
}

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF1E40AF),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFF9F9F9),
  onPrimaryContainer: Color(0xFF21005D),
  secondary: Colors.transparent,
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFE9DDFF),
  onSecondaryContainer: Color(0xFF23005C),
  tertiary: Colors.transparent,
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Colors.transparent,
  onTertiaryContainer: Color(0xFF3E001F),
  error: Color(0xFFB3261E),
  errorContainer: Color(0xFFF9DEDC),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410E0B),
  background: Color(0xFFFFFFFF),
  onBackground: Color(0xFF1D1B20),
  surface: Color(0xFFFFFFFF),
  onSurface: Color(0xFF1D1B20),
  surfaceVariant: Color(0xFFE7E0EC),
  onSurfaceVariant: Color(0xFF49454F),
  outline: Color(0xFF767680),
  onInverseSurface: Color(0xFFF2F0F4),
  inverseSurface: Color(0xFF303034),
  inversePrimary: Color(0xFFB8C4FF),
  shadow: Color(0xFF000000),
  surfaceTint: Colors.transparent,
  outlineVariant: Color(0xFFC6C5D0),
  scrim: Color(0xFF000000),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF1E40AF),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFEADDFF),
  onPrimaryContainer: Color(0xFF21005D),
  secondary: Color(0xFF684FA4),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFE9DDFF),
  onSecondaryContainer: Color(0xFF23005C),
  tertiary: Color(0xFF984063),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFFFD9E3),
  onTertiaryContainer: Color(0xFF3E001F),
  error: Color(0xFFB3261E),
  errorContainer: Color(0xFFF9DEDC),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410E0B),
  background: Color(0xFFFEF7FF),
  onBackground: Color(0xFF1D1B20),
  surface: Color(0xFFFEF7FF),
  onSurface: Color(0xFF1D1B20),
  surfaceVariant: Color(0xFFE7E0EC),
  onSurfaceVariant: Color(0xFF49454F),
  outline: Color(0xFF767680),
  onInverseSurface: Color(0xFFF2F0F4),
  inverseSurface: Color(0xFF303034),
  inversePrimary: Color(0xFFB8C4FF),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF3755C3),
  outlineVariant: Color(0xFFC6C5D0),
  scrim: Color(0xFF000000),
);
