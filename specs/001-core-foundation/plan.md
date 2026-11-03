# Implementation Plan: 001-core-foundation

**Branch**: `001-core-foundation` | **Date**: 2026-11-02 | **Spec**: [`specs/001-core-foundation/spec.md`](file:///c:/Users/Usuario/Desktop/Code/mindUC/specs/001-core-foundation/spec.md)

**Input**: Feature specification from `specs/001-core-foundation/spec.md`

---

## Summary

Establecer los cimientos completos de mindUC construyendo el andamiaje del proyecto en Flutter 3.44.4 con arquitectura limpia orientada a características (`features/` + `core/`), el sistema de diseño centralizado adaptado fielmente a los 12 mockups de Figma (`AppTheme`, `MindButton`, `MindCard`, `MindChip`, `MindInputField`), la barra de navegación persistente de 4 pestañas mediante `GoRouter` (`StatefulShellRoute.indexedStack`), y la capa de infraestructura de datos desacoplada para Firebase (Auth + Cloud Firestore con soporte offline y Result pattern).

---

## Technical Context

**Language/Version**: Dart 3.12.2 con `sound null safety` estricto  
**Primary Dependencies**: `flutter_riverpod: ^2.6.1`, `go_router: ^14.6.2`, `firebase_core: ^3.8.0`, `firebase_auth: ^5.3.3`, `cloud_firestore: ^5.5.0`, `google_fonts: ^6.2.1`, `flutter_svg: ^2.0.16`, `flutter_animate: ^4.5.2`  
**Storage**: Cloud Firestore (NoSQL reactivo y offline) + `flutter_secure_storage: ^9.2.2` (almacenamiento local seguro de claves y tokens)  
**Testing**: `flutter_test`, `mocktail: ^1.0.4` (tests unitarios y de widgets con Fake DataSources)  
**Target Platform**: Android (minSdk 21, targetSdk 34) e iOS (iOS 14.0+)  
**Project Type**: Mobile Application (Flutter Multiplatform)  
**Performance Goals**: 60-120 fps constantes en animaciones y transiciones de pestañas (< 16 ms por frame), tiempo de arranque del primer frame < 1.5s  
**Constraints**: Zero RenderFlex overflows, Clean Architecture estricta (dominio sin dependencias de SDKs externos), tolerancia a modo sin conexión (Offline-First)  
**Scale/Scope**: 4 pestañas base del shell (`Inicio`, `Bienestar`, `Agenda`, `Perfil`), 12 tokens de diseño, 5 componentes atómicos reutilizables, infraestructura de repositorios y autenticación base  

---

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principio de la Constitución v1.1.0 | Estado de Cumplimiento | Evidencia Técnica en este Plan |
| :--- | :--- | :--- |
| **I. Clean Architecture & Feature-First** | ✅ **PASÓ** | Estructura estricta: `core/` (transversal) y `features/` divididos en `domain/`, `data/` y `presentation/`. Dominio 100% puro. |
| **II. Spec-Driven & Test-First** | ✅ **PASÓ** | Pruebas de widgets para cada componente atómico, pruebas unitarias para repositorios y entidades. Cero código huérfano. |
| **III. Figma como Fuente de Verdad** | ✅ **PASÓ** | Tokens de color (`#FBF9F4`, `#718E81`, `#EAF1ED`, etc.), radios de 22 dp y componentes modelados directamente desde los mockups oficiales. |
| **IV. Riverpod, GoRouter y Firebase** | ✅ **PASÓ** | `StatefulShellRoute.indexedStack` en GoRouter; Firebase Auth + Firestore encapsulados tras interfaces de repositorio abstractas. |
| **V. Privacidad y Seguridad por Diseño** | ✅ **PASÓ** | `flutter_secure_storage` para datos sensibles, tipado de errores `Result<T, Failure>` y preparación para cifrado local del diario. |
| **VI. [DIFERIDO] IA y Gamificación Avanzada** | ⏸️ **DIFERIDO** | Fuera de alcance en esta especificación fundamental según enmienda v1.1.0. |
| **VII. [DIFERIDO] Bloqueo Nativo en SO** | ⏸️ **DIFERIDO** | Fuera de alcance en esta especificación fundamental según enmienda v1.1.0. |

---

## Project Structure

### Documentation (this feature)

```text
specs/001-core-foundation/
├── spec.md              # Especificación funcional aprobada
├── plan.md              # Este plan de implementación técnico
├── research.md          # Investigación de stack, dependencias y tokens de diseño
├── data-model.md        # Entidades de dominio, DTOs y esquemas de Firestore
├── quickstart.md        # Guía paso a paso de ejecución y pruebas
└── contracts/
    ├── auth_contract.md         # Interfaz de AuthRepository
    ├── theme_contract.md        # Tokens de diseño y constantes de tema
    └── navigation_contract.md   # Rutas y claves del navegador GoRouter
```

### Source Code Layout

```text
lib/
├── app.dart                              # MaterialApp.router con MindTheme y ProviderScope
├── core/
│   ├── constants/
│   │   ├── app_assets.dart               # Rutas a SVGs, ilustraciones e iconos
│   │   └── app_strings.dart              # Textos oficiales de interfaz
│   ├── design_system/
│   │   ├── buttons/
│   │   │   └── mind_button.dart          # Botón píldora animado (filled, outlined, loading)
│   │   ├── cards/
│   │   │   └── mind_card.dart            # Tarjeta serena con radio 22 dp
│   │   ├── chips/
│   │   │   └── mind_chip.dart            # Chips de categoría con dot de color
│   │   ├── inputs/
│   │   │   └── mind_input_field.dart     # Campo de texto sereno
│   │   └── navigation/
│   │       └── mind_bottom_nav_bar.dart  # Barra inferior de 4 destinos de Figma
│   ├── error/
│   │   ├── exceptions.dart               # ServerException, AuthException, CacheException
│   │   ├── failures.dart                 # AppFailure, AuthFailure, NetworkFailure
│   │   └── result.dart                   # Tipo monádico Result<T, Failure>
│   ├── firebase/
│   │   └── firebase_initializer.dart     # Inicialización segura y modo Offline
│   ├── router/
│   │   ├── app_router.dart               # GoRouter con StatefulShellRoute
│   │   └── route_names.dart              # Constantes de rutas
│   ├── storage/
│   │   └── secure_storage_service.dart   # Wrapper de FlutterSecureStorage
│   └── theme/
│       ├── mind_colors.dart              # Paleta exacta extraída de Figma
│       ├── mind_radii.dart               # Radios geométricos
│       ├── mind_typography.dart          # GoogleFonts (Plus Jakarta Sans)
│       └── mind_theme.dart               # ThemeData para modo claro/oscuro
└── features/
    ├── auth/
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   ├── auth_remote_datasource.dart
    │   │   │   └── fake_auth_datasource.dart
    │   │   ├── models/
    │   │   │   └── user_model.dart
    │   │   └── repositories/
    │   │       └── auth_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   └── user_entity.dart
    │   │   ├── repositories/
    │   │   │   └── auth_repository.dart
    │   │   └── usecases/
    │   │       ├── sign_in_usecase.dart
    │   │       └── sign_up_usecase.dart
    │   └── presentation/
    │       ├── controllers/
    │       │   └── auth_controller.dart
    │       └── screens/
    │           └── welcome_auth_screen.dart
    ├── home/
    │   └── presentation/
    │       └── screens/
    │           └── home_screen.dart      # Pantalla Inicio (Saludo, Selector de ánimo, Espacios)
    ├── wellness/
    │   └── presentation/
    │       └── screens/
    │           └── wellness_screen.dart  # Pantalla Bienestar (Sanctuary Mode)
    ├── agenda/
    │   └── presentation/
    │       └── screens/
    │           └── agenda_screen.dart    # Pantalla Agenda (Semana, Ritmo, Filtros)
    └── profile/
        └── presentation/
            └── screens/
                └── profile_screen.dart   # Pantalla Perfil (Datos UC, Línea de Apoyo)

test/
├── unit/
│   ├── core/
│   │   └── result_test.dart
│   └── features/
│       └── auth/
│           └── auth_repository_test.dart
└── widget/
    └── core/
        └── design_system/
            ├── mind_button_test.dart
            ├── mind_card_test.dart
            ├── mind_chip_test.dart
            └── mind_bottom_nav_test.dart
```

---

## Complexity Tracking

| Decisión Arquitectónica | Justificación | Alternativa Más Simple Descartada |
| :--- | :--- | :--- |
| **StatefulShellRoute con IndexedStack** | Conserva el scroll, selecciones y estado de las 4 pestañas de bienestar al navegar entre ellas, eliminando recargas visuales. | BottomNavigationBar simple con `setState`: destruiría el estado de los temporizadores y formularios en curso cada vez que el usuario cambia de pestaña. |
| **Result Pattern (`Result<T, Failure>`)** | Evita excepciones no controladas y obliga a los controladores de presentación a manejar explícitamente tanto el caso exitoso como el error. | `try/catch` tradicional disperso en widgets: propenso a pantallas congeladas o excepciones no capturadas. |
| **Repositorios Desacoplados con FakeDataSources** | Permite ejecutar toda la suite de pruebas unitarias y de widgets en CI y en local sin credenciales reales de Firebase ni conexión a internet. | Acoplamiento directo a `FirebaseAuth.instance`: rompería los tests automatizados cuando no hay internet o credenciales configuradas. |
