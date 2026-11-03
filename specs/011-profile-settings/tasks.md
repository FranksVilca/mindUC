# Tasks: 011-profile-settings

**Input**: Design documents from `/specs/011-profile-settings/` (`spec.md`, `plan.md`, `research.md`, `data-model.md`, `contracts/profile_ui_contract.md`, `quickstart.md`)

**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3, US4)
- Include exact file paths in descriptions

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Estructura de carpetas y base modular para la característica `profile`.

- [ ] T001 Crear y verificar la estructura de directorios en `lib/features/profile/` (`domain/entities`, `domain/repositories`, `data/datasources`, `data/repositories`, `presentation/controllers`, `presentation/screens`, `presentation/widgets`) y en `test/{unit,widget}/features/profile/`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Entidades de dominio, fuentes de datos locales y controlador reactivo Riverpod para el perfil del estudiante y configuración de bienestar.

**CRITICAL**: Ningún trabajo de historias de usuario puede comenzar hasta completar esta fase.

- [ ] T002 [P] Crear la entidad `UserProfile` en `lib/features/profile/domain/entities/user_profile.dart` con `id`, `fullName`, `career`, `universityEmail`, `avatarUrl`, `isMindfulActive` y `copyWith`
- [ ] T003 [P] Crear el Value Object `WellnessPreferences` en `lib/features/profile/domain/entities/wellness_preferences.dart` con sonido predeterminado, técnica de respiración, estado de recordatorios conscientes y `copyWith`
- [ ] T004 [P] Crear el Value Object `InstitutionalSupportContact` en `lib/features/profile/domain/entities/institutional_support_contact.dart` con título, descripción, teléfono confidencial y anexo institucional
- [ ] T005 [P] Crear el modelo de estado inmutable `ProfileState` en `lib/features/profile/domain/entities/profile_state.dart` agrupando usuario, preferencias, contacto de soporte, `isLoading` y `errorMessage`
- [ ] T006 [P] Definir la interfaz abstracta `ProfileRepository` en `lib/features/profile/domain/repositories/profile_repository.dart`
- [ ] T007 [P] Implementar la fuente de datos local `LocalProfileDataSource` en `lib/features/profile/data/datasources/local_profile_datasource.dart` con los datos de Figma de Camila Soto
- [ ] T008 Implementar `LocalProfileRepositoryImpl` en `lib/features/profile/data/repositories/local_profile_repository_impl.dart` retornando tipos `Result<T, Failure>`
- [ ] T009 Escribir pruebas unitarias para `ProfileNotifier` en `test/unit/features/profile/profile_controller_test.dart` cubriendo carga de perfil, toggle de recordatorios, cambio de preferencias y logout
- [ ] T010 Implementar `ProfileNotifier` y el proveedor `profileControllerProvider` en `lib/features/profile/presentation/controllers/profile_controller.dart` implementando `IProfileController`

**Checkpoint**: Capas de dominio, datos locales y controlador reactivo verificados con pruebas unitarias.

---

## Phase 3: User Story 1 - Identidad del Estudiante y Cabecera de Perfil (Priority: P1) 🎯 MVP

**Goal**: Visualizar la cabecera serena con "mindUC" / "Perfil", accesos de configuración y cuenta, y la tarjeta de identidad de Camila Soto con avatar, indicador verde de presencia consciente, carrera y correo.

**Independent Test**: Ejecutar `flutter test test/widget/features/profile/profile_cards_test.dart` verificando la visualización correcta de la cabecera y la tarjeta de perfil.

### Tests for User Story 1

- [ ] T011 [P] [US1] Escribir pruebas de widget para cabecera e identidad del estudiante en `test/widget/features/profile/profile_cards_test.dart`

### Implementation for User Story 1

- [ ] T012 [P] [US1] Implementar el widget `ProfileHeader` en `lib/features/profile/presentation/widgets/profile_header.dart` con identidad "mindUC", título centrado "Perfil", y dos iconos de acción a la derecha
- [ ] T013 [P] [US1] Implementar el widget `StudentIdentityCard` en `lib/features/profile/presentation/widgets/student_identity_card.dart` con avatar circular, punto verde de presencia consciente, "Camila Soto", "Psicología" y "camila.soto@uc.cl"
- [ ] T014 [US1] Actualizar `ProfileScreen` en `lib/features/profile/presentation/screens/profile_screen.dart` consumiendo `profileControllerProvider` e integrando `ProfileHeader` y `StudentIdentityCard`

**Checkpoint**: User Story 1 funcional y verificable de forma autónoma (MVP alcanzado).

---

## Phase 4: User Story 2 - Preferencias de Bienestar y Configuración Consciente (Priority: P2)

**Goal**: Visualizar la sección de preferencias con icono de ajustes, ítems de sonido ambiental y técnica de respiración con modales de selección, y switch reactivo de recordatorios conscientes.

**Independent Test**: Ejecutar `flutter test test/widget/features/profile/wellness_preferences_test.dart` alternando el switch y abriendo el selector de preferencias.

### Tests for User Story 2

- [ ] T015 [P] [US2] Escribir pruebas de widget para las preferencias de bienestar y reactividad del switch en `test/widget/features/profile/wellness_preferences_test.dart`

### Implementation for User Story 2

- [ ] T016 [P] [US2] Implementar la hoja modal `PreferenceSelectionModal` en `lib/features/profile/presentation/widgets/preference_selection_modal.dart` para selección serena de sonidos y técnicas
- [ ] T017 [US2] Implementar el widget `WellnessPreferencesCard` en `lib/features/profile/presentation/widgets/wellness_preferences_card.dart` con encabezado "PREFERENCIAS DE BIENESTAR", icono de ajustes, ítems de sonido, respiración y switch interactivo
- [ ] T018 [US2] Integrar `WellnessPreferencesCard` en `ProfileScreen` conectando los callbacks reactivos con `ProfileNotifier`

**Checkpoint**: User Stories 1 y 2 integradas y operativas.

---

## Phase 5: User Story 3 - Acceso Inmediato a Soporte Institucional Confidencial (Priority: P3)

**Goal**: Visualizar la tarjeta verde pastel de soporte con la Línea de Apoyo Psicológico confidencial de la universidad y desplegar el diálogo modal respetuoso de contención al pulsar "Llamar ↗".

**Independent Test**: Ejecutar `flutter test test/widget/features/profile/institutional_support_test.dart` verificando la tarjeta de soporte y la apertura del diálogo modal de llamada.

### Tests for User Story 3

- [ ] T019 [P] [US3] Escribir pruebas de widget para la tarjeta de soporte y el modal de contacto en `test/widget/features/profile/institutional_support_test.dart`

### Implementation for User Story 3

- [ ] T020 [P] [US3] Implementar el diálogo modal `SupportContactModal` en `lib/features/profile/presentation/widgets/support_contact_modal.dart` con anexo `*4000`, teléfono, horario 24/7 y explicación confidencial
- [ ] T021 [US3] Implementar el widget `InstitutionalSupportCard` en `lib/features/profile/presentation/widgets/institutional_support_card.dart` con fondo pastel, icono de teléfono blanco, datos del anexo y botón píldora "Llamar ↗"
- [ ] T022 [US3] Integrar `InstitutionalSupportCard` en `ProfileScreen` desplegando `SupportContactModal` al tocar "Llamar ↗"

**Checkpoint**: User Stories 1, 2 y 3 funcionales en su totalidad.

---

## Phase 6: User Story 4 - Cierre de Sesión Seguro en el Dispositivo y Pantalla Integrada (Priority: P4)

**Goal**: Proveer el botón "Cerrar sesión en este dispositivo" con diálogo de confirmación compasivo, cierre de sesión en `AuthController` y redirección a `AppRoutes.login`.

**Independent Test**: Ejecutar `flutter test test/widget/features/profile/profile_screen_test.dart` verificando la navegación integrada y el flujo de cierre de sesión.

### Implementation for User Story 4

- [ ] T023 [P] [US4] Implementar el widget `LogoutButton` en `lib/features/profile/presentation/widgets/logout_button.dart` con diseño contorneado blanco y icono `Icons.logout_rounded`
- [ ] T024 [US4] Integrar `LogoutButton` en `ProfileScreen` con diálogo de confirmación compasivo y redirección a `/login` tras cerrar sesión
- [ ] T025 [US4] Escribir pruebas de widget de integración completa en `test/widget/features/profile/profile_screen_test.dart` verificando todas las secciones, reactividad del switch y flujo de cierre de sesión

**Checkpoint**: Las 4 historias de usuario operativas y conformes con la Constitución.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Verificación de análisis estático sin advertencias y paso del 100% de la suite de pruebas del proyecto.

- [ ] T026 Ejecutar la suite completa de pruebas (`flutter test`) y verificación de análisis estático (`dart analyze`) asegurando 0 issues y 100% de éxito

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: Sin dependencias, inicia inmediatamente.
- **Foundational (Phase 2)**: Depende de Setup. Bloquea todas las historias de usuario.
- **User Stories (Phases 3-6)**: Dependen de Foundational (Phase 2).
- **Polish & Integration (Phase 7)**: Depende de las historias de usuario para componer la pantalla final.

### User Story Dependencies

- **User Story 1 (P1)**: Depende de Phase 2. Constituye el MVP.
- **User Story 2 (P2)**: Depende de US1. Añade preferencias conscientes y switch reactivo.
- **User Story 3 (P3)**: Depende de US1. Añade soporte institucional y diálogo de contención.
- **User Story 4 (P4)**: Depende de US1, US2 y US3. Valida el botón de salida y la pantalla integrada completa.

---

## Parallel Execution Opportunities

- T002, T003, T004, T005, T006, T007 pueden ejecutarse en paralelo dentro de Foundational.
- T012 y T013 pueden ejecutarse en paralelo en US1.
- T016 y T017 pueden ejecutarse en paralelo en US2.
- Las pruebas de widget T011, T015, T019 pueden crearse en paralelo.
