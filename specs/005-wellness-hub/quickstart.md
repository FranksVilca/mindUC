# Quickstart: 005-wellness-hub

Guía para validar el Hub de Bienestar de mindUC (`mindUC - Bienestar.png`).

## Ejecución de Pruebas Automatizadas

```bash
# 1. Probar el controlador de bienestar
flutter test test/unit/features/wellness/wellness_controller_test.dart

# 2. Probar la tarjeta de ejercicio sugerido
flutter test test/widget/features/wellness/suggested_exercise_card_test.dart

# 3. Probar la cuadrícula 2x2 de herramientas de autocuidado
flutter test test/widget/features/wellness/wellness_tools_grid_test.dart

# 4. Probar la pantalla completa WellnessScreen y navegación GoRouter
flutter test test/widget/features/wellness/wellness_screen_test.dart

# 5. Análisis estático sin advertencias (0 issues)
dart analyze

# 6. Suite completa de tests de mindUC (78 tests pasando)
flutter test
```

## Verificaciones Clave Realizadas
1. **Identidad Visual Figma**: Título "Tu espacio de bienestar ✨", mensaje inspirador de pausa consciente, píldora `🌱 SANCTUARY MODE`, cabecera `mindUC / Bienestar`, tarjeta destacada sugerida y cuadrícula 2x2.
2. **Acceso Rápido 1-Tap**: Pulsar `▶ Comenzar (5 min)` en el ejercicio sugerido navega inmediatamente a `/breathing-session` precargando técnica 4-7-8 y 300 segundos.
3. **Manejo Ético del Asistente IA (Principio VI)**: Tocar la tarjeta de IA despliega el diálogo compasivo de fase de preparación sin generar fallos ni llamadas de red no autorizadas.
4. **Shell Persistente**: La pestaña "Bienestar" está integrada en la rama `index 1` (`AppRoutes.wellness`) del `StatefulShellRoute` de GoRouter y conserva su estado y scroll al alternar entre pestañas.
