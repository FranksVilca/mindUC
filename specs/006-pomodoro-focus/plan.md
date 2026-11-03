# Implementation Plan: Concentración Pomodoro & Paisajes Sonoros (006-pomodoro-focus)

**Branch**: `006-pomodoro-focus` | **Date**: 2026-11-03 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/006-pomodoro-focus/spec.md`

## Summary

Implementar el módulo completo de Concentración Pomodoro (`features/focus_pomodoro/`) fiel al mockup oficial de Figma `mindUC - Concentracion (Pomodoro).png`:
1. Temporizador Pomodoro reactivo con conteo diferencial (`DateTime.now()`) para eliminar la deriva de reloj (clock drift), conmutación entre bloques de Enfoque (25 min), Descanso Corto (5 min) y Descanso Largo (15 min).
2. Cronómetro circular animado con tiempo digital (`18:41`, `de 25:00 min`), etiqueta `Bloque activo`, indicador de progreso segmentado de 4 ciclos ("Ciclo 2 de 4") y tarjeta interactiva para editar el objetivo académico en curso.
3. Selector de ambientes sonoros relajantes ("Lluvia campus", "Cafetería calma", "Bosque natural") con ajuste granular de volumen mediante deslizador.
4. Tarjeta de "Modo enfoque profundo" consciente y libre de distracciones, cumpliendo estrictamente con el **Principio VII (Diferido)** de la Constitución de mindUC sin bloqueos invasivos del sistema operativo.
5. Cobertura completa de pruebas unitarias y de widgets (`flutter test`) y cero advertencias (`dart analyze`).

---

## Technical Context

**Language/Version**: Dart 3.12.x / Flutter 3.44.x (Sound Null Safety estricto)  
**Primary Dependencies**: `flutter_riverpod: ^2.6.1`, `go_router: ^14.8.1`, `google_fonts: ^6.3.3`  
**Storage**: Estado reactivo en memoria gestionado por Riverpod `StateNotifier`, arquitectura Offline-First  
**Testing**: `flutter_test` (Pruebas unitarias para controladores y dominio; pruebas de widgets para componentes visuales y pantalla)  
**Target Platform**: Android, iOS, Web  
**Project Type**: Módulo funcional en aplicación móvil Flutter (Clean Architecture Feature-First)  
**Performance Goals**: Animación del arco circular a 60 fps, latencia de respuesta visual < 100 ms ante toques  
**Constraints**: Precisión matemática de tiempo sin desfase acumulado, funcionamiento 100% offline, cumplimiento del Principio VII (sin APIs de bloqueo de aplicaciones de terceros a nivel del SO)  
**Scale/Scope**: 1 pantalla completa (`PomodoroScreen`), 6 widgets modulares de presentación, 1 controlador reactivo (`PomodoroNotifier`), 3 entidades de dominio y 4 archivos de prueba  

---

## Constitution Check

*GATE: Evaluado y Aprobado conforme a `.specify/memory/constitution.md`*

| Principio Constitucional | Estado | Justificación y Validación |
| :--- | :---: | :--- |
| **I. Clean Architecture Feature-First** | ✅ PASS | Estructura en `lib/features/focus_pomodoro/` con capas desacopladas `domain/` y `presentation/`. |
| **II. Spec-Driven & Test-First** | ✅ PASS | Tareas atómicas vinculadas a especificación y contratos, con suites de tests unitarios y de widgets. |
| **III. Fidelidad Visual Absoluta (Figma)** | ✅ PASS | Réplica exacta de `mindUC - Concentracion (Pomodoro).png`: paleta serena (`MindColors`), tipografías (`Outfit`), radios redondeados y sombras. |
| **IV. Riverpod, GoRouter & Firebase** | ✅ PASS | Control de estado mediante `pomodoroControllerProvider` (`StateNotifier`), conectado a ruta declarativa `AppRoutes.pomodoroSession`. |
| **V. Privacidad por Diseño** | ✅ PASS | Cero envío de telemetría de estudio o hábitos personales a servidores externos. |
| **VI. [DIFERIDO] Ética IA y Gamificación** | ✅ PASS | Mantiene diferida la gamificación avanzada y modelos LLM. |
| **VII. [DIFERIDO] Bloqueo Nativo del SO** | ✅ PASS | El "Modo enfoque profundo" opera bajo compromiso consciente estudiantil sin recurrir a APIs invasivas de bloqueo del sistema operativo. |

---

## Project Structure

### Documentation (this feature)

```text
specs/006-pomodoro-focus/
├── spec.md              # Especificación funcional validada
├── plan.md              # Este plan de implementación
├── research.md          # Decisiones de arquitectura y mitigación técnica
├── data-model.md        # Entidades de dominio y modelo de estado reactivo
├── contracts/
│   └── pomodoro_ui_contract.md  # Contrato de controlador y componentes UI
├── quickstart.md        # Guía de validación automatizada y flujos de usuario
└── checklists/
    └── requirements.md  # Checklist de calidad de especificación
```

### Source Code (repository layout)

```text
lib/
└── features/
    └── focus_pomodoro/
        ├── domain/
        │   └── entities/
        │       ├── pomodoro_interval_type.dart   # Enum con tipos de intervalo y duraciones
        │       ├── pomodoro_state.dart           # Value object inmutable del estado de la sesión
        │       └── soundscape_track.dart         # Entidad de pistas acústicas ambientales
        └── presentation/
            ├── controllers/
            │   └── pomodoro_controller.dart      # Notifier reactivo con temporizador de precisión
            ├── screens/
            │   └── pomodoro_screen.dart          # Pantalla principal Pomodoro
            └── widgets/
                ├── pomodoro_header.dart          # Cabecera con navegación, título y menú
                ├── pomodoro_cycle_progress.dart  # Barra de 4 segmentos e insignias de sesión
                ├── interval_selector_row.dart    # Selector segmentado (Enfoque, Corto, Largo)
                ├── pomodoro_timer_card.dart      # Tarjeta con objetivo, arco circular y botones
                ├── soundscape_section.dart       # Selector de pistas acústicas y control de volumen
                ├── deep_focus_card.dart          # Tarjeta de modo enfoque consciente (Principio VII)
                └── objective_edit_dialog.dart    # Modal interactivo para editar objetivo académico

test/
├── unit/
│   └── features/
│       └── focus_pomodoro/
│           └── pomodoro_controller_test.dart     # Pruebas unitarias de temporizador, ciclos y sonido
└── widget/
    └── features/
        └── focus_pomodoro/
            ├── pomodoro_timer_card_test.dart     # Pruebas de widget de la tarjeta y controles
            ├── soundscape_section_test.dart      # Pruebas de pistas de sonido y deslizador
            ├── deep_focus_card_test.dart         # Pruebas del interruptor de distracción cero
            └── pomodoro_screen_test.dart         # Pruebas de integración de la pantalla completa
```

---

## Complexity Tracking

*No se detectan desviaciones arquitectónicas ni violaciones constitucionales que requieran justificación excepcional.*
