import 'package:flutter/material.dart';

class CustomThemeData {
  ThemeData value(BuildContext context, Size size) => ThemeData(
        colorSchemeSeed: const Color.fromARGB(255, 44, 27, 14),
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          headlineSmall: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          activeIndicatorBorder: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            minimumSize: WidgetStatePropertyAll<Size>(
              Size(size.width * 0.3, 50),
            ),
            shape: WidgetStatePropertyAll<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
            minimumSize: WidgetStatePropertyAll<Size>(
              Size(size.width * 0.3, 50),
            ),
            shape: WidgetStatePropertyAll<OutlinedBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context) //
              .colorScheme
              .inversePrimary,
        ),
      );
}
