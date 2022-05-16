import 'package:flutter/material.dart';
import './colors.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle? kHeadingTextStyle = GoogleFonts.montserrat(
  color: AppThemes.lightTheme.textTheme.headline2!.color,
  fontWeight: FontWeight.w900,
  fontSize: 30.0,
  letterSpacing: -0.7,
);

final kButtonLightTextStyle = GoogleFonts.montserrat(
  color: AppThemes.lightTheme.scaffoldBackgroundColor,
  fontSize: 20.0,
  letterSpacing: -0.7,
);

final kButtonDarkTextStyle = GoogleFonts.montserrat(
  color: AppThemes.darkTheme.textTheme.button!.color,
  fontSize: 20.0,
  letterSpacing: -0.7,
);

final kAppBarTitleTextStyle = GoogleFonts.montserrat(
  color: AppThemes.lightTheme.textTheme.headline1!.color,
  fontSize: 24.0,
  fontWeight: FontWeight.w600,
  letterSpacing: -0.7,
);

final kBoldLabelStyle = GoogleFonts.montserrat(
  fontSize: 17.0,
  color: AppThemes.lightTheme.textTheme.bodyText1!.color,
  fontWeight: FontWeight.w600,
);

final kLabelStyle = GoogleFonts.montserrat(
  fontSize: 14.0,
  color: AppThemes.lightTheme.textTheme.bodyText1!.color,
);
