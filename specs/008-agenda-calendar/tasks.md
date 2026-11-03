# Tasks: 008-agenda-calendar

**Input**: Design documents from `/specs/008-agenda-calendar/` (`spec.md`, `plan.md`, `research.md`, `data-model.md`, `contracts/agenda_ui_contract.md`, `quickstart.md`)

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Estructura de carpetas y base modular para la característica `agenda`.

- [x] T001 Crear la estructura de carpetas en `lib/features/agenda/` (`domain/entities`, `domain/repositories`, `data/datasources`, `data/repositories`, `presentation/controllers`, `presentation/widgets`) y en `test/{unit,widget}/features/agenda/`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Entidades de dominio, fuentes de datos locales y controlador reactivo con almacenamiento de actividades de agenda.

**CRITICAL**: Ningún trabajo de historias de usuario puede comenzar hasta completar esta fase.

- [x] T002 [P] Crear el enum `AgendaCategory` en `lib/features/agenda/domain/entities/agenda_category.dart` con categorías `autocuidado`, `estudioTrabajo`, `saludMental`, etiquetas y estilos asociados
- [x] T003 [P] Crear la entidad inmutable `AgendaActivity` en `lib/features/agenda/domain/entities/agenda_activity.dart` con `id`, `title`, `subtitle`, `scheduledDateTime`, `category`, `isCompleted`, `createdAt`, getter `formattedTime` y método `copyWith`
- [x] T004 [P] Crear el Value Object `DaySchedule` en `lib/features/agenda/domain/entities/day_schedule.dart` con getters `totalActivities`, `completedActivities`, `balanceProgress` y `hasActivities`
- [x] T005 [P] Crear el modelo inmutable `AgendaState` en `lib/features/agenda/domain/entities/agenda_state.dart` con fecha seleccionada, filtro activo, lista de actividades y getters reactivos (`activitiesForSelectedDay`, `filteredActivities`, `totalForDay`, `completedForDay`, `rhythmText`)
- [x] T006 [P] Crear la interfaz abstracta `AgendaRepository` en `lib/features/agenda/domain/repositories/agenda_repository.dart` con operaciones de obtención, guardado, conmutación y eliminación
- [x] T007 [P] Implementar la fuente de datos local `LocalAgendaDataSource` en `lib/features/agenda/data/datasources/local_agenda_datasource.dart` con las 4 actividades iniciales de Figma y operaciones CRUD en memoria
- [x] T008 Implementar `LocalAgendaRepositoryImpl` en `lib/features/agenda/data/repositories/local_agenda_repository_impl.dart` cumpliendo con la arquitectura Offline-First
- [x] T009 Escribir pruebas unitarias para `AgendaNotifier` en `test/unit/features/agenda/agenda_controller_test.dart` cubriendo filtrado por fecha, filtros por categoría, conmutación de estado y creación de tareas
- [x] T010 Implementar `AgendaNotifier` y el proveedor `agendaControllerProvider` en `lib/features/agenda/presentation/controllers/agenda_controller.dart` implementando `IAgendaController`

**Checkpoint**: Capas de dominio, datos locales y controlador reactivo verificados con pruebas unitarias.

---

## Phase 3: User Story 1 - Visualización de la Agenda, Tira Semanal y Lista de Tareas (Priority: P1) 🎯 MVP

**Goal**: Visualizar la cabecera serena, fecha y semana de calendario, selector semanal horizontal con indicadores de densidad, tarjeta "Ritmo en equilibrio", barra de filtros y lista de tarjetas de actividades de Figma.

**Independent Test**: Ejecutar `flutter test test/widget/features/agenda/weekly_day_strip_test.dart` y `test/widget/features/agenda/activity_card_test.dart` verificando la visualización correcta de los 7 días y las actividades del día.

### Tests for User Story 1

- [x] T011 [P] [US1] Escribir pruebas de widget para la tira semanal y la tarjeta de actividad en `test/widget/features/agenda/weekly_day_strip_test.dart` y `test/widget/features/agenda/activity_card_test.dart`

### Implementation for User Story 1

- [x] T012 [P] [US1] Implementar el widget `AgendaHeader` en `lib/features/agenda/presentation/widgets/agenda_header.dart` con logo "mindUC", subtítulo "Agenda", campana de notificaciones y avatar de estudiante
- [x] T013 [P] [US1] Implementar el widget `WeeklyDayStrip` en `lib/features/agenda/presentation/widgets/weekly_day_strip.dart` con los 7 días de la semana (Lun a Dom), números de día, puntos de densidad y resaltado activo
- [x] T014 [P] [US1] Implementar el widget `RhythmBalanceCard` en `lib/features/agenda/presentation/widgets/rhythm_balance_card.dart` con icono de hoja circular, balance ("4 actividades · 2 completadas") y enlace "Historial >"
- [x] T015 [P] [US1] Implementar el widget `CategoryFilterChips` en `lib/features/agenda/presentation/widgets/category_filter_chips.dart` con chips "Todas", "Autocuidado", "Estudio / Trabajo" y resaltado dinámico
- [x] T016 [US1] Implementar el widget `ActivityCard` en `lib/features/agenda/presentation/widgets/activity_card.dart` con selector circular, horario AM/PM, píldora de categoría semántica, título con tachado condicional y descripción
- [x] T017 [US1] Integrar la pantalla principal `AgendaScreen` en `lib/features/agenda/presentation/screens/agenda_screen.dart` consumiendo `agendaControllerProvider` para componer cabecera, tira semanal, balance, filtros y lista reactiva de actividades

**Checkpoint**: User Story 1 funcional y verificable de forma autónoma (MVP alcanzado).

---

## Phase 4: User Story 2 - Marcado Consciente y Actualización de "Ritmo en equilibrio" (Priority: P2)

**Goal**: Conmutar interactivamente el estado completada/pendiente de cualquier actividad tocando su selector circular, aplicando tachado sutil al texto y actualizando en tiempo real el contador de ritmo diario.

**Independent Test**: Tocar el selector circular de una actividad pendiente en `activity_card_test.dart` y comprobar la llamada de conmutación y la actualización del estado.

### Implementation for User Story 2

- [x] T018 [US2] Conectar el selector circular interactivo de `ActivityCard` con `notifier.toggleActivityCompletion(id)` en `lib/features/agenda/presentation/screens/agenda_screen.dart` asegurando la reactividad inmediata del balance de ritmo

**Checkpoint**: User Stories 1 y 2 integradas y operativas.

---

## Phase 5: User Story 3 - Creación Manual de Actividades Conscientes (Priority: P3)

**Goal**: Proveer el botón flotante alargado `+ Nueva` y la hoja modal de creación de actividades con título, descripción, horario y categoría consciente.

**Independent Test**: Ejecutar `flutter test test/widget/features/agenda/activity_create_modal_test.dart` verificando la captura de datos y la invocación del guardado.

### Tests for User Story 3

- [x] T019 [P] [US3] Escribir pruebas de widget para el modal de agendamiento en `test/widget/features/agenda/activity_create_modal_test.dart`

### Implementation for User Story 3

- [x] T020 [US3] Implementar el widget modal `ActivityCreateModal` en `lib/features/agenda/presentation/widgets/activity_create_modal.dart` con campos de título, descripción opcional, selector de hora y selector de categoría consciente
- [x] T021 [US3] Conectar el botón flotante alargado `+ Nueva` en `AgendaScreen` (`lib/features/agenda/presentation/screens/agenda_screen.dart`) para invocar `ActivityCreateModal.show` y guardar la nueva actividad en la jornada activa

**Checkpoint**: User Stories 1, 2 y 3 funcionales en su totalidad.

---

## Phase 6: User Story 4 - Navegación Temporal y Acceso Flotante Asistido (Priority: P4)

**Goal**: Proveer la selección interactiva de cualquier día en la tira semanal para filtrar las actividades de esa jornada, y conectar el botón circular flotante de micrófono con retroalimentación serena.

**Independent Test**: Seleccionar un día alterno en la tira semanal y comprobar que se refresquen las actividades; presionar el botón de micrófono y verificar el diálogo informativo de asistencia consciente.

### Implementation for User Story 4

- [x] T022 [US4] Conectar la selección de día en `WeeklyDayStrip` a `notifier.selectDate(date)` y enlazar el botón flotante de micrófono con diálogo informativo del agendador consciente en `lib/features/agenda/presentation/screens/agenda_screen.dart`

**Checkpoint**: Las 4 historias de usuario operativas y conformes con la Constitución.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Pruebas de integración de pantalla completa, verificación con `GoRouter` en `AppRoutes.agenda` y verificación estática sin advertencias.

- [x] T023 Escribir pruebas de widget de integración de pantalla completa en `test/widget/features/agenda/agenda_screen_test.dart`
- [x] T024 Ejecutar la suite completa de pruebas (`flutter test`) y verificación de análisis estático (`dart analyze`) asegurando 0 issues y 100% de éxito

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: Sin dependencias, inicia inmediatamente.
- **Foundational (Phase 2)**: Depende de Setup. Bloquea todas las historias de usuario.
- **User Stories (Phases 3-6)**: Dependen de Foundational (Phase 2).
- **Polish & Integration (Phase 7)**: Depende de las historias de usuario para componer la pantalla.

### User Story Dependencies

- **User Story 1 (P1)**: Depende de Phase 2. Constituye el MVP.
- **User Story 2 (P2)**: Depende de US1. Conecta la interacción de completado y ritmo.
- **User Story 3 (P3)**: Depende de US1. Añade el botón `+ Nueva` y modal de creación.
- **User Story 4 (P4)**: Depende de US1. Añade la navegación de días y botón de voz.

---

## Parallel Execution Opportunities

- T002, T003, T004, T005, T006, T007 pueden ejecutarse en paralelo dentro de Foundational.
- T012, T013, T014, T015 pueden ejecutarse en paralelo como componentes independientes de UI.
- Las pruebas de widget T011 y T019 pueden crearse en paralelo.

