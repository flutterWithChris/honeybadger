import 'package:flex_color_scheme/flex_color_scheme.dart';

int desktopWidthConstraint = 1100;
int tabletWidthConstraint = 500;
int mobileWidthConstraint = 400;

String parseEnumName(String enumString) {
  String nameCamelCase = enumString.split('.').last;
  String formattedString = nameCamelCase
      .replaceAllMapped(RegExp(r'[A-Z]'), (Match m) => ' ${m[0]}')
      .capitalize;
  return formattedString;
}
