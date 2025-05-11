import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final Color primaryYellow = Color(0xFFF8CC66);

class MyShopStyle {
  static ThemeData theme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    textTheme: GoogleFonts.latoTextTheme(),
    primaryColor: primaryYellow,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryYellow,
      primary: primaryYellow,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryYellow,
      foregroundColor: Colors.black,
    ),
  );

  // Qo‘shimcha shriftlar
  // static TextStyle poppinsStyle = GoogleFonts.poppins(
  //   fontSize: 20,
  //   fontWeight: FontWeight.bold,
  //   color: Colors.black,
  // );

  // static TextStyle robotoStyle = GoogleFonts.roboto(
  //   fontSize: 18,
  //   fontWeight: FontWeight.w500,
  //   color: Colors.blue,
  // );
}
