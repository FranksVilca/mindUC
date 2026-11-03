# Implementation Plan: 004-breathing-relaxation (Respiración y Relajación Consciente)

**Branch**: `004-breathing-relaxation` | **Date**: 2026-11-02 | **Spec**: [specs/004-breathing-relaxation/spec.md](spec.md)

**Input**: Feature specification from `specs/004-breathing-relaxation/spec.md`

---

## Summary

Implementar la pantalla interactiva y serena de Respiración y Relajación ([`mindUC - Respiracion y Relajacion.png`](docs/mockups/mindUC%20-%20Respiracion%20y%20Relajacion.png)), integrando:
1. Cabecera con navegación hacia atrás, título centrado "Sesion Respiracion", campana y avatar.
2. Selector de técnica ("Respiración 4-4-4 (Caja)", "4-7-8 Relajante", "8-7 Serena") y píldora de ciclos en tiempo real ("Ciclo 6 de 12").
3. Tarjeta de progreso superior con tiempo digital y barra horizontal de avance.
4. Visualizador circular animado pulsante a 60 fps con arco perimetral de avance, textos de fase, cuenta atrás en segundos y guía biomecánica corporal ("EXPANDE EL ABDOMEN").
5. Fila de controles de sesión (Reinicio, botón de cápsula central Pausar/Reanudar, y botón de Parada).
6. Segmentado inferior de duración predefinida (3 min, 5 min, 10 min, Libre).
7. Persistencia de la sesión completada en Cloud Firestore y caché local (Offline-First).

---

## Technical Context

**Language/Version**: Dart 3.12.2 / Flutter 3.44.4 (Sound Null Safety)  
**Primary Dependencies**: `flutter_riverpod: ^2.6.1`, `go_router: ^14.8.1`, `cloud_firestore: ^5.6.12`  
**Storage**: Cloud Firestore (`users/{uid}/breathing_sessions/{sessionId}`) + Fake in-memory datasource  
**Testing**: `flutter_test` (Unit tests para timer/fases, Widget tests para visualizador circular y controles)  
**Target Platform**: Android, iOS, Web/Desktop  
**Project Type**: Mobile Application  
**Performance Goals**: Animación circular constante a 60 fps, cambio de técnica en <100ms, cero bloqueos de hilo principal  
**Constraints**: 100% fidelidad visual con Figma, soporte offline completo, diseño responsivo sin overflow  
**Scale/Scope**: Módulo completo de respiración guiada + persistencia de sesiones  

---

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principio | Estado | Justificación / Cumplimiento |
| :--- | :--- | :--- |
| **I: Arquitectura Limpia** | PASA | Módulo segregado en `lib/features/breathing/` (`domain/`, `data/`, `presentation/`). |
| **II: SDD & Test-First** | PASA | Especificación completada, pruebas unitarias y de widgets diseñadas con anterioridad. |
| **III: Figma como Verdad Visual** | PASA | Mapeo exacto de tokens de color, proporciones circulares y tipografía de `mindUC - Respiracion y Relajacion.png`. |
| **IV: Riverpod, GoRouter & Firebase** | PASA | Controlador con `StateNotifier`, navegación declarativa GoRouter y persistencia en Firestore. |
| **V: Privacidad por Diseño** | PASA | Historial de sesiones guardado en la subcolección privada del estudiante autenticado. |
| **VI: IA y Gamificación Avanzada** | PASA | Mantenido como diferido; solo registro básico de sesiones y conteo de ciclos. |
| **VII: Bloqueo de Apps SO** | PASA | Diferido explícitamente. |

---

## Project Structure

### Documentation (this feature)

```text
specs/004-breathing-relaxation/
├── plan.md              # Este plan de implementación
├── research.md          # Decisiones de animación a 60 fps y sincronía temporal
├── data-model.md        # Entidades, estados y esquema Firestore
├── quickstart.md        # Guía de pruebas automatizadas
├── contracts/
│   └── breathing_ui_contract.md # Contrato de estado y widgets
└── checklists/
    └── requirements.md  # Validación de calidad de la especificación
```

### Source Code (repository layout)

```text
lib/
└── features/
    └── breathing/
        ├── data/
        │   ├── datasources/
        │   │   └── fake_breathing_datasource.dart    # Mock en memoria para tests
        │   ├── models/
        │   │   └── breathing_session_model.dart      # DTO Firestore
        │   └── repositories/
        │       └── breathing_repository_impl.dart    # Implementación concreta de repositorio
        ├── domain/
        │   ├── entities/
        │   │   ├── breathing_technique.dart          # Caja 4-4-4, Relajante 4-7-8, Serena 8-7
        │   │   ├── breathing_phase.dart              # Inhale, hold, exhale, rest con guía anatómica
        │   │   ├── breathing_session_state.dart      # Estado inmutable de la sesión activa
        │   │   └── breathing_session_log.dart        # Registro de sesión completada
        │   ├── repositories/
        │   │   └── breathing_repository.dart         # Contrato abstracto del repositorio
        │   └── usecases/
        │       ├── save_breathing_session_usecase.dart
        │       └── get_breathing_history_usecase.dart
        └── presentation/
            ├── controllers/
            │   └── breathing_session_controller.dart # StateNotifier con temporizador reactivo
            ├── widgets/
            │   ├── breathing_header.dart             # Back button, Sesion Respiracion, campana, avatar
            │   ├── technique_selector_row.dart       # Dropdown de técnica y píldora de ciclos
            │   ├── session_progress_card.dart        # Tiempo restante y barra de progreso lineal
            │   ├── breathing_circle_visualizer.dart  # Círculo pulsante con CustomPainter (60 fps)
            │   ├── breathing_controls_row.dart       # Reinicio, cápsula Pausa/Play, Stop
            │   ├── duration_presets_pill.dart        # 3 min, 5 min, 10 min, Libre
            │   └── breathing_summary_dialog.dart     # Modal sereno de finalización
            └── screens/
                └── breathing_screen.dart             # Pantalla completa oficial de Figma

test/
├── unit/
│   └── features/
│       └── breathing/
│           ├── breathing_session_controller_test.dart
│           └── breathing_repository_test.dart
└── widget/
    └── features/
        └── breathing/
            ├── breathing_circle_visualizer_test.dart
            ├── breathing_controls_row_test.dart
            └── breathing_screen_test.dart
```

**Structure Decision**: Clean Architecture Feature-First con separación clara de presentación, temporizador de sesión desacoplado y componentes gráficos modulares.

---

## Complexity Tracking

*No hay violaciones que requieran justificación excepcional.*
