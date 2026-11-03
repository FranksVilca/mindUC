# Quickstart: 003-home-dashboard

Guía para probar el Dashboard Principal del Estudiante (`mindUC - Inicio.png`).

## Ejecución de Pruebas Automatizadas

```bash
# Probar la utilidad pura de fecha en español
flutter test test/unit/core/date_formatter_test.dart

# Probar el repositorio de persistencia de ánimo
flutter test test/unit/features/home/mood_repository_test.dart

# Probar los casos de uso de estado de ánimo
flutter test test/unit/features/home/mood_usecases_test.dart

# Probar el controlador HomeDashboardNotifier
flutter test test/unit/features/home/home_dashboard_controller_test.dart

# Probar la cabecera y píldora de fecha
flutter test test/widget/features/home/home_header_test.dart

# Probar el selector interactivo de estado de ánimo
flutter test test/widget/features/home/mood_selector_row_test.dart

# Probar la cuadrícula de accesos rápidos
flutter test test/widget/features/home/quick_access_grid_test.dart

# Probar la pantalla completa HomeScreen (Figma visual match)
flutter test test/widget/features/home/home_screen_test.dart

# Ejecutar la suite completa del proyecto (47 pruebas)
flutter test
```

## Verificaciones Clave:
1. **Identidad Visual**: Renderizado idéntico al mockup `mindUC - Inicio.png` (cabecera con logo y avatar, píldora de fecha botánica, saludo personalizado con nombre de estudiante, selector de 5 estados de ánimo y cuadrícula 2x2 "Espacios para ti").
2. **Interactividad**: Cambio de estado de ánimo al tocar cualquier emoción con feedback visual inmediato (borde activo, sombra y actualización reactiva).
3. **Navegación**: Salto correcto hacia `Bienestar`, `Agenda`, `Comunidad` y `Progreso` al pulsar las tarjetas de "Espacios para ti".
4. **Resiliencia**: Soporte Offline-First con fallback local y resolución elegante de nombres.
