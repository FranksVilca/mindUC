# Implementation Plan: 003-home-dashboard (Dashboard Principal del Estudiante)

**Branch**: `003-home-dashboard` | **Date**: 2026-11-02 | **Spec**: [specs/003-home-dashboard/spec.md](spec.md)

**Input**: Feature specification from `specs/003-home-dashboard/spec.md`

---

## Summary

Implementar la pantalla principal de Inicio del estudiante (`mindUC - Inicio.png`) con fidelidad absoluta al diseño de Figma, integrando:
1. Cabecera serena con marca `mindUC`, avatar de estudiante y campana de notificaciones.
2. Píldora botánica de fecha actual localizada en español chileno ("Jueves, 24 de Octubre").
3. Saludo empático personalizado con el nombre del estudiante ("¡Hola, Camila! 🌿") y pregunta de conexión interior.
4. Selector interactivo de estado de ánimo en 1 solo toque (5 emociones con colores pastel y micro-feedback).
5. Cuadrícula de 2x2 "Espacios para ti" (Relajación, Agenda, Comunidad, Mi progreso) con radios de 22dp y navegación reactiva GoRouter.
6. Capa de datos Offline-First para el registro de ánimo y consulta de resumen del dashboard en Cloud Firestore.

---

## Technical Context

**Language/Version**: Dart 3.12.2 / Flutter 3.44.4 (Sound Null Safety)  
**Primary Dependencies**: `flutter_riverpod: ^2.6.1`, `go_router: ^14.8.1`, `cloud_firestore: ^5.6.12`, `firebase_auth: ^5.7.0`  
**Storage**: Cloud Firestore con soporte offline-first (`users/{uid}/mood_entries/{date}`) + Fake in-memory datasource para testing desacoplado  
**Testing**: `flutter_test` (Unit tests para UseCases/Notifiers, Widget tests para componentes visuales y HomeScreen)  
**Target Platform**: Android, iOS, Web/Desktop (multiplataforma)  
**Project Type**: Mobile Application  
**Performance Goals**: Renderizado constante a 60 fps, check-in emocional en <2 segundos, carga inicial instantánea  
**Constraints**: 100% fidelidad visual con `mindUC - Inicio.png`, cero desbordamientos en pantalla (zero overflow)  
**Scale/Scope**: Vista central de inicio + 4 subcomponentes atómicos + capa de datos de estado de ánimo  

---

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principio | Estado | Justificación / Cumplimiento |
| :--- | :--- | :--- |
| **I: Arquitectura Limpia** | PASA | Estructura modular `features/home/` separada en `domain/`, `data/`, `presentation/`. |
| **II: SDD & Test-First** | PASA | Especificación completada, pruebas unitarias y de widget diseñadas antes de implementación. |
| **III: Figma como Verdad Visual** | PASA | Coincidencia 100% de tokens de color (`MindColors`), radios (22dp) y tipografía con `mindUC - Inicio.png`. |
| **IV: Riverpod, GoRouter & Firebase** | PASA | Gestión de estado con `homeDashboardControllerProvider`, navegación con `context.go(...)` y persistencia en Firestore. |
| **V: Privacidad por Diseño** | PASA | Entradas de ánimo aisladas en el subdocumento del usuario autenticado; sin analíticas invasivas. |
| **VI: IA y Gamificación Avanzada** | PASA | Se mantiene diferido; la tarjeta de progreso muestra estadísticas y racha simples sin motores complejos de IA. |
| **VII: Bloqueo de Apps SO** | PASA | Diferido explícitamente. |

---

## Project Structure

### Documentation (this feature)

```text
specs/003-home-dashboard/
├── plan.md              # Este plan de implementación
├── research.md          # Resoluciones técnicas y decisiones de diseño
├── data-model.md        # Entidades, modelos y esquema Firestore
├── quickstart.md        # Guía de pruebas automatizadas
├── contracts/
│   └── home_ui_contract.md # Contrato de estado y widgets
└── checklists/
    └── requirements.md  # Validación de calidad de la especificación
```

### Source Code (repository layout)

```text
lib/
├── core/
│   └── utils/
│       └── date_formatter.dart                  # Formateador de fecha localizado ("Jueves, 24 de Octubre")
└── features/
    └── home/
        ├── data/
        │   ├── datasources/
        │   │   ├── fake_mood_datasource.dart     # Mock en memoria para tests y desarrollo offline
        │   │   └── firestore_mood_datasource.dart# Persistencia en Cloud Firestore
        │   ├── models/
        │   │   └── mood_model.dart               # DTO y mapeador de Firestore
        │   └── repositories/
        │       ├── mood_repository_impl.dart     # Implementación concreta de MoodRepository
        │       └── home_dashboard_repository_impl.dart
        ├── domain/
        │   ├── entities/
        │   │   ├── mood_type.dart                # Enum de 5 emociones (Calma, Feliz, Ansiosa, Cansada, Enérgica)
        │   │   ├── mood_entry.dart               # Registro de ánimo diario
        │   │   ├── dashboard_summary.dart        # Resumen consolidado para la vista de inicio
        │   │   └── quick_access_item.dart        # Descriptor de tarjeta de acceso rápido
        │   ├── repositories/
        │   │   ├── mood_repository.dart          # Interfaz abstracta de persistencia de ánimo
        │   │   └── home_dashboard_repository.dart# Interfaz abstracta del dashboard
        │   └── usecases/
        │       ├── get_today_mood_usecase.dart
        │       ├── record_mood_usecase.dart
        │       └── get_home_dashboard_summary_usecase.dart
        └── presentation/
            ├── controllers/
            │   ├── home_dashboard_state.dart     # Estado inmutable de la pantalla de inicio
            │   └── home_dashboard_controller.dart# StateNotifier / AsyncNotifier con Riverpod
            ├── widgets/
            │   ├── home_header.dart              # Logo central, subtítulo Inicio, campana y avatar
            │   ├── date_pill.dart                # Píldora verde menta con calendario y fecha
            │   ├── mood_selector_row.dart        # Fila horizontal de las 5 tarjetas de ánimo
            │   └── quick_access_grid.dart        # Cuadrícula 2x2 ("Espacios para ti")
            └── screens/
                └── home_screen.dart              # Pantalla oficial Home integrada con GoRouter

test/
├── unit/
│   ├── core/
│   │   └── date_formatter_test.dart
│   └── features/
│       └── home/
│           ├── mood_repository_test.dart
│           └── home_dashboard_controller_test.dart
└── widget/
    └── features/
        └── home/
            ├── mood_selector_row_test.dart
            ├── quick_access_grid_test.dart
            └── home_screen_test.dart
```

**Structure Decision**: Clean Architecture Feature-First con separación estricta de responsabilidades en `features/home/`. Los componentes visuales atómicos se extraen a `widgets/` para facilitar su prueba unitaria e independencia.

---

## Complexity Tracking

*No hay violaciones a la constitución que requieran justificación excepcional.*
