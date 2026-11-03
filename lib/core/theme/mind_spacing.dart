import 'package:flutter/material.dart';

/// Sistema de espaciado y márgenes de mindUC.
abstract final class MindSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(horizontal: lg, vertical: md);
  static const EdgeInsets cardPadding = EdgeInsets.all(md);
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(horizontal: xl, vertical: md);
}

