import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 18),
          bodySmall: TextStyle(fontSize: 17),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      home: HomeScreen(),
    ),
  );
}
