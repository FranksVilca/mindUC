# Quickstart: 004-breathing-relaxation

Guía para probar el módulo de Respiración y Relajación Consciente (`mindUC - Respiracion y Relajacion.png`).

## Ejecución de Pruebas Automatizadas

```bash
# 1. Probar el controlador de temporización y cambios de fase
flutter test test/unit/features/breathing/breathing_session_controller_test.dart

# 2. Probar el repositorio de sesiones
flutter test test/unit/features/breathing/breathing_repository_test.dart

# 3. Probar el visualizador circular animado
flutter test test/widget/features/breathing/breathing_circle_visualizer_test.dart

# 4. Probar la fila de controles de reproducción
flutter test test/widget/features/breathing/breathing_controls_row_test.dart

# 5. Probar el selector de técnicas y contador de ciclos
flutter test test/widget/features/breathing/technique_selector_row_test.dart

# 6. Probar la tarjeta de progreso temporal y selector de duración
flutter test test/widget/features/breathing/session_progress_card_test.dart

# 7. Probar la pantalla completa BreathingScreen (integración GoRouter y modal de resumen)
flutter test test/widget/features/breathing/breathing_screen_test.dart

# 8. Análisis estático de código sin advertencias
dart analyze

# 9. Ejecutar la suite completa de mindUC (69 tests pasando)
flutter test
```

## Verificaciones Clave Realizadas
1. **Identidad Visual Figma**: Coincidencia milimétrica con el mockup `mindUC - Respiracion y Relajacion.png` (cabecera con retroceso, selector de técnica y ciclos, tarjeta de progreso, círculo botánico pulsante con arco perimetral a 60 fps, controles de cápsula y selector de duración de 3/5/10/Libre).
2. **Ciclo de Respiración & Biomecánica**: Transición armónica entre Inhalación -> Retención -> Exhalación -> Pausa con cuenta regresiva en segundos ("4s") e indicación corporal en mayúsculas espaciadas ("EXPANDE EL ABDOMEN", "MANTÉN LA CALMA", "LIBERA LA TENSIÓN").
3. **Selector de Técnicas**: Modal de cambio dinámico entre "Respiración 4-4-4 (Caja)", "Respiración 4-7-8 (Relajante)" y "Respiración Serena 8-7" con recálculo instantáneo de ciclos ("Ciclo X de Y").
4. **Controles Reactivos**: Pausa, reanudación, reinicio al ciclo 1 y finalización con confirmación mediante `BreathingControlsRow`.
5. **Modal de Resumen & Persistencia**: Despliegue automático de `BreathingSummaryDialog` al expirar la meta o presionar Stop, registrando la sesión en caché local y Cloud Firestore.
