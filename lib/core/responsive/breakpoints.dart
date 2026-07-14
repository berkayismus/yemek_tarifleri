import 'package:flutter/widgets.dart';

enum ScreenSize { mobile, tablet, desktop }

ScreenSize screenSize(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < 600) return ScreenSize.mobile;
  if (width < 900) return ScreenSize.tablet;
  return ScreenSize.desktop;
}

int adaptiveGridColumns(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < 600) return 2;
  if (width < 900) return 3;
  if (width < 1200) return 4;
  return 5;
}

double adaptiveContentMaxWidth(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  if (width < 600) return double.infinity;
  return 900;
}

bool isWideScreen(BuildContext context) =>
    MediaQuery.of(context).size.width >= 600;
