import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'views/views.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Makita Chronicles',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(context),
      home: HomePage(),
    );
  }

  ThemeData _buildTheme(BuildContext context) {
    final theme = GoogleFonts.interTextTheme();
    final textColor = Colors.white;

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.black,
      colorScheme: ColorScheme.fromSeed(
        primary: Colors.black,
        secondary: Colors.white,
        tertiary: Colors.deepPurple,
        seedColor: Colors.amberAccent,
        brightness: Brightness.dark,
      ),
      textTheme: TextTheme(
        displayLarge: theme.displayLarge?.copyWith(color: textColor),
        displayMedium: theme.displayMedium?.copyWith(color: textColor),
        displaySmall: theme.displaySmall?.copyWith(color: textColor),
        headlineLarge: theme.headlineLarge?.copyWith(color: textColor),
        headlineMedium: theme.headlineMedium?.copyWith(color: textColor),
        headlineSmall: theme.headlineSmall?.copyWith(color: textColor),
        titleLarge: theme.titleLarge?.copyWith(color: textColor),
        titleMedium: theme.titleMedium?.copyWith(color: textColor),
        titleSmall: theme.titleSmall?.copyWith(color: textColor),
        bodyLarge: theme.bodyLarge?.copyWith(color: textColor),
        bodyMedium: theme.bodyMedium?.copyWith(color: textColor),
        bodySmall: theme.bodySmall?.copyWith(color: textColor),
        labelLarge: theme.labelLarge?.copyWith(color: textColor),
        labelMedium: theme.labelMedium?.copyWith(color: textColor),
        labelSmall: theme.labelSmall?.copyWith(color: textColor),
      ),
      iconTheme: IconThemeData(
        color: textColor,
      ),
      appBarTheme: AppBarTheme(
        surfaceTintColor: Colors.grey.shade900,
        backgroundColor: Colors.grey.shade900,
        iconTheme: IconThemeData(
          color: textColor,
          size: 20.0,
        ),
        titleTextStyle: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      listTileTheme: ListTileThemeData(
        textColor: textColor,
        iconColor: textColor,
      ),
      cardTheme: CardThemeData(
        color: Colors.grey.shade900,
      ),
    );
  }
}
