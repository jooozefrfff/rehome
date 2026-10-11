import 'package:flutter/material.dart';

/// Nom provisoire de l'application : à changer ici.
const appName = 'ReHome';

class C {
  static const fond = Color(0xFFF7FAFB);
  static const bleu = Color(0xFF4C8FBF);
  static const vert = Color(0xFF5DB89A);
  static const encre = Color(0xFF1F3A4D);
  static const brume = Color(0xFFE3EEF3);
  static const gris = Color(0xFF6B8494);
}

ThemeData buildTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: C.bleu,
    primary: C.bleu,
    secondary: C.vert,
    surface: Colors.white,
    brightness: Brightness.light,
  );
  OutlineInputBorder border(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: c, width: 1.4),
      );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: C.fond,
    textTheme: Typography.material2021()
        .black
        .apply(bodyColor: C.encre, displayColor: C.encre),
    appBarTheme: const AppBarTheme(
      backgroundColor: C.fond,
      foregroundColor: C.encre,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
          fontSize: 24, fontWeight: FontWeight.w700, color: C.encre),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(58),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(54),
        foregroundColor: C.encre,
        side: const BorderSide(color: C.brume, width: 1.6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: border(C.brume),
      enabledBorder: border(C.brume),
      focusedBorder: border(C.bleu),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: C.brume,
    ),
  );
}
