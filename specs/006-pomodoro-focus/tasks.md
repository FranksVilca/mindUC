# Tasks: Concentración Pomodoro & Paisajes Sonoros (006-pomodoro-focus)

**Input**: Design documents from `/specs/006-pomodoro-focus/`
**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/pomodoro_ui_contract.md`, `quickstart.md`
**Tests**: Included and required per Constitution Principle II (Spec-Driven & Test-First).
**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `- [ ] [TaskID] [P?] [Story?] Description with file path`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (`[US1]`, `[US2]`, `[US3]`, `[US4]`)
- Include exact file paths in descriptions

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Estructura de directorios y módulos para la característica `focus_pomodoro`.

- [ ] T001 Crear la estructura de directorios de la característica en `lib/features/focus_pomodoro/` (`domain/entities`, `presentation/controllers`, `presentation/screens`, `presentation/widgets`) y en `test/{unit,widget}/features/focus_pomodoro/`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Entidades de dominio fundamentales y controlador reactivo con temporizador de precisión diferencial que bloquean la implementación de las historias de usuario.

- [ ] T002 [P] Crear la entidad `PomodoroIntervalType` en `lib/features/focus_pomodoro/domain/entities/pomodoro_interval_type.dart` con valores `focus` (1500s), `shortBreak` (300s), `longBreak` (900s), etiquetas y getters de duración
- [ ] T003 [P] Crear la entidad `SoundscapeTrack` en `lib/features/focus_pomodoro/domain/entities/soundscape_track.dart` con campos `id`, `title`, `subtitle`, `iconName` y catálogo predefinido (`rain`, `cafe`, `forest`)
- [ ] T004 [P] Crear la entidad inmutable `PomodoroState` en `lib/features/focus_pomodoro/domain/entities/pomodoro_state.dart` con campos `sessionTitle`, `currentCycle`, `totalCycles`, `intervalType`, `remainingSeconds`, `totalSeconds`, `isRunning`, `currentObjective`, `selectedSoundscapeId`, `isSoundscapePlaying`, `soundscapeVolume`, `isDeepFocusEnabled`, getters de formateo de tiempo y `copyWith`
- [ ] T005 Escribir pruebas unitarias para `PomodoroNotifier` en `test/unit/features/focus_pomodoro/pomodoro_controller_test.dart` cubriendo inicio, pausa, reinicio, salto de intervalos, transiciones de ciclos y cálculo de tiempo sin desfase
- [ ] T006 Implementar `PomodoroNotifier` y el proveedor `pomodoroControllerProvider` en `lib/features/focus_pomodoro/presentation/controllers/pomodoro_controller.dart` implementando `IPomodoroController` mediante marcas temporales de sistema (`DateTime.now()`)

**Checkpoint**: Base de dominio y controlador reactivo completados y verificados con pruebas unitarias.

---

## Phase 3: User Story 1 - Temporizador Pomodoro Reactivo e Intervalos Conscientes (Priority: P1) 🎯 MVP

**Goal**: Proveer el selector segmentado de intervalos (25m, 5m, 15m), el cronómetro circular con tiempo digital restante (`MM:SS`), etiqueta `Bloque activo`, y controles de reproducción (iniciar/pausar, reiniciar, saltar).

**Independent Test**: Ejecutar `flutter test test/widget/features/focus_pomodoro/pomodoro_timer_card_test.dart` verificando la alternancia de botones, actualización del arco circular de progreso y reinicio del contador.

### Tests for User Story 1

- [ ] T007 [P] [US1] Escribir pruebas de widget para selector de intervalos y tarjeta de cronómetro en `test/widget/features/focus_pomodoro/pomodoro_timer_card_test.dart`

### Implementation for User Story 1

- [ ] T008 [P] [US1] Implementar el widget `IntervalSelectorRow` en `lib/features/focus_pomodoro/presentation/widgets/interval_selector_row.dart` con opciones "Enfoque", "Corto (5m)" y "Largo (15m)" destacando la opción activa con fondo blanco y sombra suave
- [ ] T009 [US1] Implementar el widget `PomodoroTimerCard` en `lib/features/focus_pomodoro/presentation/widgets/pomodoro_timer_card.dart` con arco circular verde (`MindColors.primary`), indicador "Bloque activo", tiempo digital (ej. `18:41`), duración total ("de 25:00 min") y fila de controles de reproducción (botón `↺`, botón píldora "Iniciar/Pausar enfoque" y botón `>|`)

**Checkpoint**: User Story 1 funcional y comprobable de forma autónoma (MVP alcanzado).

---

## Phase 4: User Story 2 - Progreso de Ciclos y Vinculación de Objetivo Académico (Priority: P2)

**Goal**: Mostrar la cabecera contextual de la sesión ("Sesión de la tarde"), la insignia de ciclos ("Ciclo X de 4"), la barra segmentada de 4 cápsulas horizontales y la subtarjeta editable de objetivo académico con botón de lápiz.

**Independent Test**: Ejecutar `flutter test test/widget/features/focus_pomodoro/pomodoro_cycle_progress_test.dart` verificando el llenado visual de las cápsulas de ciclo y la edición reactiva del objetivo mediante el modal.

### Tests for User Story 2

- [ ] T010 [P] [US2] Escribir pruebas de widget para la barra de 4 ciclos y diálogo de objetivo académico en `test/widget/features/focus_pomodoro/pomodoro_cycle_progress_test.dart`

### Implementation for User Story 2

- [ ] T011 [P] [US2] Implementar el widget `PomodoroCycleProgress` en `lib/features/focus_pomodoro/presentation/widgets/pomodoro_cycle_progress.dart` con insignia de planta "Sesión de la tarde", badge "Ciclo 2 de 4" y barra horizontal de 4 cápsulas segmentadas
- [ ] T012 [US2] Implementar el diálogo modal interactivo `ObjectiveEditDialog` en `lib/features/focus_pomodoro/presentation/widgets/objective_edit_dialog.dart` e integrarlo en la cabecera de la tarjeta `PomodoroTimerCard` con botón de edición rápida (lápiz)

**Checkpoint**: User Stories 1 y 2 completamente operativas e integradas.

---

## Phase 5: User Story 3 - Paisajes Sonoros Relajantes y Control de Volumen (Priority: P3)

**Goal**: Proveer el carrusel horizontal de tarjetas de sonido ("Lluvia campus", "Cafetería calma", "Bosque natural") con borde verde activo, estado "En reproducción", y deslizador de volumen flanqueado por altavoces.

**Independent Test**: Ejecutar `flutter test test/widget/features/focus_pomodoro/soundscape_section_test.dart` verificando la conmutación de pistas sonoras y el ajuste reactivo del volumen.

### Tests for User Story 3

- [ ] T013 [P] [US3] Escribir pruebas de widget para la sección de paisajes sonoros y barra de volumen en `test/widget/features/focus_pomodoro/soundscape_section_test.dart`

### Implementation for User Story 3

- [ ] T014 [US3] Implementar el widget `SoundscapeSection` en `lib/features/focus_pomodoro/presentation/widgets/soundscape_section.dart` con icono de ondas (`||||`), badge "Audio relajante", lista de tarjetas con estados interactivos y control deslizante de volumen (slider)

**Checkpoint**: User Stories 1, 2 y 3 operativas de forma autónoma.

---

## Phase 6: User Story 4 - Modo Enfoque Profundo Consciente (Principio VII) (Priority: P4)

**Goal**: Proveer la tarjeta inferior de distracción cero con icono de escudo, interruptor de alternancia, subtítulo "3 apps silenciadas temporalmente", badges (`Instagram 🔒`, `TikTok 🔒`, `WhatsApp 🔒`) y diálogo explicativo de compromiso consciente conforme al Principio VII diferido de la Constitución.

**Independent Test**: Ejecutar `flutter test test/widget/features/focus_pomodoro/deep_focus_card_test.dart` verificando la activación del switch y el despliegue del aviso de autorregulación consciente sin intercepción del SO.

### Tests for User Story 4

- [ ] T015 [P] [US4] Escribir pruebas de widget para el modo enfoque consciente en `test/widget/features/focus_pomodoro/deep_focus_card_test.dart`

### Implementation for User Story 4

- [ ] T016 [US4] Implementar el widget `DeepFocusCard` en `lib/features/focus_pomodoro/presentation/widgets/deep_focus_card.dart` con icono de escudo, switch interactivo, chips visuales de apps silenciadas y diálogo formativo de alineación ética bajo el Principio VII diferido

**Checkpoint**: Las 4 historias de usuario se encuentran implementadas y validadas con pruebas.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Integración de la pantalla completa `PomodoroScreen`, cabecera de navegación, vinculación con `AppRoutes.pomodoroSession`, pruebas de pantalla completa y verificación estática.

- [ ] T017 [P] Implementar el widget `PomodoroHeader` en `lib/features/focus_pomodoro/presentation/widgets/pomodoro_header.dart` con botón de retroceso (`<`), título "Minduc — Concentración (Pomodoro)", subtítulo "mindUC" y botón de opciones (`⋮`)
- [ ] T018 Implementar la pantalla principal `PomodoroScreen` en `lib/features/focus_pomodoro/presentation/screens/pomodoro_screen.dart` articulando `PomodoroHeader`, `PomodoroCycleProgress`, `IntervalSelectorRow`, `PomodoroTimerCard`, `SoundscapeSection` y `DeepFocusCard` en un scroll vertical armonioso
- [ ] T019 Conectar `PomodoroScreen` en la ruta declarativa `AppRoutes.pomodoroSession` en `lib/core/router/app_router.dart` reemplazando el Scaffold placeholder provisional
- [ ] T020 Escribir pruebas de widget de integración de pantalla completa en `test/widget/features/focus_pomodoro/pomodoro_screen_test.dart`
- [ ] T021 Ejecutar la suite completa de pruebas (`flutter test`) y verificación de análisis estático (`dart analyze`) asegurando 0 issues y 100% de éxito

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: Sin dependencias, inicia inmediatamente.
- **Foundational (Phase 2)**: Depende de Phase 1. Bloquea todas las historias de usuario.
- **User Stories (Phases 3-6)**: Dependen de Foundational (Phase 2).
  - Pueden ejecutarse secuencialmente en orden de prioridad (US1 → US2 → US3 → US4) o en paralelo si se dispone de capacidad.
- **Polish & Integration (Phase 7)**: Depende de las historias de usuario deseadas para componer la pantalla.

### User Story Dependencies

- **User Story 1 (P1)**: Depende de Phase 2. No depende de ninguna otra historia. Constituye el MVP.
- **User Story 2 (P2)**: Depende de Phase 2. Enriquece la tarjeta de temporizador con el objetivo y agrega la barra de 4 ciclos.
- **User Story 3 (P3)**: Depende de Phase 2. Agrega la sección acústica de forma desacoplada.
- **User Story 4 (P4)**: Depende de Phase 2. Agrega el modo enfoque profundo como componente inferior.

---

## Parallel Execution Opportunities

- T002, T003, T004 (Entidades de dominio) pueden desarrollarse simultáneamente.
- T007 (Pruebas US1) y T008 (Selector) pueden ejecutarse en paralelo.
- T010 (Pruebas US2) y T011 (Progreso de ciclos) pueden ejecutarse en paralelo.
- T013 (Pruebas US3) y T015 (Pruebas US4) pueden prepararse en paralelo.
- T017 (Cabecera) puede desarrollarse en paralelo a los widgets de las historias.

---

## Implementation Strategy

### MVP First (User Story 1)
1. Completar Phase 1 (Setup) y Phase 2 (Foundational: entidades y controlador).
2. Completar Phase 3 (User Story 1: temporizador circular y selector).
3. **Validar MVP**: Ejecutar `flutter test test/widget/features/focus_pomodoro/pomodoro_timer_card_test.dart`.

### Incremental Delivery
1. Añadir Phase 4 (US2: Ciclos y Objetivo).
2. Añadir Phase 5 (US3: Paisajes sonoros).
3. Añadir Phase 6 (US4: Modo enfoque consciente).
4. Completar Phase 7 (Integración en pantalla, GoRouter y suite completa de pruebas).
