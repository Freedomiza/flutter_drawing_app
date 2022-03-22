import 'package:flutter/material.dart';

abstract class Styles {
  static const primaryColor = Color(0xFF005FA3);
  static const secondaryColor = Color(0xFFFD650D);
  static const lightGreyColor = Color(0xFFf5f5f5);
  static const errorColor = Color(0xFFE57373);

  static const darkColor = Color(0xFF0D0C0C);
  static const greyColor = Color(0xFFA5A2A2);

  static const lightColor = Color(0xFFFFFFFF);
  static const panelColor = Color(0xFFb5b5b5);
  static const mediumLightColor = Color(0xFFFAFAFA);

  // Opacity
  static const lowOpacity = 0.33;
  static const lightOpacity = 0.16;
  static const highOpacity = 0.66;

  // Background
  static const backgroundColor = lightColor;
  static const darkBackgroundColor = darkColor;
  static final shadowColor = greyColor.withOpacity(lightOpacity);
  static final activeShadowColor = greyColor.withOpacity(highOpacity);

  static const primaryGradientColor = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFFA53E), Color(0xFFFF7643)]);

  // Size and padding etc ...
  static const double defaultPadding = 15;
  static const double buttonHeight = 50;
  static const double defaultButtonRadius = 4;
  static const double bigButtonRadius = 24;

  // Text Color
  static const titleColor = darkColor;
  static const bodyTextColor = darkBackgroundColor;
  static const textLightColor = lightColor;
  static const buttonTextColor = Color(0xFFFFFFFF);
  // Font
  static const double bodyFontSize = 16;
  static const double heading1FontSize = 44;
  static const double heading2FontSize = 33;
  static const double heading6FontSize = 24;

  static const disabledOpacity = 0.33;
  static const inactiveOpacity = 0.66;
}
