# Quickstart: 003-home-dashboard

Guía para probar el Dashboard Principal del Estudiante (`mindUC - Inicio.png`).

## Ejecución de Pruebas Automatizadas

```bash
# Probar el selector interactivo de estado de ánimo
flutter test test/widget/features/home/mood_selector_row_test.dart

# Probar la cuadrícula de accesos rápidos
flutter test test/widget/features/home/quick_access_grid_test.dart

# Probar la pantalla completa HomeScreen (Figma visual match)
flutter test test/widget/features/home/home_screen_test.dart

# Ejecutar la suite completa
flutter test
```

## Verificaciones Clave:
1. **Identidad Visual**: Renderizado idéntico al mockup `mindUC - Inicio.png` (cabecera con logo y avatar, píldora de fecha, saludo con nombre, selector de 5 ánimos y cuadrícula 2x2).
2. **Interactividad**: Cambio de estado de ánimo al tocar cualquier emoción con feedback visual inmediato.
3. **Navegación**: Salto correcto hacia `Bienestar`, `Agenda`, `Comunidad` y `Progreso` al pulsar las tarjetas de "Espacios para ti".
