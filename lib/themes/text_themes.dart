import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CalsyncThemesText {
  static TextTheme calsyncTextThemeL = TextTheme(
    headline1: GoogleFonts.poppins(
      fontSize: 45,
      letterSpacing: 5,
      color: Color(0xFF000000),
    ),
    headline2: GoogleFonts.poppins(
      color: Color(0xFF000000),
    ),
    headline3: GoogleFonts.poppins(
      color: Color(0xFF000000),
    ),
    headline4: GoogleFonts.poppins(
      decorationStyle: TextDecorationStyle.double,
      decorationThickness: 10,
      color: Color(0xFF000000),
    ),
    headline5: GoogleFonts.poppins(
      color: Color(0xFF000000),
    ),
    headline6: GoogleFonts.poppins(
      fontSize: 20,
      color: Color(0xFF000000),
      fontWeight: FontWeight.w500,
    ),
    bodyText1: GoogleFonts.roboto(
      color: Color(0xFF000000),
    ),
    bodyText2: GoogleFonts.roboto(
      color: Color(0xFF000000),
    ),
    subtitle1: GoogleFonts.roboto(
      fontSize: 20,
      color: Color(0xFF000000),
    ),
    subtitle2: GoogleFonts.roboto(
        fontSize: 16, color: Color(0XFFC8C8C8).withOpacity(0.5)),
    caption: GoogleFonts.roboto(
      color: Color(0xFF000000),
    ),
  );

  static TextTheme calsyncTextThemeD = TextTheme(
    headline1: GoogleFonts.poppins(
      fontSize: 45,
      letterSpacing: 5,
      color: Color(0xFFFFFFFF),
    ),
    headline2: GoogleFonts.poppins(
      color: Color(0xFFFFFFFF),
    ),
    headline3: GoogleFonts.poppins(
      color: Colors.white,
    ),
    headline4: GoogleFonts.poppins(
      decorationStyle: TextDecorationStyle.double,
      decorationThickness: 10,
      color: Colors.white,
    ),
    headline5: GoogleFonts.poppins(
      color: Colors.white,
    ),
    headline6: GoogleFonts.poppins(
      fontSize: 20,
      color: Colors.white,
      fontWeight: FontWeight.w300,
    ),
    bodyText1: GoogleFonts.roboto(
      color: Colors.white,
    ),
    bodyText2: GoogleFonts.roboto(
      color: Colors.white,
    ),
    subtitle1: GoogleFonts.roboto(
      fontSize: 20,
      color: Colors.white,
    ),
    subtitle2: GoogleFonts.roboto(
        fontSize: 16, color: Color(0XFFC8C8C8).withOpacity(0.5)),
    caption: GoogleFonts.roboto(
      color: Colors.white,
    ),
  );
}
