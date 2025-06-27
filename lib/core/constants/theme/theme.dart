import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary gradient colors
  static const Color primaryMagenta = Color(0xFFCB6CE6);
  static const Color primaryGray = Color(0xFF737373);

  // Extended color palette
  static const Color deepMagenta = Color(0xFFB84DD6);
  static const Color lightMagenta = Color(0xFFE29BF0);
  static const Color darkGray = Color(0xFF4A4A4A);
  static const Color lightGray = Color(0xFF9E9E9E);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF1A1A1A);
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color cardBackground = Color(0xFFF8F9FA);
  static const Color Background = Color(0xFFF8F9FA);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryMagenta, primaryGray],
    stops: [0.0, 1.0],
  );

  static const LinearGradient reversePrimaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGray, primaryMagenta],
    stops: [0.0, 1.0],
  );

  static const LinearGradient lightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lightMagenta, lightGray],
    stops: [0.0, 1.0],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFAFAFA), Color(0xFFF0F0F0)],
    stops: [0.0, 1.0],
  );

  // Text Styles
  static const TextStyle headingLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: black,
    letterSpacing: -0.5,
  );

  static final TextStyle headingMedium = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: black,
    letterSpacing: -0.3,
  );

  static final TextStyle headingSmall = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: black,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: darkGray,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: darkGray,
    height: 1.4,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: lightGray,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: white,
  );

  // Shadows
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x1A000000),
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: Color(0x33CB6CE6),
      offset: Offset(0, 8),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: Color(0x1F000000),
      offset: Offset(0, 8),
      blurRadius: 32,
      spreadRadius: 0,
    ),
  ];

  // Border Radius
  static const BorderRadius cardRadius = BorderRadius.all(Radius.circular(16));
  static const BorderRadius buttonRadius =
      BorderRadius.all(Radius.circular(12));
  static const BorderRadius inputRadius = BorderRadius.all(Radius.circular(12));

  // App Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primaryMagenta,
        secondary: primaryGray,
        surface: white,
        background: cardBackground,
        error: error,
        onPrimary: white,
        onSecondary: white,
        onSurface: black,
        onBackground: black,
        onError: white,
      ),
      fontFamily: 'Inter',
      textTheme: TextTheme(
        displayLarge: headingLarge,
        displayMedium: headingMedium,
        displaySmall: headingSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        labelLarge: buttonText,
        bodySmall: caption,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryMagenta,
          foregroundColor: white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: const RoundedRectangleBorder(borderRadius: buttonRadius),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: buttonText,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryMagenta,
          side: const BorderSide(color: primaryMagenta, width: 1.5),
          shape: const RoundedRectangleBorder(borderRadius: buttonRadius),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: buttonText.copyWith(color: primaryMagenta),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryMagenta,
          textStyle: bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: primaryMagenta,
          ),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: inputRadius,
          borderSide: BorderSide(color: lightGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: inputRadius,
          borderSide: BorderSide(color: lightGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: inputRadius,
          borderSide: BorderSide(color: primaryMagenta, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: inputRadius,
          borderSide: BorderSide(color: error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: inputRadius,
          borderSide: BorderSide(color: error, width: 2),
        ),
        filled: true,
        fillColor: white,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: bodyMedium,
        hintStyle: TextStyle(color: lightGray),
      ),
      cardTheme: const CardTheme(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: cardRadius),
        color: white,
        shadowColor: Color(0x1A000000),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: black,
        titleTextStyle: headingMedium,
        centerTitle: true,
      ),
      scaffoldBackgroundColor: cardBackground,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  // Helper methods for creating gradient containers
  static Container gradientContainer({
    required Widget child,
    LinearGradient? gradient,
    BorderRadius? borderRadius,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
  }) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        gradient: gradient ?? primaryGradient,
        borderRadius: borderRadius ?? cardRadius,
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }

  static Container cardContainer({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
  }) {
    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      margin: margin,
      decoration: BoxDecoration(
        color: color ?? white,
        borderRadius: cardRadius,
        boxShadow: cardShadow,
      ),
      child: child,
    );
  }
}
