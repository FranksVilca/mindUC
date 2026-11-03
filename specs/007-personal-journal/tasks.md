# Tasks: Diario Personal Íntimo (007-personal-journal)

**Input**: Design documents from `/specs/007-personal-journal/`
**Prerequisites**: `plan.md`, `spec.md`, `research.md`, `data-model.md`, `contracts/journal_ui_contract.md`, `quickstart.md`
**Tests**: Included and required per Constitution Principle II (Spec-Driven & Test-First).
**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `- [ ] [TaskID] [P?] [Story?] Description with file path`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (`[US1]`, `[US2]`, `[US3]`, `[US4]`)
- Include exact file paths in descriptions

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Estructura de directorios y módulos para la característica `personal_journal`.

- [ ] T001 Crear la estructura de directorios de la característica en `lib/features/personal_journal/` (`domain/entities`, `domain/repositories`, `data/datasources`, `data/repositories`, `presentation/controllers`, `presentation/screens`, `presentation/widgets`) y en `test/{unit,widget}/features/personal_journal/`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Entidades de dominio, fuentes de datos locales y controlador reactivo con almacenamiento seguro en el dispositivo (Principio V).

- [ ] T002 [P] Crear la entidad `JournalMoodPulse` en `lib/features/personal_journal/domain/entities/journal_mood_pulse.dart` con los 5 estados emocionales (`agradecida`, `enCalma`, `reflexiva`, `cansada`, `abrumada`), etiquetas, iconos y textos de chip
- [ ] T003 [P] Crear la entidad inmutable `JournalEntry` en `lib/features/personal_journal/domain/entities/journal_entry.dart` con campos `id`, `title`, `content`, `moodPulse`, `createdAt`, `updatedAt`, getters `readingTimeMinutes`, `readingTimeString`, `previewSnippet`, `formattedDate` y `copyWith`
- [ ] T004 [P] Crear el Value Object inmutable `JournalState` en `lib/features/personal_journal/domain/entities/journal_state.dart` con lista de entradas, pulso emocional activo, indicador de carga y getters `entryCount`, `hasEntries`
- [ ] T005 [P] Crear la interfaz abstracta `JournalRepository` en `lib/features/personal_journal/domain/repositories/journal_repository.dart` con métodos para obtener, guardar y eliminar entradas
- [ ] T006 [P] Implementar la fuente de datos local `LocalJournalDataSource` en `lib/features/personal_journal/data/datasources/local_journal_datasource.dart` con almacenamiento seguro en memoria del dispositivo y las 3 entradas iniciales de Figma
- [ ] T007 Implementar el repositorio local `LocalJournalRepositoryImpl` en `lib/features/personal_journal/data/repositories/local_journal_repository_impl.dart` garantizando 0 llamadas de red conforme al Principio V
- [ ] T008 Escribir pruebas unitarias para `JournalNotifier` en `test/unit/features/personal_journal/journal_controller_test.dart` cubriendo obtención, creación, edición, borrado de reflexiones y sintonía de pulso emocional
- [ ] T009 Implementar `JournalNotifier` y el proveedor `journalControllerProvider` en `lib/features/personal_journal/presentation/controllers/journal_controller.dart` implementando `IJournalController`

**Checkpoint**: Capas de dominio, datos locales y controlador reactivo verificados con pruebas unitarias.

---

## Phase 3: User Story 1 - Cronología de Huellas Interiores y Visualización Segura (Priority: P1) 🎯 MVP

**Goal**: Mostrar la cabecera con insignia "ESPACIO SAGRADO", título "Mi Diario Personal", banner de privacidad y lista de tarjetas reflexivas con badges emocionales, fechas en español, extractos y aviso "🔒 Solo visible en este teléfono".

**Independent Test**: Ejecutar `flutter test test/widget/features/personal_journal/journal_entry_card_test.dart` verificando la presencia de las huellas interiores y el indicador de privacidad local.

### Tests for User Story 1

- [ ] T010 [P] [US1] Escribir pruebas de widget para el banner de privacidad y la tarjeta reflexiva en `test/widget/features/personal_journal/journal_entry_card_test.dart`

### Implementation for User Story 1

- [ ] T011 [P] [US1] Implementar el widget `JournalPrivacyBanner` en `lib/features/personal_journal/presentation/widgets/journal_privacy_banner.dart` con icono de libro "ESPACIO SAGRADO", título "Mi Diario Personal" y banner de cifrado con candado
- [ ] T012 [US1] Implementar el widget `JournalEntryCard` en `lib/features/personal_journal/presentation/widgets/journal_entry_card.dart` con chip emocional (ej. `🌸 En calma`), fecha formateada en español, título, extracto a 2 líneas, pie "🔒 Solo visible en este teléfono", tiempo de lectura, botón lápiz y botón menú `⋮`

**Checkpoint**: User Story 1 funcional y verificable de forma autónoma (MVP alcanzado).

---

## Phase 4: User Story 2 - Selector de Pulso Emocional ("¿Cómo late tu corazón hoy?") (Priority: P2)

**Goal**: Proveer el selector interactivo horizontal con 5 estados ("Agradecida", "En calma", "Reflexiva", "Cansada", "Abrumada") destacando la opción activa con acento botánico y actualizando el estado de la sesión.

**Independent Test**: Ejecutar `flutter test test/widget/features/personal_journal/emotional_pulse_selector_test.dart` verificando la alternancia entre emociones y la respuesta reactiva al toque.

### Tests for User Story 2

- [ ] T013 [P] [US2] Escribir pruebas de widget para el selector de pulso emocional en `test/widget/features/personal_journal/emotional_pulse_selector_test.dart`

### Implementation for User Story 2

- [ ] T014 [US2] Implementar el widget `EmotionalPulseSelector` en `lib/features/personal_journal/presentation/widgets/emotional_pulse_selector.dart` con título "¿Cómo late tu corazón hoy?", subtítulo "Sintoniza tu sentir" y los 5 botones de pulso emocional

**Checkpoint**: User Stories 1 y 2 integradas y operativas.

---

## Phase 5: User Story 3 - Creación y Edición de Entradas Reflexivas (Priority: P3)

**Goal**: Proveer el botón lavanda `+ Nueva entrada reflexiva` y el modal interactivo de creación/edición de reflexiones con selector de emoción, título, cuerpo y guardado seguro.

**Independent Test**: Ejecutar `flutter test test/widget/features/personal_journal/journal_entry_edit_modal_test.dart` verificando la redacción, edición y persistencia de una nueva huella interior.

### Tests for User Story 3

- [ ] T015 [P] [US3] Escribir pruebas de widget para el modal de redacción y edición en `test/widget/features/personal_journal/journal_entry_edit_modal_test.dart`

### Implementation for User Story 3

- [ ] T016 [US3] Implementar el diálogo modal `JournalEntryEditModal` en `lib/features/personal_journal/presentation/widgets/journal_entry_edit_modal.dart` con campos de título, contenido, selector de emoción y validación suave

**Checkpoint**: User Stories 1, 2 y 3 funcionales en su totalidad.

---

## Phase 6: User Story 4 - Privacidad por Diseño y Menú de Opciones (Principio V) (Priority: P4)

**Goal**: Proveer el menú de opciones contextuales (`⋮`) en cada tarjeta reflexiva con confirmación compasiva para eliminar entradas del dispositivo.

**Independent Test**: Comprobar la eliminación de entradas desde `journal_entry_card_test.dart` confirmando la actualización del contador en la cronología.

### Implementation for User Story 4

- [ ] T017 [US4] Implementar el diálogo de confirmación compasiva de eliminación en `lib/features/personal_journal/presentation/widgets/journal_entry_card.dart` vinculado al menú `⋮`

**Checkpoint**: Las 4 historias de usuario operativas y conformes con el Principio V.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Integración de la pantalla completa `JournalScreen`, cabecera de navegación, vinculación con `AppRoutes.journalNew`, pruebas de integración y verificación estática.

- [ ] T018 [P] Implementar el widget `JournalHeader` en `lib/features/personal_journal/presentation/widgets/journal_header.dart` con logo "mindUC", subtítulo "Minduc — Diario Personal", campana y avatar
- [ ] T019 Implementar la pantalla principal `JournalScreen` en `lib/features/personal_journal/presentation/screens/journal_screen.dart` con botón lavanda "+ Nueva entrada reflexiva", sección "Tus huellas interiores" y lista reactiva
- [ ] T020 Conectar `JournalScreen` en la ruta declarativa `AppRoutes.journalNew` (y `/journal`) en `lib/core/router/app_router.dart` sustituyendo el Scaffold placeholder provisional
- [ ] T021 Escribir pruebas de widget de integración de pantalla completa en `test/widget/features/personal_journal/journal_screen_test.dart`
- [ ] T022 Ejecutar la suite completa de pruebas (`flutter test`) y verificación de análisis estático (`dart analyze`) asegurando 0 issues y 100% de éxito

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: Sin dependencias, inicia inmediatamente.
- **Foundational (Phase 2)**: Depende de Phase 1. Bloquea todas las historias de usuario.
- **User Stories (Phases 3-6)**: Dependen de Foundational (Phase 2).
- **Polish & Integration (Phase 7)**: Depende de las historias de usuario para componer la pantalla.

### User Story Dependencies

- **User Story 1 (P1)**: Depende de Phase 2. Constituye el MVP.
- **User Story 2 (P2)**: Depende de Phase 2. Añade sintonía de pulso emocional.
- **User Story 3 (P3)**: Depende de Phase 2 y US1/US2. Añade redacción y edición.
- **User Story 4 (P4)**: Depende de US1. Añade opciones de gestión local y borrado.

---

## Parallel Execution Opportunities

- T002, T003, T004, T005, T006 (Entidades, contratos y fuente local) pueden implementarse en paralelo.
- T010 (Pruebas US1) y T011 (Banner) pueden ejecutarse en paralelo.
- T013 (Pruebas US2) y T015 (Pruebas US3) pueden prepararse en paralelo.
- T018 (Cabecera) puede desarrollarse en paralelo a los widgets de las historias.

---

## Implementation Strategy

### MVP First (User Story 1)
1. Completar Phase 1 (Setup) y Phase 2 (Foundational: dominio, repositorio local y controlador).
2. Completar Phase 3 (User Story 1: banner de privacidad y tarjetas de huellas interiores).
3. **Validar MVP**: Ejecutar `flutter test test/widget/features/personal_journal/journal_entry_card_test.dart`.

### Incremental Delivery
1. Añadir Phase 4 (US2: Selector de pulso emocional).
2. Añadir Phase 5 (US3: Redacción y edición modal).
3. Añadir Phase 6 (US4: Eliminación compasiva).
4. Completar Phase 7 (Integración en pantalla, GoRouter y suite completa de pruebas).
