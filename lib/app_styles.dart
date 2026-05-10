import 'package:flutter/material.dart';

class AppStyles {
  // --- 1. Colors ---
  static const Color primaryColor = Color(0xFF673AB7); // Deep Purple
  static const Color accentColor = Color(0xFF03DAC6);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color errorColor = Color(0xFFB00020);
  static const Color textPrimary = Color(0xFF212121);

  // --- 2. Spacing (Padding & Margins) ---
  static const double defaultPadding = 16.0;
  static const double elementSpacing = 20.0;
  static const EdgeInsets screenPadding = EdgeInsets.all(defaultPadding);

  // --- 3. Text Styles ---
  static const TextStyle headerStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    letterSpacing: 1.2,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: Colors.grey,
  );

  // --- 4. Container Decorations ---
  static BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );
}