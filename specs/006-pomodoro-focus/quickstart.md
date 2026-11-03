# Quickstart & Verification Guide: Concentración Pomodoro (006-pomodoro-focus)

**Feature Branch**: `006-pomodoro-focus`  
**Date**: 2026-11-03  
**Status**: Ready  

---

## 1. Prerrequisitos

- Flutter SDK 3.44.x o superior con Dart 3.12.x.
- Dependencias base instaladas (`flutter pub get`).
- Rama actual: `006-pomodoro-focus`.

---

## 2. Ejecución y Validación Automatizada

### 2.1 Verificación de Análisis Estático
Asegurar que no existan advertencias ni errores en el código del módulo:

```bash
dart analyze
```

*Resultado Esperado*: `No issues found!`

### 2.2 Ejecución de Pruebas Unitarias (Controlador y Dominio)
Validar las transiciones de estado, cálculo de marcas temporales, progresión de ciclos y selector de paisajes sonoros:

```bash
flutter test test/unit/features/focus_pomodoro/pomodoro_controller_test.dart
```

*Resultado Esperado*: Todos los tests pasan exitosamente (`100% pass`).

### 2.3 Ejecución de Pruebas de Widgets (Componentes y Pantalla Principal)
Validar el renderizado visual idéntico al mockup de Figma y la respuesta a interacciones:

```bash
flutter test test/widget/features/focus_pomodoro/pomodoro_timer_card_test.dart
flutter test test/widget/features/focus_pomodoro/soundscape_section_test.dart
flutter test test/widget/features/focus_pomodoro/deep_focus_card_test.dart
flutter test test/widget/features/focus_pomodoro/pomodoro_screen_test.dart
```

*Resultado Esperado*: Cobertura completa de widgets sin desbordamientos de renderizado (overflows) ni advertencias.

### 2.4 Suite Completa de Pruebas
Verificar que la nueva funcionalidad no cause regresiones en las funcionalidades 001 a 005:

```bash
flutter test
```

---

## 3. Guía de Verificación Manual (Flujo de Usuario)

1. **Acceso desde el Hub de Bienestar**:
   - Iniciar la aplicación y navegar a la pestaña "Bienestar" en la barra inferior.
   - En la cuadrícula de herramientas, pulsar la tarjeta "Concentración".
   - *Verificación*: Transición suave hacia la pantalla de Concentración Pomodoro (`/pomodoro-session`).
2. **Navegación e Interfaz Principal**:
   - Comprobar la presencia de la cabecera ("Minduc — Concentración (Pomodoro)"), el progreso ("Sesión de la tarde", "Ciclo 2 de 4", 4 cápsulas segmentadas) y el selector ("Enfoque", "Corto (5m)", "Largo (15m)").
   - Comprobar la tarjeta con el objetivo en curso ("Lectura Cap. 4 — Psicología Social") y el tiempo inicial ("18:41", "de 25:00 min").
3. **Control del Cronómetro**:
   - Presionar "Iniciar enfoque" (o "Pausar enfoque"): el botón alterna fluidamente y el arco circular avanza con el tiempo digital.
   - Presionar el botón de reinicio `↺`: el tiempo regresa a su duración base (`25:00` o `05:00`).
   - Presionar el botón de saltar `>|`: avanza al siguiente bloque del ciclo.
4. **Edición del Objetivo Académico**:
   - Tocar el icono de lápiz en la tarjeta de objetivo.
   - Escribir una nueva meta (ej. "Preparar informe") y confirmar.
   - *Verificación*: El nuevo texto se actualiza de inmediato en la tarjeta.
5. **Paisajes Sonoros y Volumen**:
   - Seleccionar "Cafetería calma" o "Bosque natural": la tarjeta seleccionada adquiere borde verde y estado activo.
   - Deslizar el control de volumen: la barra se desplaza con suavidad modulando el valor de audio.
6. **Modo Enfoque Profundo (Compromiso Consciente)**:
   - Alternar el interruptor en la tarjeta "Modo enfoque profundo": se actualiza visualmente a verde/gris.
   - Tocar la tarjeta para consultar detalles: se despliega la explicación ética conforme al Principio VII de la Constitución.

