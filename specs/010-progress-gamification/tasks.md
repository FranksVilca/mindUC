# Tasks: 010-progress-gamification

**Input**: Design documents from `/specs/010-progress-gamification/` (`spec.md`, `plan.md`, `research.md`, `data-model.md`, `contracts/progress_ui_contract.md`, `quickstart.md`)

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Estructura de carpetas y base modular para la característica `progress_gamification`.

- [x] T001 Crear la estructura de directorios en `lib/features/progress_gamification/` (`domain/entities`, `domain/repositories`, `data/datasources`, `data/repositories`, `presentation/controllers`, `presentation/screens`, `presentation/widgets`) y en `test/{unit,widget}/features/progress_gamification/`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Entidades de dominio, fuentes de datos locales y controlador reactivo para el progreso compasivo sin dinámicas punitivas (Principio III).

**CRITICAL**: Ningún trabajo de historias de usuario puede comenzar hasta completar esta fase.

- [x] T002 [P] Crear el Value Object `ActiveStreak` en `lib/features/progress_gamification/domain/entities/active_streak.dart` con conteo de días, mensaje motivacional botánico, franja semanal de 7 días y `copyWith`
- [x] T003 [P] Crear el Value Object `WeeklyPauseMetrics` en `lib/features/progress_gamification/domain/entities/weekly_pause_metrics.dart` con minutos de respiración, sesiones pomodoro, reflexiones de diario y porcentaje de equilibrio
- [x] T004 [P] Crear el enum `AchievementCategory` y la entidad inmutable `OrganicAchievement` en `lib/features/progress_gamification/domain/entities/organic_achievement.dart` con categorías botánicas, estado `isBloomed` y progreso
- [x] T005 [P] Crear el enum `IntentionIconType` y la entidad inmutable `WeeklyIntention` en `lib/features/progress_gamification/domain/entities/weekly_intention.dart` con metas amables, avance y ratios
- [x] T006 [P] Crear el modelo inmutable `ProgressSummaryState` en `lib/features/progress_gamification/domain/entities/progress_summary_state.dart` agrupando racha, métricas, lista de logros, intenciones y recordatorio compasivo
- [x] T007 [P] Crear la interfaz abstracta `ProgressRepository` en `lib/features/progress_gamification/domain/repositories/progress_repository.dart`
- [x] T008 [P] Implementar la fuente de datos local `LocalProgressDataSource` en `lib/features/progress_gamification/data/datasources/local_progress_datasource.dart` con los valores oficiales de Figma (`7 días`, `145 min`, `12 sesiones`, `9 reflexiones`, `85%`, etc.)
- [x] T009 Implementar `LocalProgressRepositoryImpl` en `lib/features/progress_gamification/data/repositories/local_progress_repository_impl.dart` conforme al Principio III (sin penalizaciones por pausas)
- [x] T010 Escribir pruebas unitarias para `ProgressNotifier` en `test/unit/features/progress_gamification/progress_controller_test.dart` cubriendo carga de estado, conteo de florecidas y avance interactivo de intenciones
- [x] T011 Implementar `ProgressNotifier` y el proveedor `progressControllerProvider` en `lib/features/progress_gamification/presentation/controllers/progress_controller.dart` implementando `IProgressController`

**Checkpoint**: Capas de dominio, datos locales y controlador reactivo verificados con pruebas unitarias.

---

## Phase 3: User Story 1 - Visualización del Espacio de Florecimiento, Racha Compasiva y Momentos de Pausa (Priority: P1) 🎯 MVP

**Goal**: Visualizar la cabecera serena, título con insignia "🌱 Crecimiento consciente", tarjeta verde pastel de racha activa de 7 días y la cuadrícula 2x2 de momentos de pausa semanales.

**Independent Test**: Ejecutar `flutter test test/widget/features/progress_gamification/progress_cards_test.dart` verificando la visualización correcta de la racha y las 4 tarjetas de pausas.

### Tests for User Story 1

- [x] T012 [P] [US1] Escribir pruebas de widget para la tarjeta de racha activa y la cuadrícula de pausas en `test/widget/features/progress_gamification/progress_cards_test.dart`

### Implementation for User Story 1

- [x] T013 [P] [US1] Implementar el widget `ProgressHeader` en `lib/features/progress_gamification/presentation/widgets/progress_header.dart` con botón de retorno, títulos "MINDUC" y "Gamificación Detallada", y avatar de usuario
- [x] T014 [P] [US1] Implementar el widget `GrowthBadgeTitle` en `lib/features/progress_gamification/presentation/widgets/growth_badge_title.dart` con insignia "🌱 Crecimiento consciente", título "Mi Progreso & Florecimiento" y subtítulo compasivo
- [x] T015 [P] [US1] Implementar el widget `ActiveStreakCard` en `lib/features/progress_gamification/presentation/widgets/active_streak_card.dart` con distintivo "RACHA DE AUTOCUIDADO ACTIVO", contador de 7 días, mensaje botánico y franja semanal `L M X J V S D`
- [x] T016 [P] [US1] Implementar el widget `WeeklyPauseGrid` en `lib/features/progress_gamification/presentation/widgets/weekly_pause_grid.dart` con cuadrícula 2x2 de métricas semanales (respiración, pomodoro, diario, equilibrio)
- [x] T017 [US1] Implementar la pantalla principal `ProgressScreen` en `lib/features/progress_gamification/presentation/screens/progress_screen.dart` consumiendo `progressControllerProvider` con racha y pausas
- [x] T018 [US1] Conectar `ProgressScreen` en la ruta declarativa `AppRoutes.progress` (`/progress`) en `lib/core/router/app_router.dart` sustituyendo el Scaffold placeholder provisional

**Checkpoint**: User Story 1 funcional y verificable de forma autónoma (MVP alcanzado).

---

## Phase 4: User Story 2 - Jardín de Logros Orgánicos (Priority: P2)

**Goal**: Visualizar los reconocimientos botánicos a la constancia con pastilla de estado "3 de 4", tres logros florecidos y un logro en progreso amable sin presión.

**Independent Test**: Verificar en pruebas de widget que `AchievementsGarden` renderice los logros "Semilla de Paz", "Mente Serena", "Voz Auténtica" (florecidos) y "Foco Lúcido" con barra de 80%.

### Implementation for User Story 2

- [x] T019 [P] [US2] Escribir pruebas de widget para las tarjetas de logros botánicos en `test/widget/features/progress_gamification/achievements_garden_test.dart`
- [x] T020 [US2] Implementar el widget `AchievementsGarden` en `lib/features/progress_gamification/presentation/widgets/achievements_garden.dart` con encabezado "Jardín de logros", distintivo "3 de 4", insignias "✓ Florecida" y barra de progreso al 80%
- [x] T021 [US2] Integrar `AchievementsGarden` en `ProgressScreen` dentro del scroll vertical principal

**Checkpoint**: User Stories 1 y 2 integradas y operativas.

---

## Phase 5: User Story 3 - Seguimiento de Intenciones Semanales y Recordatorio de Autocompasión (Priority: P3)

**Goal**: Proveer la tarjeta de metas amables semanales con avance interactivo y cerrar la pantalla con el recordatorio compasivo de que el progreso no es lineal.

**Independent Test**: Tocar un ítem de intención semanal en pruebas de widget y verificar el avance reactivo; comprobar el renderizado del recordatorio con icono solar.

### Implementation for User Story 3

- [x] T022 [P] [US3] Escribir pruebas de widget para las intenciones interactivas y la tarjeta de autocompasión en `test/widget/features/progress_gamification/weekly_intentions_test.dart`
- [x] T023 [US3] Implementar el widget `WeeklyIntentionsCard` en `lib/features/progress_gamification/presentation/widgets/weekly_intentions_card.dart` con icono de corazón, lista de 3 metas amables y avance reactivo al tocar cada una
- [x] T024 [US3] Implementar el widget `SelfCompassionCard` en `lib/features/progress_gamification/presentation/widgets/self_compassion_card.dart` con icono solar y la cita reflexiva: "El progreso no es lineal; cada pausa que te das cuenta como una victoria auténtica."
- [x] T025 [US3] Integrar `WeeklyIntentionsCard` y `SelfCompassionCard` en `ProgressScreen` conectando `onToggleIntention` con `notifier.toggleIntention`

**Checkpoint**: User Stories 1, 2 y 3 funcionales en su totalidad.

---

## Phase 6: User Story 4 - Navegación Integrada desde Inicio y Retorno Fluido (Priority: P4)

**Goal**: Garantizar la navegación fluida y sin regresiones desde la tarjeta "Mi progreso" de la pantalla de Inicio hacia `ProgressScreen` y retorno con `<`.

**Independent Test**: Ejecutar `flutter test test/widget/features/progress_gamification/progress_screen_test.dart` verificando la navegación integrada y renderizado completo.

### Implementation for User Story 4

- [x] T026 [US4] Escribir pruebas de widget de integración de pantalla completa en `test/widget/features/progress_gamification/progress_screen_test.dart` verificando todas las secciones, avance de intenciones y navegación de retorno

**Checkpoint**: Las 4 historias de usuario operativas y conformes con la Constitución.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Verificación de análisis estático sin advertencias y paso del 100% de la suite de pruebas del proyecto.

- [x] T027 Ejecutar la suite completa de pruebas (`flutter test`) y verificación de análisis estático (`dart analyze`) asegurando 0 issues y 100% de éxito

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: Sin dependencias, inicia inmediatamente.
- **Foundational (Phase 2)**: Depende de Setup. Bloquea todas las historias de usuario.
- **User Stories (Phases 3-6)**: Dependen de Foundational (Phase 2).
- **Polish & Integration (Phase 7)**: Depende de las historias de usuario para componer la pantalla.

### User Story Dependencies

- **User Story 1 (P1)**: Depende de Phase 2. Constituye el MVP.
- **User Story 2 (P2)**: Depende de US1. Añade el jardín de logros botánicos.
- **User Story 3 (P3)**: Depende de US1. Añade metas amables y recordatorio compasivo.
- **User Story 4 (P4)**: Depende de US1, US2 y US3. Valida la pantalla integrada completa.

---

## Parallel Execution Opportunities

- T002, T003, T004, T005, T006, T007 pueden ejecutarse en paralelo dentro de Foundational.
- T013, T014, T015, T016 pueden ejecutarse en paralelo como componentes independientes de UI.
- Las pruebas de widget T012, T019, T022 pueden crearse en paralelo.

