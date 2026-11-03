# Quickstart: 004-breathing-relaxation

Guía para probar el módulo de Respiración y Relajación Consciente (`mindUC - Respiracion y Relajacion.png`).

## Ejecución de Pruebas Automatizadas

```bash
# Probar el controlador de temporización y cambios de fase
flutter test test/unit/features/breathing/breathing_session_controller_test.dart

# Probar el repositorio de sesiones
flutter test test/unit/features/breathing/breathing_repository_test.dart

# Probar el visualizador circular animado
flutter test test/widget/features/breathing/breathing_circle_visualizer_test.dart

# Probar la fila de controles de reproducción
flutter test test/widget/features/breathing/breathing_controls_row_test.dart

# Probar la pantalla completa BreathingScreen
flutter test test/widget/features/breathing/breathing_screen_test.dart

# Ejecutar la suite completa
flutter test
```

## Verificaciones Clave:
1. **Identidad Visual**: Coincidencia milimétrica con el mockup `mindUC - Respiracion y Relajacion.png` (cabecera con retroceso, selector de técnica y ciclos, tarjeta de progreso, círculo pulsante, controles y selector de duración).
2. **Ciclo de Respiración**: Transición automática entre Inhalación -> Retención -> Exhalación con cuenta regresiva en segundos y guía corporal ("EXPANDE EL ABDOMEN").
3. **Controles**: Pausa, reanudación, reinicio y finalización fluida sin fallas ni pérdidas de estado.
4. **Resumen**: Al completarse la sesión, despliegue del modal de felicitación y registro en el repositorio de bienestar.
