import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
      primaryColor: const Color(0xFF2671AB),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: const MaterialColor(
          0xFF2671AB,
          {
            50: Color(0xFF2671AB),
            100: Color(0xFF2671AB),
            200: Color(0xFF2671AB),
            300: Color(0xFF2671AB),
            400: Color(0xFF2671AB),
            500: Color(0xFF2671AB),
            600: Color(0xFF2671AB),
            700: Color(0xFF2671AB),
            800: Color(0xFF2671AB),
            900: Color(0xFF2671AB),
          },
        ),
      ).copyWith(
        secondary: Colors.white,
        // background: Colors.white,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: const Color.fromARGB(255, 71, 70, 70),
        onSurface: const Color.fromARGB(255, 71, 70, 70),
        // onBackground: const Color.fromARGB(255, 71, 70, 70),
        onError: Colors.white,
        error: Colors.red,
      ),
      scaffoldBackgroundColor: Colors.white,
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Color.fromARGB(255, 71, 70, 70)),
        displayMedium: TextStyle(color: Color.fromARGB(255, 71, 70, 70)),
        displaySmall: TextStyle(color: Color.fromARGB(255, 71, 70, 70)),
        headlineLarge: TextStyle(color: Color.fromARGB(255, 71, 70, 70)),
        headlineMedium: TextStyle(color: Color.fromARGB(255, 71, 70, 70)),
        headlineSmall: TextStyle(color: Color.fromARGB(255, 71, 70, 70)),
        titleLarge: TextStyle(color: Color.fromARGB(255, 71, 70, 70)),
        titleMedium: TextStyle(color: Color.fromARGB(255, 71, 70, 70)),
        titleSmall: TextStyle(color: Color.fromARGB(255, 71, 70, 70)),
        bodyLarge: TextStyle(color: Color.fromARGB(255, 71, 70, 70)),
        bodyMedium: TextStyle(color: Color.fromARGB(255, 71, 70, 70)),
        bodySmall: TextStyle(color: Color.fromARGB(255, 71, 70, 70)),
        labelLarge: TextStyle(color: Color.fromARGB(255, 71, 70, 70)),
        labelMedium: TextStyle(color: Color.fromARGB(255, 71, 70, 70)),
        labelSmall: TextStyle(color: Color.fromARGB(255, 71, 70, 70)),
      ),
      appBarTheme: const AppBarTheme(
          foregroundColor: Color(0xFF2671AB),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white),
      buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFF2671AB), // Default button color
          textTheme: ButtonTextTheme.primary),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2671AB), // Button background color
        foregroundColor: Colors.white, // Button text color
      )),
      iconTheme: const IconThemeData(color: Color(0xFF2671AB)),
      inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF2671AB))),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF2671AB))),
          errorBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          disabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF2671AB))),
          labelStyle: TextStyle(color: Color.fromARGB(255, 71, 70, 70)),
          prefixStyle: TextStyle(color: Color.fromARGB(255, 71, 70, 70)),
          suffixStyle: TextStyle(color: Color.fromARGB(255, 71, 70, 70)),
          prefixIconColor: Color(0xFF2671AB),
          suffixIconColor: Color(0xFF2671AB),
          iconColor: Color(0xFF2671AB)));
}

/// color
Color primaryColor = const Color(0xFF2671AB);
Color amberColor = const Color(0xFFFFC107);
Color greenColor = const Color(0xFF4CAF50);
Color redColor = const Color(0xFFF44336);
Color whiteColor = const Color(0xFFFFFFFF);
Color transparent = Colors.transparent;
Color greyColor = Colors.grey;
Color blackColor = Colors.black;

/// State colors
Color draftColor = const Color.fromARGB(255, 127, 135, 139);
Color submitColor = const Color.fromARGB(255, 230, 191, 67);
Color approvedColor = const Color.fromARGB(255, 5, 180, 8);
Color rejectedColor = const Color.fromARGB(255, 236, 20, 20);
Color claimColor = const Color(0xFF2671AB);
Color onProgressColor = Colors.orange;

/// text style
TextStyle appBarStyle = TextStyle(
    fontSize: 16,
    color: primaryColor,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.2);

TextStyle titleStyle15 = const TextStyle(
    fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w500);

TextStyle titleStyle14 = const TextStyle(
    fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500);

TextStyle titleStyle10 = const TextStyle(
    fontSize: 10, color: Colors.black87, fontWeight: FontWeight.w500);

TextStyle titleStyle11 = const TextStyle(
    fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w500);

TextStyle titleStyle12 = const TextStyle(
    fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w500);

TextStyle titleStyle13 = const TextStyle(
    fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w500);

TextStyle style15Bold400 = const TextStyle(
    fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w400);

TextStyle primary15Bold500 =
    TextStyle(fontSize: 15, color: primaryColor, fontWeight: FontWeight.w500);

TextStyle primary15Bold =
    TextStyle(fontSize: 15, color: primaryColor, fontWeight: FontWeight.bold);

TextStyle primary14Bold =
    TextStyle(fontSize: 14, color: primaryColor, fontWeight: FontWeight.bold);

TextStyle primary12Bold =
    TextStyle(fontSize: 12, color: primaryColor, fontWeight: FontWeight.bold);

TextStyle primary13Bold =
    TextStyle(fontSize: 13, color: primaryColor, fontWeight: FontWeight.bold);

TextStyle hintStyle = TextStyle(
    fontSize: 12, color: Colors.grey[400], fontWeight: FontWeight.w400);

TextStyle white12Bold = const TextStyle(
    fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold);

TextStyle white13Bold = const TextStyle(
    fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold);

/// dimension
double mainPadding = 15.0;
double mainRadius = 20.0;

/// Spacer
SizedBox widthSpace = const SizedBox(width: 15);
SizedBox width5Space = const SizedBox(width: 5);
SizedBox width10Space = const SizedBox(width: 10);
SizedBox heithSpace = const SizedBox(height: 15);
SizedBox heith5Space = const SizedBox(height: 5);
SizedBox heith10Space = const SizedBox(height: 10);
SizedBox sizedBoxShrink = const SizedBox.shrink();
List multiheithSpace(int index) => List.generate(index, (i) => heithSpace);
List multiWidthSpace(int index) => List.generate(index, (i) => widthSpace);
