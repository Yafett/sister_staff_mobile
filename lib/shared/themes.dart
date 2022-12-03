import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color kBlueColor = const Color(0xff1F98A8);
Color kWhiteColor = Colors.white;
Color kBlackColor = const Color(0xff2C2C2C);
Color sWhiteColor = const Color(0xffC9D1D9);
Color sGreyColor = const Color(0xff272C33);
Color sBlackColor = const Color(0xff0D1117);
Color sRedColor = const Color(0xffD15151);
Color sGreenColor = const Color(0xff347D39);
Color sYellowColor = const Color(0xffE7A100);
Color sCardColor = const Color(0xff181B1E);
Color sBlueColor = const Color(0xff005EBC);
Color sOrangeColor = const Color(0xffF8814F);

// ! first Section
TextStyle fWhiteTextStyle = GoogleFonts.openSans(color: Colors.white);
TextStyle fBlackTextStyle = GoogleFonts.openSans(color: Colors.black);
TextStyle fGreyTextStyle = GoogleFonts.openSans(color: Colors.grey);
TextStyle fTextColorStyle =
    GoogleFonts.openSans(color: const Color(0xff8E8E8E));
TextStyle fTermsColorStyle =
    GoogleFonts.openSans(color: const Color(0xff616161));

// ! second Section
TextStyle sWhiteTextStyle =
    GoogleFonts.openSans(color: const Color(0xffC9D1D9));
TextStyle sBlackTextStyle =
    GoogleFonts.openSans(color: const Color(0xff0D1117));
TextStyle sGreyTextStyle = GoogleFonts.openSans(color: const Color(0xff6B7178));
TextStyle sRedTextStyle = GoogleFonts.openSans(color: const Color(0xffD15151));
TextStyle sGreenTextStyle = GoogleFonts.openSans(color: const Color(0xff347D39));

BorderRadius radiusNormal = BorderRadius.circular(12);

FontWeight extraLight = FontWeight.w100;
FontWeight light = FontWeight.w200;
FontWeight regular = FontWeight.w300;
FontWeight medium = FontWeight.w400;
FontWeight semi = FontWeight.w500;
FontWeight semiBold = FontWeight.bold;

// ! URL
String baseUrl = 'https://njajal.sekolahmusik.co.id/api';

class NoScrollWaves extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
