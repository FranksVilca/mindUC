# Implementation Plan: 010-progress-gamification

**Branch**: `010-progress-gamification` | **Date**: 2026-11-03 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/010-progress-gamification/spec.md`

## Summary

Implementar la pantalla de "Mi Progreso & Florecimiento" (`AppRoutes.progress` / `/progress`) acorde al mockup oficial de Figma (`mindUC - Progreso y Gamificacion.png`). El módulo provee una experiencia de gamificación compasiva sin ansiedad (Principio III), celebrando la constancia mediante metáforas botánicas orgánicas: racha de autocuidado activo de 7 días, cuadrícula 2x2 de momentos de pausa semanales (respiración, pomodoro, diario, equilibrio), jardín de logros con 3 reconocimientos florecidos y uno en avance gradual, intenciones amables semanales con avance reactivo y tarjeta final de recordatorio de autocompasión.

---

## Technical Context

**Language/Version**: Dart 3.x (Sound Null Safety) con Flutter 3.x estable.

**Primary Dependencies**: `flutter_riverpod: ^2.6.1`, `go_router: ^14.8.1`, `google_fonts: ^6.3.3`.

**Storage**: `LocalProgressDataSource` en memoria/local en el dispositivo bajo arquitectura *Offline-First* (desacoplada de dependencias externas).

**Testing**: `flutter_test` (pruebas unitarias para `ProgressNotifier`, pruebas de widget para componentes de progreso e integración completa de pantalla en `ProgressScreen`).

**Target Platform**: Android y iOS (móvil responsivo con espaciados respirables).

**Project Type**: Mobile App (módulo de característica en `lib/features/progress_gamification/`).

**Performance Goals**: Renderizado fluido a 60 fps; tiempo de carga de pantalla < 300 ms; actualización reactiva de intenciones < 16 ms.

**Constraints**:
- Cumplimiento estricto del Principio III: cero mecánicas punitivas, cero cadenas rotas culpabilizantes, cero tablas competitivas entre pares.
- Cero advertencias en `dart analyze`.
- Cobertura de pruebas del 100% para todo el código nuevo.

**Scale/Scope**: 1 pantalla principal, 1 controlador reactivo Riverpod, 6 widgets de presentación y suite completa de pruebas unitarias y de integración.

---

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principio Constitucional | Estado | Justificación y Validación |
| :--- | :---: | :--- |
| **I. Arquitectura Limpia (Feature-First)** | **PASS** | Estructurado en `domain/` (entidades puras, Value Objects y repositorio), `data/` (fuente local y repositorio impl) y `presentation/` (controlador Riverpod y widgets desacoplados). |
| **II. Spec-Driven & Test-First** | **PASS** | Flujo riguroso: `spec.md` → `plan.md` → `tasks.md` → Pruebas unitarias/widget → Implementación → Análisis estático sin issues. |
| **III. Figma como Verdad Visual & Métricas Compasivas** | **PASS** | Fiel al mockup `mindUC - Progreso y Gamificacion.png`: tonos verde salvia pastel (`#EAF1ED`), racha orgánica sin castigo, jardín botánico florecido, intenciones amables y recordatorio de autocompasión. |
| **IV. Riverpod, GoRouter & Offline-First** | **PASS** | Estado reactivo con `StateNotifierProvider`, conexión declarativa a `AppRoutes.progress` y persistencia local sin bloqueos. |
| **V. Privacidad por Diseño** | **PASS** | Métricas locales exclusivas del estudiante; sin exposición de datos personales ni tablas comparativas públicas. |
| **VI. [DIFERIDO] IA y Gamificación Compleja** | **PASS** | Se respetan los límites del MVP diferido: sin LLMs invasivos ni algoritmos de predicción complejos; métricas puramente acumulativas y reflexivas. |
| **VII. [DIFERIDO] Bloqueo Nativo de Apps** | **PASS** | Desconexión voluntaria sin llamadas a APIs nativas de bloqueo de sistema operativo. |

---

## Project Structure

### Documentation (this feature)

```text
specs/010-progress-gamification/
├── spec.md              # Especificación funcional y criterios de éxito
├── checklists/
│   └── requirements.md  # 16/16 criterios de calidad verificados
├── plan.md              # Este plan de implementación
├── research.md          # Investigación de tokens visuales y principios compasivos
├── data-model.md        # Entidades de dominio, Value Objects y contratos
├── quickstart.md        # Guía de pruebas automatizadas y verificación manual
├── contracts/
│   └── progress_ui_contract.md # Contratos de interfaz y componentes visuales
└── tasks.md             # Tareas atómicas generadas por /speckit-tasks
```

### Source Code (repository root)

```text
lib/
├── features/
│   └── progress_gamification/
│       ├── domain/
│       │   ├── entities/
│       │   │   ├── active_streak.dart
│       │   │   ├── weekly_pause_metrics.dart
│       │   │   ├── organic_achievement.dart
│       │   │   ├── weekly_intention.dart
│       │   │   └── progress_summary_state.dart
│       │   └── repositories/
│       │       └── progress_repository.dart
│       ├── data/
│       │   ├── datasources/
│       │   │   └── local_progress_datasource.dart
│       │   └── repositories/
│       │       └── local_progress_repository_impl.dart
│       └── presentation/
│           ├── controllers/
│           │   └── progress_controller.dart
│           ├── screens/
│           │   └── progress_screen.dart
│           └── widgets/
│               ├── progress_header.dart
│               ├── growth_badge_title.dart
│               ├── active_streak_card.dart
│               ├── weekly_pause_grid.dart
│               ├── achievements_garden.dart
│               ├── weekly_intentions_card.dart
│               └── self_compassion_card.dart
test/
├── unit/
│   └── features/
│       └── progress_gamification/
│           └── progress_controller_test.dart
└── widget/
    └── features/
        └── progress_gamification/
            ├── progress_cards_test.dart
            └── progress_screen_test.dart
```

---

## Phase 0: Research (Completed)
- Documentado en `research.md`: tokens de diseño extraídos del mockup de Figma, principios de métricas compasivas sin culpa y desacoplamiento Offline-First.

## Phase 1: Design & Contracts (Completed)
- Modelos de datos formalizados en `data-model.md`.
- Contratos de UI y controladores definidos en `contracts/progress_ui_contract.md`.
- Guía de verificación elaborada en `quickstart.md`.
- Conexión de ruta confirmada para `AppRoutes.progress` (`/progress`) en `app_router.dart`.
