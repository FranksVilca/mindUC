# Implementation Plan: 002-auth-welcome

**Branch**: `002-auth-welcome` | **Date**: 2026-11-02 | **Spec**: [`specs/002-auth-welcome/spec.md`](file:///c:/Users/Usuario/Desktop/Code/mindUC/specs/002-auth-welcome/spec.md)

**Input**: Feature specification from `specs/002-auth-welcome/spec.md`

---

## Summary

Implementar la pantalla completa de Bienvenida y Autenticación de mindUC reproduciendo fielmente el mockup de Figma (`mindUC - Bienvenida y Autenticación.png`), con selector segmentado animado entre "Iniciar sesión" y "Registrarse", validación de correo institucional (`@uc.cl`) o personal, alternador de visibilidad de contraseña, recuperación serena de contraseña, integración con `AuthRepository` (Firebase Auth + Cloud Firestore), controlador reactivo de UI con Riverpod, y protección de rutas en `GoRouter` mediante redirección reactiva de sesión.

---

## Technical Context

**Language/Version**: Dart 3.12.2 con `sound null safety` estricto  
**Primary Dependencies**: `flutter_riverpod: ^2.6.1`, `go_router: ^14.6.2`, `firebase_auth: ^5.3.3`, `cloud_firestore: ^5.5.0`, `flutter_animate: ^4.5.2`  
**Storage**: Cloud Firestore (perfil de usuario en `users/{userId}`) y `SecureStorageService` para persistencia local de sesión  
**Testing**: `flutter_test`, `mocktail` (pruebas unitarias y de widgets con `FakeAuthDataSource`)  
**Target Platform**: Android e iOS  
**Project Type**: Mobile Application Screen & Auth Routing  
**Performance Goals**: Transición fluida a 60 fps al alternar entre pestañas del selector segmentado, renderizado del formulario en < 16ms  
**Constraints**: Zero RenderFlex overflows con el teclado virtual desplegado, Clean Architecture estricta  
**Scale/Scope**: 1 pantalla completa de bienvenida/auth, 1 selector segmentado animado, 1 diálogo de restablecimiento de contraseña, integración con GoRouter y tests de widgets  

---

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principio de la Constitución v1.1.0 | Estado de Cumplimiento | Evidencia Técnica en este Plan |
| :--- | :--- | :--- |
| **I. Clean Architecture & Feature-First** | ✅ **PASÓ** | Lógica de presentación en `features/auth/presentation/`, usando casos de uso en `domain/` y repositorios abstractos. |
| **II. Spec-Driven & Test-First** | ✅ **PASÓ** | Pruebas de widgets para la pantalla de bienvenida y el diálogo de recuperación antes de la implementación final. |
| **III. Figma como Fuente de Verdad** | ✅ **PASÓ** | Reproducción milimétrica de `mindUC - Bienvenida y Autenticación.png` (emblema botánico, píldoras, colores serenos y tagline inferior). |
| **IV. Riverpod, GoRouter y Firebase** | ✅ **PASÓ** | `AuthUiNotifier` en Riverpod, GoRouter con `redirect` guard reactivo, y Firebase Auth para las sesiones. |
| **V. Privacidad y Seguridad por Diseño** | ✅ **PASÓ** | Enmascaramiento de contraseñas, validación en cliente y servidor, sin filtración de credenciales a logs. |
| **VI y VII (Diferidos)** | ⏸️ **DIFERIDO** | Respetados como diferidos. |

---

## Project Structure

### Documentation (this feature)

```text
specs/002-auth-welcome/
├── spec.md              # Especificación funcional aprobada
├── plan.md              # Este plan de implementación técnico
├── research.md          # Investigación de diseño Figma, Riverpod y GoRouter
├── data-model.md        # Modelo AuthUiState y mapeos
├── quickstart.md        # Guía de pruebas automatizadas
└── contracts/
    └── auth_ui_contract.md  # Contrato del controlador de interfaz de autenticación
```

### Source Code Changes

```text
lib/
├── core/
│   └── router/
│       ├── app_router.dart                         # Actualización con ruta /auth y guard de redirección reactiva
│       └── route_names.dart                        # Confirmación de AppRoutes.auth
└── features/
    └── auth/
        ├── presentation/
        │   ├── controllers/
        │   │   ├── auth_controller.dart            # Actualización con AuthUiNotifier y AuthUiState
        │   │   └── auth_ui_state.dart              # Estado reactivo del formulario
        │   ├── screens/
        │   │   └── welcome_auth_screen.dart        # Pantalla oficial de Bienvenida y Autenticación (Figma)
        │   └── widgets/
        │       ├── auth_segmented_switch.dart      # Selector segmentado animado [Iniciar sesión | Registrarse]
        │       └── password_reset_dialog.dart      # Diálogo sereno para recuperación de contraseña

test/
└── widget/
    └── features/
        └── auth/
            └── welcome_auth_screen_test.dart       # Pruebas completas de UI, validaciones y flujos
```

---

## Complexity Tracking

| Decisión Arquitectónica | Justificación | Alternativa Más Simple Descartada |
| :--- | :--- | :--- |
| **Selector segmentado animado en una sola pantalla** | Permite alternar entre login y registro sin cambiar de ruta ni recargar la pantalla, respetando el diseño oficial de Figma. | Dos pantallas separadas (`/login` y `/register`): rompería la experiencia fluida y compacta diseñada en Figma. |
| **Redirección declarativa en GoRouter (`redirect`)** | Protege automáticamente todas las pestañas de bienestar si no hay sesión activa, y evita que un usuario logueado vuelva a ver el login al presionar atrás. | Verificaciones manuales de sesión dentro de cada widget `initState`: dispersaría la seguridad y causaría parpadeos de pantalla. |
