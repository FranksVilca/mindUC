# Implementation Plan: 005-wellness-hub

**Branch**: `005-wellness-hub` | **Date**: 2026-11-02 | **Spec**: [`specs/005-wellness-hub/spec.md`](spec.md)

**Input**: Feature specification from `/specs/005-wellness-hub/spec.md`  
**Mockup**: [`docs/mockups/mindUC - Bienestar.png`](../../docs/mockups/mindUC%20-%20Bienestar.png)  

---

## Summary

Implementar la pantalla oficial del Hub de Bienestar (`WellnessScreen`), correspondiente a la Pestaña 2 del Shell de navegación persistente de GoRouter (`AppRoutes.wellness`). Integra la cabecera serena, la píldora `🌱 SANCTUARY MODE`, el título de acogida `Tu espacio de bienestar ✨`, la tarjeta interactiva de ejercicio sugerido con inicio en un toque (`Respiración 4–7–8 (5 min)`), y la cuadrícula 2x2 de herramientas de autocuidado (Respiración, Diario personal, Asistente IA informativo y Concentración Pomodoro).

---

## Technical Context

**Language/Version**: Dart 3.x con Sound Null Safety, Flutter 3.x  
**Primary Dependencies**: `flutter_riverpod: ^2.6.1`, `go_router: ^14.8.1`, `google_fonts: ^6.3.3`  
**Storage**: N/A (Consumo de servicios preexistentes de respiración y preferencias en memoria/Firestore)  
**Testing**: `flutter_test` (pruebas unitarias de controlador y pruebas de widgets para componentes y pantalla completa)  
**Target Platform**: Android, iOS (Cross-platform Flutter Mobile)  
**Project Type**: Mobile Application Screen & Navigation Shell Branch  
**Performance Goals**: Renderizado inicial < 50 ms, transiciones de pantalla a 60 fps, 0 desbordes (`RenderFlex overflow`)  
**Constraints**: 100% de cumplimiento con los mockups oficiales de Figma, Principio VI (Asistente IA diferido manejado con modal compasivo)  
**Scale/Scope**: 1 pantalla principal, 4 componentes modulares de presentación, 1 controlador Riverpod, 2 entidades de dominio, 4 suites de prueba  

---

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principio | Estado | Justificación / Cumplimiento |
| :--- | :--- | :--- |
| **I: Arquitectura Limpia** | PASA | Modularidad Feature-First en `lib/features/wellness/` con capas desacopladas `domain/` y `presentation/`. |
| **II: SDD & Test-First** | PASA | Especificación formal completada, pruebas unitarias y de widgets planificadas antes de la implementación. |
| **III: Figma como Verdad Visual** | PASA | Réplica exacta de `mindUC - Bienestar.png` con tokens oficiales `MindColors.autocuidado`, `MindColors.estudioTrabajo`, `MindColors.descanso` y `MindColors.saludMental`. |
| **IV: Riverpod & GoRouter** | PASA | Conectado a la rama 1 (`index 1`) de `StatefulShellRoute` con `StateNotifier` reactivo. |
| **V: Privacidad por Diseño** | PASA | La tarjeta de diario personal se rotula explícitamente con la insignia `Privado`. |
| **VI: IA y Gamificación Diferidas** | PASA | La tarjeta de "Asistente IA ✨" despliega un modal compasivo de fase de preparación comunitaria, sin invocar LLMs externos no validados. |
| **VII: Bloqueo de Apps SO** | PASA | La tarjeta de concentración conduce a la sesión de bloques con sonidos sin involucrar APIs invasivas del SO. |

---

## Project Structure

### Documentation (this feature)

```text
specs/005-wellness-hub/
├── plan.md              # Este plan de implementación
├── research.md          # Decisiones de navegación, 1-tap launch y módulos diferidos
├── data-model.md        # Entidades inmutables y modelo de estado
├── quickstart.md        # Guía de verificación automatizada
├── contracts/
│   └── wellness_ui_contract.md # Contratos de widgets y Riverpod
└── checklists/
    └── requirements.md  # Checklist de calidad de especificación
```

### Source Code (repository layout)

```text
lib/
└── features/
    └── wellness/
        ├── domain/
        │   └── entities/
        │       ├── wellness_suggested_exercise.dart # Ejercicio sugerido del día
        │       ├── wellness_tool_item.dart          # Tarjetas de la cuadrícula 2x2
        │       └── wellness_state.dart              # Estado reactivo del Hub
        └── presentation/
            ├── controllers/
            │   └── wellness_controller.dart         # StateNotifier del Hub de Bienestar
            ├── widgets/
            │   ├── wellness_header.dart             # Cabecera mindUC / Bienestar + campana + avatar
            │   ├── sanctuary_badge.dart             # Píldora botánica SANCTUARY MODE
            │   ├── suggested_exercise_card.dart     # Tarjeta destacada con botón de 1 toque
            │   ├── wellness_tools_grid.dart         # Cuadrícula 2x2 con insignias temáticas
            │   └── ai_assistant_dialog.dart         # Modal sereno de aviso ético (Principio VI)
            └── screens/
                └── wellness_screen.dart             # Pantalla oficial integrada en GoRouter

test/
├── unit/
│   └── features/
│       └── wellness/
│           └── wellness_controller_test.dart
└── widget/
    └── features/
        └── wellness/
            ├── suggested_exercise_card_test.dart
            ├── wellness_tools_grid_test.dart
            └── wellness_screen_test.dart
```

**Structure Decision**: Clean Architecture Feature-First en `lib/features/wellness/` con componentes modulares reusables y pruebas espejo en `test/`.

---

## Complexity Tracking

*No hay violaciones que requieran justificación excepcional.*
