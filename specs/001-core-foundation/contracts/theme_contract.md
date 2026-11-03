# Contract: Design System & Theme Tokens

`lib/core/theme/mind_colors.dart` y `mind_theme.dart`

```dart
import 'package:flutter/material.dart';

abstract final class MindColors {
  // Primarios y fondos
  static const Color background = Color(0xFFFBF9F4);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color primary = Color(0xFF718E81); // Verde salvia sereno
  static const Color primaryDark = Color(0xFF4C6B5E);
  static const Color primaryLight = Color(0xFFA6BCB2);
  
  // Categorías de bienestar (Figma)
  static const Color autocuidado = Color(0xFFEAF1ED);
  static const Color autocuidadoAccent = Color(0xFF5D8572);
  
  static const Color estudioTrabajo = Color(0xFFEBE8F7);
  static const Color estudioTrabajoAccent = Color(0xFF7B72B8);
  
  static const Color saludMental = Color(0xFFFCE7E1);
  static const Color saludMentalAccent = Color(0xFFD67868);
  
  static const Color descanso = Color(0xFFE5F0F5);
  static const Color descansoAccent = Color(0xFF5B8A99);

  // Textos y divisores
  static const Color textPrimary = Color(0xFF222E28);
  static const Color textSecondary = Color(0xFF5C6B64);
  static const Color textTertiary = Color(0xFF8F9E96);
  static const Color divider = Color(0xFFEDE9DF);
}

abstract final class MindRadii {
  static const double card = 22.0;
  static const double button = 30.0;
  static const double chip = 16.0;
  static const double modal = 28.0;
}

abstract final class MindSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
}
```

