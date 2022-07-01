import 'package:flutter/material.dart';

class TaskistTheme {
  static final darkTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    backgroundColor: const Color(0xFF212121),
    dividerColor: Colors.black12,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF212121),

    ),
  );

  static final lightTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.white,
    brightness: Brightness.light,
    backgroundColor: const Color(0xFFE5E5E5),
    dividerColor: Colors.white54,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFE5E5E5), 
    ),
    
  );
}
