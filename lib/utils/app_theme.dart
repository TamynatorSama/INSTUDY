import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instudy/utils/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
      
        splashColor: Colors.transparent,
        dividerColor: AppColors.dividerColor,
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.white,
          elevation: 1,
            scrolledUnderElevation: 0, backgroundColor: Colors.white),
        dividerTheme: const DividerThemeData(
            thickness: 1, space: 0, color: Color(0xffEBEBEB)),
        checkboxTheme: CheckboxThemeData(
            checkColor: const WidgetStatePropertyAll(Colors.white),
            fillColor: WidgetStatePropertyAll(AppColors.primaryColor)),
        highlightColor: Colors.transparent,
        tabBarTheme: TabBarTheme(
            labelStyle: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textColorDark),
            unselectedLabelStyle: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textColorDark)),
        textTheme: TextTheme(
          titleLarge: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textColorDark),

          titleMedium: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textColorDark),
          titleSmall: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.textColorDark),
          bodyLarge: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textColorDark),
          bodyMedium: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textColorDark),
          bodySmall: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textColorDark),
          displayLarge: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textColorDark),
          displayMedium: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textColorDark),
          displaySmall: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textColorDark),
          labelSmall: GoogleFonts.museoModerno(
              fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white),
          labelLarge: GoogleFonts.plusJakartaSans(
              fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      );
}
