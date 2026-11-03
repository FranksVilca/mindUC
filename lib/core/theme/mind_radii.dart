import 'package:flutter/material.dart';

/// Radios de curvatura oficiales de mindUC según Figma.
abstract final class MindRadii {
  static const double card = 22.0;
  static const double button = 30.0;
  static const double chip = 16.0;
  static const double input = 16.0;
  static const double modal = 28.0;
  static const double full = 999.0;

  static const BorderRadius cardRadius = BorderRadius.all(Radius.circular(card));
  static const BorderRadius buttonRadius = BorderRadius.all(Radius.circular(button));
  static const BorderRadius chipRadius = BorderRadius.all(Radius.circular(chip));
  static const BorderRadius inputRadius = BorderRadius.all(Radius.circular(input));
  static const BorderRadius modalRadius = BorderRadius.only(
    topLeft: Radius.circular(modal),
    topRight: Radius.circular(modal),
  );
}
