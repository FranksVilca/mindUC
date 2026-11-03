# Tasks: 009-community-forum

**Input**: Design documents from `/specs/009-community-forum/` (`spec.md`, `plan.md`, `research.md`, `data-model.md`, `contracts/community_ui_contract.md`, `quickstart.md`)

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Estructura de carpetas y base modular para la característica `community_forum`.

- [ ] T001 Crear la estructura de directorios en `lib/features/community_forum/` (`domain/entities`, `domain/repositories`, `data/datasources`, `data/repositories`, `presentation/controllers`, `presentation/screens`, `presentation/widgets`) y en `test/{unit,widget}/features/community_forum/`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Entidades de dominio, fuentes de datos locales y controlador reactivo para el foro anónimo con estricta separación de identidades reales (Principio V).

**CRITICAL**: Ningún trabajo de historias de usuario puede comenzar hasta completar esta fase.

- [ ] T002 [P] Crear el enum `CommunityAvatar` en `lib/features/community_forum/domain/entities/community_avatar.dart` con los 4 avatares (`moon`, `sprout`, `raindrop`, `flower`), iconos, fondos y colores
- [ ] T003 [P] Crear el enum `CommunityMoodCategory` en `lib/features/community_forum/domain/entities/community_mood_category.dart` con categorías `todo`, `estresAcademico`, `desahogoCalma`, `habitoSaludable`, `vulnerabilidad`
- [ ] T004 [P] Crear el enum `EmbeddedCardType` y el Value Object `EmbeddedCardData` en `lib/features/community_forum/domain/entities/embedded_card_data.dart` con tipos `none`, `insightNotice`, `breathingPrompt`, `topReply`
- [ ] T005 [P] Crear la entidad inmutable `CommunityPost` en `lib/features/community_forum/domain/entities/community_post.dart` con campos de autor efímero, rol, avatar, facultad, tiempo, tags, contenido, contadores de reacción y `copyWith`
- [ ] T006 [P] Crear el modelo inmutable `CommunityState` en `lib/features/community_forum/domain/entities/community_state.dart` con lista de publicaciones, filtro activo (`selectedFilter`), conteo de hilos activos y getter `filteredPosts`
- [ ] T007 [P] Crear la interfaz abstracta `CommunityRepository` en `lib/features/community_forum/domain/repositories/community_repository.dart` con operaciones de obtención, publicación y conmutación de reacciones
- [ ] T008 [P] Implementar la fuente de datos local `LocalCommunityDataSource` en `lib/features/community_forum/data/datasources/local_community_datasource.dart` con los 3 hilos iniciales de Figma (`@BúhoCurioso`, `@BroteCalmo`, `@LluviaSuave`)
- [ ] T009 Implementar `LocalCommunityRepositoryImpl` en `lib/features/community_forum/data/repositories/local_community_repository_impl.dart` conforme al Principio V (cero fuga de datos personales)
- [ ] T010 Escribir pruebas unitarias para `CommunityNotifier` en `test/unit/features/community_forum/community_controller_test.dart` cubriendo filtrado por sentir, alternancia de reacciones y publicación anónima
- [ ] T011 Implementar `CommunityNotifier` y el proveedor `communityControllerProvider` en `lib/features/community_forum/presentation/controllers/community_controller.dart` implementando `ICommunityController`

**Checkpoint**: Capas de dominio, datos locales y controlador reactivo verificados con pruebas unitarias.

---

## Phase 3: User Story 1 - Visualización del Espacio Seguro UC y Cronología de Hilos (Priority: P1) 🎯 MVP

**Goal**: Visualizar la cabecera serena, banner "Comunidad UC Consciente" con insignia de identidad protegida, botón de compartir, filtros por sentir y tarjetas de publicaciones iniciales de Figma.

**Independent Test**: Ejecutar `flutter test test/widget/features/community_forum/community_post_card_test.dart` verificando la visualización correcta de los hilos y sus avatares efímeros.

### Tests for User Story 1

- [ ] T012 [P] [US1] Escribir pruebas de widget para el banner seguro y la tarjeta de publicación en `test/widget/features/community_forum/community_post_card_test.dart`

### Implementation for User Story 1

- [ ] T013 [P] [US1] Implementar el widget `CommunityHeader` en `lib/features/community_forum/presentation/widgets/community_header.dart` con botón de retorno, títulos "mindUC" y "Minduc — Comunidad", campana con punto rosa y avatar
- [ ] T014 [P] [US1] Implementar el widget `CommunityBannerCard` en `lib/features/community_forum/presentation/widgets/community_banner_card.dart` con insignias "ESPACIO SEGURO UC", "• Moderado con empatía", título, descripción y aviso de identidad protegida
- [ ] T015 [P] [US1] Implementar el widget `MoodFilterChips` en `lib/features/community_forum/presentation/widgets/mood_filter_chips.dart` con selector horizontal de categorías y contador de hilos activos
- [ ] T016 [US1] Implementar el widget `CommunityPostCard` en `lib/features/community_forum/presentation/widgets/community_post_card.dart` con avatar temático, alias efímero, facultad, tiempo relativo, tags, contenido, tarjeta incrustada y barra de reacciones
- [ ] T017 [US1] Implementar la pantalla principal `CommunityScreen` en `lib/features/community_forum/presentation/screens/community_screen.dart` consumiendo `communityControllerProvider` y botón "+ Compartir reflexión anónima"
- [ ] T018 [US1] Conectar `CommunityScreen` en la ruta declarativa `AppRoutes.community` (`/community`) en `lib/core/router/app_router.dart` sustituyendo el Scaffold placeholder provisional

**Checkpoint**: User Story 1 funcional y verificable de forma autónoma (MVP alcanzado).

---

## Phase 4: User Story 2 - Reacciones Conscientes Interactivas (Priority: P2)

**Goal**: Conectar los botones de reacción empática (`🤍❤️`, `🌿`, `💡`, `🫂`) en `CommunityPostCard` para alternar reactivamente el soporte comunitario del estudiante.

**Independent Test**: Tocar un botón de reacción en `community_post_card_test.dart` y comprobar el incremento del contador y la activación visual del botón.

### Implementation for User Story 2

- [ ] T019 [US2] Conectar los botones de reacción de `CommunityPostCard` con `notifier.toggleReaction(postId, reactionKey)` en `lib/features/community_forum/presentation/screens/community_screen.dart` con actualización instantánea

**Checkpoint**: User Stories 1 y 2 integradas y operativas.

---

## Phase 5: User Story 3 - Publicación de Reflexión Anónima con Alias Efímero (Priority: P3)

**Goal**: Proveer el modal `CommunityPostCreateModal` para redactar una reflexión con un alias efímero asignado aleatoriamente, facultad y categoría de sentir, garantizando la privacidad absoluta del autor.

**Independent Test**: Ejecutar `flutter test test/widget/features/community_forum/community_post_create_modal_test.dart` verificando la captura del texto, la ausencia de correos personales y la invocación de publicación.

### Tests for User Story 3

- [ ] T020 [P] [US3] Escribir pruebas de widget para el modal de publicación anónima en `test/widget/features/community_forum/community_post_create_modal_test.dart`

### Implementation for User Story 3

- [ ] T021 [US3] Implementar el widget modal `CommunityPostCreateModal` en `lib/features/community_forum/presentation/widgets/community_post_create_modal.dart` con generador aleatorio de alias ficticios, selección de facultad y etiquetas de sentir
- [ ] T022 [US3] Conectar el botón "+ Compartir reflexión anónima" en `CommunityScreen` con la apertura de `CommunityPostCreateModal.show` y la inserción del nuevo hilo en la cronología

**Checkpoint**: User Stories 1, 2 y 3 funcionales en su totalidad.

---

## Phase 6: User Story 4 - Tarjetas Enriquecidas y Moderación Ética (Priority: P4)

**Goal**: Enlazar el botón interactivo "Probar" de la tarjeta de la Guía 4–7–8 a `AppRoutes.breathingSession` e integrar el menú contextual de moderación compasiva (`⋮`).

**Independent Test**: Tocar el botón "Probar" en la tarjeta de respiración y verificar la navegación a la sesión guiada; tocar el menú `⋮` y comprobar las opciones de apoyo.

### Implementation for User Story 4

- [ ] T023 [US4] Enlazar la acción de la tarjeta de herramienta recomendada con la navegación a `AppRoutes.breathingSession` y conectar el menú `⋮` con diálogo compasivo en `lib/features/community_forum/presentation/widgets/community_post_card.dart`

**Checkpoint**: Las 4 historias de usuario operativas y conformes con la Constitución.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Pruebas de integración de pantalla completa, navegación desde Inicio y verificación estática sin advertencias.

- [ ] T024 Escribir pruebas de widget de integración de pantalla completa en `test/widget/features/community_forum/community_screen_test.dart`
- [ ] T025 Ejecutar la suite completa de pruebas (`flutter test`) y verificación de análisis estático (`dart analyze`) asegurando 0 issues y 100% de éxito

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: Sin dependencias, inicia inmediatamente.
- **Foundational (Phase 2)**: Depende de Setup. Bloquea todas las historias de usuario.
- **User Stories (Phases 3-6)**: Dependen de Foundational (Phase 2).
- **Polish & Integration (Phase 7)**: Depende de las historias de usuario para componer la pantalla.

### User Story Dependencies

- **User Story 1 (P1)**: Depende de Phase 2. Constituye el MVP.
- **User Story 2 (P2)**: Depende de US1. Añade reacciones interactivas.
- **User Story 3 (P3)**: Depende de US1. Añade publicación anónima.
- **User Story 4 (P4)**: Depende de US1. Añade navegación a herramientas de bienestar y moderación.

---

## Parallel Execution Opportunities

- T002, T003, T004, T005, T006, T007 pueden ejecutarse en paralelo dentro de Foundational.
- T013, T014, T015 pueden ejecutarse en paralelo como componentes independientes de UI.
- Las pruebas de widget T012 y T020 pueden crearse en paralelo.
