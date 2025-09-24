import 'package:flutter/material.dart';

import 'blog_app_colors.dart';

class AppTheme {

  static _border([Color color = BlogAppColors.borderColor]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: color, width: 3),
      );

  static final darkThemeMode = ThemeData.dark(useMaterial3: true).copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: BlogAppColors.backgroundColor,
    ),
    scaffoldBackgroundColor: BlogAppColors.backgroundColor,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      enabledBorder: _border(),
      focusedBorder: _border(BlogAppColors.gradient2),
    ),
  );
}
