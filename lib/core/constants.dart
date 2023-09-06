import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

int desktopWidthConstraint = 1100;
int tabletWidthConstraint = 500;
int mobileWidthConstraint = 400;

GlobalKey<ScaffoldMessengerState> scaffoldKey =
    GlobalKey<ScaffoldMessengerState>();

String parseEnumName(String enumString) {
  String nameCamelCase = enumString.split('.').last;
  String formattedString = nameCamelCase
      .replaceAllMapped(RegExp(r'[A-Z]'), (Match m) => ' ${m[0]}')
      .capitalize;
  return formattedString;
}

// Convert int to money, use K for thousands, M for millions, B for billions
String convertIntToMoney(int number) {
  NumberFormat formatter = NumberFormat.simpleCurrency(decimalDigits: 0);
  if (number >= 1000000000) {
    return '${formatter.format(number / 1000000000)}B';
  } else if (number >= 1000000) {
    return '${formatter.format(number / 1000000)}M';
  } else if (number >= 1000) {
    return '${formatter.format(number / 1000)}K';
  } else {
    return formatter.format(number);
  }
}

// conver int to currency
String convertIntToCurrency(int number) {
  NumberFormat formatter = NumberFormat.simpleCurrency(decimalDigits: 0);
  return formatter.format(number);
}

// Convert double to curency format
String convertDoubleToString(double number) {
  NumberFormat formatter = NumberFormat.simpleCurrency(decimalDigits: 2);
  return formatter.format(number);
}

Widget applySearchBarTheme(Widget searchbar, BuildContext context) {
  return Theme(
      data: ThemeData(
          searchBarTheme: SearchBarThemeData(
              elevation: const MaterialStatePropertyAll(0),
              padding: const MaterialStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 16.0)),
              backgroundColor: MaterialStatePropertyAll(
                  Theme.of(context).inputDecorationTheme.fillColor))),
      child: searchbar);
}

// Convert cents int to currency format
String convertCentsToCurrency(int cents) {
  NumberFormat formatter = NumberFormat.simpleCurrency(decimalDigits: 2);
  return formatter.format(cents / 100);
}

bool get inProduction => !kDebugMode;
