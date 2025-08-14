import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Color Palette
  static const Color primaryColor = Color(0xFF6366F1);
  static const Color primaryDark = Color(0xFF3B82F6); // Blue-500
  static const Color primaryDeep = Color(0xFF1D4ED8);
  static const Color backgroundColor = Color(0xFFF8FAFC);
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFEF4444);
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color borderColor = Color(0xFFE5E7EB);
  static ThemeData get themeData => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.light,
          primary: primaryColor,
          secondary: primaryDark,
          surface: surfaceColor,
          background: backgroundColor,
          error: errorColor,
        ),
        scaffoldBackgroundColor: backgroundColor,
        textTheme: TextTheme(
          displayLarge: thaiFont(
              fontSize: 32, fontWeight: FontWeight.bold, color: textPrimary),
          displayMedium: thaiFont(
              fontSize: 28, fontWeight: FontWeight.bold, color: textPrimary),
          displaySmall: thaiFont(
              fontSize: 24, fontWeight: FontWeight.bold, color: textPrimary),
          headlineLarge: thaiFont(
              fontSize: 22, fontWeight: FontWeight.w600, color: textPrimary),
          headlineMedium: thaiFont(
              fontSize: 20, fontWeight: FontWeight.w600, color: textPrimary),
          headlineSmall: thaiFont(
              fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary),
          titleLarge: thaiFont(
              fontSize: 20, fontWeight: FontWeight.w600, color: textPrimary),
          titleMedium: thaiFont(
              fontSize: 18, fontWeight: FontWeight.w500, color: textPrimary),
          titleSmall: thaiFont(
              fontSize: 16, fontWeight: FontWeight.w500, color: textPrimary),
          bodyLarge: thaiFont(fontSize: 16, color: textPrimary),
          bodyMedium: thaiFont(fontSize: 14, color: textPrimary),
          bodySmall: thaiFont(fontSize: 12, color: textSecondary),
          labelLarge: thaiFont(
              fontSize: 14, fontWeight: FontWeight.w500, color: textPrimary),
          labelMedium: thaiFont(
              fontSize: 12, fontWeight: FontWeight.w500, color: textSecondary),
          labelSmall: thaiFont(
              fontSize: 6, fontWeight: FontWeight.w500, color: textSecondary),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: thaiFont(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: surfaceColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            textStyle: thaiFont(fontSize: 14, fontWeight: FontWeight.w500),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: primaryColor,
            textStyle: thaiFont(fontSize: 14, fontWeight: FontWeight.w500),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            side: const BorderSide(color: primaryColor),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryColor,
            textStyle: thaiFont(fontSize: 14, fontWeight: FontWeight.w500),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: errorColor),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          labelStyle: thaiFont(fontSize: 14, color: textSecondary),
          hintStyle: thaiFont(fontSize: 14, color: textSecondary),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: textPrimary,
          contentTextStyle: thaiFont(fontSize: 14, color: Colors.white),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          behavior: SnackBarBehavior.floating,
        ),
        dialogTheme: DialogThemeData(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          titleTextStyle: thaiFont(
              fontSize: 18, fontWeight: FontWeight.w600, color: textPrimary),
          contentTextStyle: thaiFont(fontSize: 14, color: textPrimary),
        ),
        tabBarTheme: TabBarThemeData(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: thaiFont(fontSize: 14, fontWeight: FontWeight.w600),
          unselectedLabelStyle:
              thaiFont(fontSize: 12, fontWeight: FontWeight.w500),
          indicator: BoxDecoration(
            color: Colors.white.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );

  static TextStyle thaiFont({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return GoogleFonts.notoSansThai(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  // Gradient AppBar Theme
  static PreferredSizeWidget gradientAppBar({
    required String title,
    List<Widget>? actions,
    Widget? leading,
  }) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      flexibleSpace: Container(
        decoration: gradientDecoration,
      ),
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      actions: actions,
      leading: leading,
    );
  }

  // Gradient decoration for custom AppBar containers
  static const BoxDecoration gradientDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color(0xFF6366F1), // Indigo-500
        Color(0xFF4F46E5), // Indigo-600
        Color(0xFF3730A3), // Indigo-700
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
  );

  // Custom SnackBar styles
  static SnackBar successSnackBar(String message) {
    return SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(child: Text(message, style: thaiFont(color: Colors.white))),
        ],
      ),
      backgroundColor: successColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 2),
    );
  }

  static SnackBar errorSnackBar(String message) {
    return SnackBar(
      content: Row(
        children: [
          const Icon(Icons.error, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(child: Text(message, style: thaiFont(color: Colors.white))),
        ],
      ),
      backgroundColor: errorColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 3),
    );
  }

  static SnackBar warningSnackBar(String message) {
    return SnackBar(
      content: Row(
        children: [
          const Icon(Icons.warning, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(child: Text(message, style: thaiFont(color: Colors.white))),
        ],
      ),
      backgroundColor: warningColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      duration: const Duration(seconds: 2),
    );
  }
}
