# Implementation Plan: 011-profile-settings

**Branch**: `011-profile-settings` | **Date**: 2026-11-03 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/011-profile-settings/spec.md`

## Summary

Implementar la pantalla de Perfil y Configuración (`ProfileScreen`) basada en el mockup oficial de Figma `mindUC - Perfil y Configuracion.png`. La pantalla organiza la identidad del estudiante ("Camila Soto", Psicología, correo UC), preferencias de bienestar (sonido ambiental favorito, técnica de respiración y recordatorios conscientes con switch reactivo), acceso a soporte institucional confidencial (Línea de Apoyo Psicológico con botón "Llamar ↗") y cierre de sesión seguro en el dispositivo. La implementación sigue Clean Architecture Feature-First, Riverpod (`StateNotifier`) y la navegación declarativa de GoRouter en la pestaña 3 persistente de la barra inferior.

## Technical Context

**Language/Version**: Dart 3.x con Null Safety estricto (Flutter 3.x estable).

**Primary Dependencies**: `flutter_riverpod: ^2.6.1`, `go_router: ^14.8.1`, `google_fonts: ^6.3.3`.

**Storage**: `LocalProfileDataSource` en memoria (con datos de Figma de Camila Soto) desacoplado mediante `ProfileRepository`, listo para conectar con Cloud Firestore en fases posteriores.

**Testing**: `flutter_test` (pruebas unitarias para `ProfileNotifier` y pruebas de widget para tarjetas de perfil, preferencias, soporte y pantalla completa).

**Target Platform**: Mobile (iOS & Android) y Web.

**Project Type**: Mobile Application (Clean Architecture Feature-First).

**Performance Goals**: Renderizado inmediato a 60 fps; tiempo de respuesta a interacciones y alternancias de switch < 50 ms.

**Constraints**: Fidelidad visual idéntica a Figma; adhesión a los Principios I, II, III y V de la Constitución de mindUC; 0 advertencias en `dart analyze`.

**Scale/Scope**: 1 pantalla integrada, 1 controlador Riverpod, 6 widgets especializados, 2 modales de interacción (soporte y selección de preferencias).

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Principio I (Clean Architecture Feature-First)**: ✅ PASA. La estructura separa estrictamente `domain/`, `data/` y `presentation/` en `lib/features/profile/`.
- **Principio II (Spec-Driven & Test-First)**: ✅ PASA. Pruebas unitarias para el controlador y de widgets para cada componente y flujo completo.
- **Principio III (Fidelidad Visual Absoluta y Figma como Verdad Visual)**: ✅ PASA. Replicación exacta del diseño `mindUC - Perfil y Configuracion.png` utilizando tokens centralizados de `MindColors` y `MindTypography`.
- **Principio IV (Riverpod & GoRouter)**: ✅ PASA. `profileControllerProvider` gestiona el estado y `AppRoutes.profile` (`/profile`) en `StatefulShellRoute` aloja la pantalla.
- **Principio V (Privacidad por Diseño y Soporte Institucional)**: ✅ PASA. El soporte psicológico confidencial está accesible sin fricciones y el cierre de sesión protege la privacidad.
- **Principios VI y VII (Diferidos)**: ✅ PASA. No se incluyen LLMs conversacionales ni bloqueos nativos a nivel de sistema operativo.

## Project Structure

### Documentation (this feature)

```text
specs/011-profile-settings/
├── spec.md              # Requisitos y especificación funcional
├── plan.md              # Este plan de implementación
├── research.md          # Tokens de diseño y decisiones de arquitectura
├── data-model.md        # Entidades de dominio y modelos de datos
├── quickstart.md        # Guía de verificación automatizada y manual
├── checklists/
│   └── requirements.md  # Checklist de calidad de especificación (16/16)
└── contracts/
    └── profile_ui_contract.md # Contratos del controlador y widgets
```

### Source Code (repository root)

```text
lib/features/profile/
├── domain/
│   ├── entities/
│   │   ├── user_profile.dart
│   │   ├── wellness_preferences.dart
│   │   ├── institutional_support_contact.dart
│   │   └── profile_state.dart
│   └── repositories/
│       └── profile_repository.dart
├── data/
│   ├── datasources/
│   │   └── local_profile_datasource.dart
│   └── repositories/
│       └── local_profile_repository_impl.dart
└── presentation/
    ├── controllers/
    │   └── profile_controller.dart
    ├── screens/
    │   └── profile_screen.dart
    └── widgets/
        ├── profile_header.dart
        ├── student_identity_card.dart
        ├── wellness_preferences_card.dart
        ├── institutional_support_card.dart
        ├── logout_button.dart
        ├── support_contact_modal.dart
        └── preference_selection_modal.dart

test/
├── unit/
│   └── features/
│       └── profile/
│           └── profile_controller_test.dart
└── widget/
    └── features/
        └── profile/
            ├── profile_cards_test.dart
            └── profile_screen_test.dart
```

**Structure Decision**: Clean Architecture Feature-First estándar del proyecto mindUC, modularizando la pantalla existente `ProfileScreen` en widgets reutilizables con un controlador reactivo desacoplado.

## Complexity Tracking

> Ninguna violación a los principios constitucionales. No se requiere justificación de complejidad adicional.
