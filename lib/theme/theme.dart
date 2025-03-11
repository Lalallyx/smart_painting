import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_painting/ui/colors/colors.dart';

final darkTheme = ThemeData(
  highlightColor: Colors.transparent,
  splashFactory: NoSplash.splashFactory,
  colorScheme: ColorScheme.dark(primary: Colors.black),
  useMaterial3: true,
  scaffoldBackgroundColor: const Color.fromARGB(255, 0, 0, 0),
  textTheme: GoogleFonts.nunitoTextTheme(
    TextTheme(
      titleMedium: const TextStyle(
        color: AppColors.onPrimary,
        fontWeight: FontWeight.w900,
        fontSize: 35,
      ),
      titleSmall: const TextStyle(
        color: AppColors.onPrimary,
        fontWeight: FontWeight.w900,
        fontSize: 30,
      ),
      bodyMedium: const TextStyle(
        color: AppColors.onPrimary,
        fontWeight: FontWeight.w700,
        fontSize: 25,
      ),
      bodySmall: const TextStyle(
        color: AppColors.onPrimary,
        fontWeight: FontWeight.w700,
        fontSize: 20,
      ),
      labelLarge: const TextStyle(
        color: AppColors.onPrimary,
        fontWeight: FontWeight.w700,
        fontSize: 17,
      ),
      labelMedium: const TextStyle(
        color: AppColors.onPrimary,
        fontWeight: FontWeight.w500,
        fontSize: 15,
      ),
    ),
  ),
);
