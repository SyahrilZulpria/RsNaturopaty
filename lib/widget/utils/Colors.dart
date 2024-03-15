import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color colorPrimary = const Color(0xfff4af07);
Color colorAccent = const Color(0xff38B6FF);
Color shadow = const Color(0x33666666);
Color formHint = const Color(0xffB0B3B4);
Color formColorDisabled = const Color(0xfff2f2f2);
Color lightGrey = const Color(0xffeeeeee);
Color formColor = const Color(0xffffffff);
Color formColorGreen = const Color(0xffDCF8C6); //green
Color formBorder = const Color(0xffdddddd);

const colorPrimary2 = Color(0xFF2697FF);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);
const defaultPadding = 16.0;

//Text Colors
const Color textPrimary = Color(0xFF333333);
const Color textSecondary = Color(0xFF272727);
const Color textWhite = Colors.white;

//Background Colors
const Color primaryBackground = Color(0xFFF3F5FF);
const Color secondaryBackground = Color(0xFF272727);
const Color headerBackground = Colors.purple;
const Color light = Color(0xFFF6F6F6);

//Erorr and Validation Colors
Color erorr = const Color(0xFFD32F2F);
Color sucsess = const Color(0xFF388E3C);
Color warning = const Color(0xFFF57C00);
Color info = const Color(0xFF1976D2);

// Natural Shades
Color Black = const Color(0xFF232323);
Color darkerGrey = const Color(0xFF4F4F4F);
Color darkGrey = const Color(0xFF939393);
Color dark = const Color(0xFF272727);
Color darkContainer = Colors.white.withOpacity(0.1);

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
    textStyle: const TextStyle(
        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
  );
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
    textStyle: const TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.bold,
    ),
  );
}
