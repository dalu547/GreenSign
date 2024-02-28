import 'dart:ui';
import 'package:DigiSign/core/utils/size_utils.dart';
import 'package:flutter/material.dart';

String _appTheme = "primary";

/// Helper class for managing themes and colors.
class ThemeHelper {
  // A map of custom color themes supported by the app
  Map<String, PrimaryColors> _supportedCustomColor = {
    'primary': PrimaryColors()
  };

// A map of color schemes supported by the app
  Map<String, ColorScheme> _supportedColorScheme = {
    'primary': ColorSchemes.primaryColorScheme
  };

  /// Returns the primary colors for the current theme.
  PrimaryColors _getThemeColors() {
    //throw exception to notify given theme is not found or not generated by the generator
    if (!_supportedCustomColor.containsKey(_appTheme)) {
      throw Exception(
          "$_appTheme is not found.Make sure you have added this theme class in JSON Try running flutter pub run build_runner");
    }
    //return theme from map

    return _supportedCustomColor[_appTheme] ?? PrimaryColors();
  }

  /// Returns the current theme data.
  ThemeData _getThemeData() {
    //throw exception to notify given theme is not found or not generated by the generator
    if (!_supportedColorScheme.containsKey(_appTheme)) {
      throw Exception(
          "$_appTheme is not found.Make sure you have added this theme class in JSON Try running flutter pub run build_runner");
    }
    //return theme from map

    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.primaryColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      textTheme: TextThemes.textTheme(colorScheme),
      scaffoldBackgroundColor: appTheme.whiteA700,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: appTheme.amber700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.h),
          ),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          side: BorderSide(
            color: appTheme.gray600,
            width: 1.h,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.h),
          ),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      dividerTheme: DividerThemeData(
        thickness: 1,
        space: 1,
        color: appTheme.gray400,
      ),
    );
  }

  /// Returns the primary colors for the current theme.
  PrimaryColors themeColor() => _getThemeColors();

  /// Returns the current theme data.
  ThemeData themeData() => _getThemeData();

}

/// Class containing the supported text theme styles.
class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
        bodyLarge: TextStyle(
          color: appTheme.black900,
          fontSize: 17.fSize,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: appTheme.blueGray500,
          fontSize: 13.fSize,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: appTheme.blueGray500,
          fontSize: 12.fSize,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w400,
        ),
        displayLarge: TextStyle(
          color: appTheme.blueGray90001,
          fontSize: 64.fSize,
          fontFamily: 'Island Moments',
          fontWeight: FontWeight.w400,
        ),
        displaySmall: TextStyle(
          color: appTheme.black900,
          fontSize: 36.fSize,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w400,
        ),
        headlineSmall: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 24.fSize,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
        ),
        labelLarge: TextStyle(
          color: appTheme.whiteA700,
          fontSize: 12.fSize,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          color: appTheme.blueGray400,
          fontSize: 10.fSize,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: appTheme.black900,
          fontSize: 22.fSize,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w500,
        ),
        titleMedium: TextStyle(
          color: appTheme.black900,
          fontSize: 17.fSize,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: colorScheme.primary,
          fontSize: 15.fSize,
          fontFamily: 'SF Pro',
          fontWeight: FontWeight.w500,
        ),
      );
}

/// Class containing the supported color schemes.
class ColorSchemes {
  static final primaryColorScheme = ColorScheme.light(
    // Primary colors
    primary: Color(0XFF007BFE),
    secondaryContainer: Color(0XA2446BF2),

    // On colors(text colors)
    onPrimary: Color(0XFF1D1B20),
    onPrimaryContainer: Color(0XFF1ED4D4),
  );
}

/// Class containing custom colors for a primary theme.
class PrimaryColors {
  // Amber
  Color get amber700 => Color(0XFFF59E0B);

  // Black
  Color get black900 => Color(0XFF000000);

  // Blue
  Color get blueA200 => Color(0XFF3B82F6);

  // BlueGray
  Color get blueGray100 => Color(0XFFCBD5E1);
  Color get blueGray10001 => Color(0XFFCCCCCC);
  Color get blueGray10002 => Color(0XFFCAC4D0);
  Color get blueGray10087 => Color(0X87D2D2D7);
  Color get blueGray400 => Color(0XFF8E8E93);
  Color get blueGray500 => Color(0XFF64748B);
  Color get blueGray900 => Color(0XFF373435);
  Color get blueGray90001 => Color(0XFF1E293B);

  // DeepPurple
  Color get deepPurpleA200 => Color(0XFF725CF8);

  // Gray
  Color get gray100 => Color(0XFFEFF6FF);
  Color get gray200 => Color(0XFFE6E6EB);
  Color get gray400 => Color(0XFFC7C7CC);
  Color get gray50 => Color(0XFFF5FBFE);
  Color get gray5001 => Color(0XFFF8FAFC);
  Color get gray600 => Color(0XFF79747E);
  Color get gray800 => Color(0XFF49454F);
  Color get gray80099 => Color(0X993C3C43);
  Color get gray900 => Color(0XFF1C1C1E);

  // Green
  Color get greenA700 => Color(0XFF22C55E);

  // Indigo
  Color get indigo50 => Color(0XFFE2E8F0);

  // LightBlue
  Color get lightBlue50 => Color(0XFFE0FAFF);
  Color get lightBlue600 => Color(0XFF0EA5E9);
  Color get lightBlueA700 => Color(0XFF007AFF);

  // Red
  Color get red500 => Color(0XFFEF4444);
  Color get red50001 => Color(0XFFFF3B30);

  // White
  Color get whiteA700 => Color(0XFFFFFFFF);
}

PrimaryColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();
