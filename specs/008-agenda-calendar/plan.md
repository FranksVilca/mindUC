# Implementation Plan: 008-agenda-calendar

**Branch**: `008-agenda-calendar` | **Date**: 2026-11-03 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/008-agenda-calendar/spec.md`

## Summary

Implementar la pantalla completa de "Mi Agenda consciente" (`AgendaScreen`) en la Pestaña 2 del Shell de navegación, con fidelidad absoluta al mockup oficial `mindUC - Agenda y Calendario.png`. El módulo incorpora una tira semanal horizontal con cálculo dinámico de días y densidad de tareas, tarjeta de resumen compasivo "Ritmo en equilibrio" (con conteo en tiempo real de actividades totales y completadas), selector de filtros por categoría de bienestar ("Todas", "Autocuidado", "Estudio / Trabajo"), lista reactiva de actividades con marcado interactivo y tachado sutil, botón flotante `+ Nueva` con modal sereno de creación y botón flotante de micrófono para asistencia por voz. Todo implementado bajo Clean Architecture Feature-First, Riverpod y Offline-First.

## Technical Context

**Language/Version**: Dart 3.12+ con Sound Null Safety estricto  
**Primary Dependencies**: Flutter SDK 3.x, `flutter_riverpod: ^2.6.1`, `go_router: ^14.8.1`, `intl: ^0.19.0`  
**Storage**: En memoria y local en dispositivo (`LocalAgendaDataSource`), desacoplado para sincronización en Cloud Firestore bajo Offline-First  
**Testing**: `flutter_test` (pruebas unitarias para controladores y modelos, pruebas de widget para tarjetas, selectores y pantalla completa)  
**Target Platform**: Mobile (Android / iOS) & Desktop  
**Project Type**: Mobile Application (Feature-First Clean Architecture)  
**Performance Goals**: 60 fps en transiciones de lista y selección semanal; conmutación de estado en < 100 ms  
**Constraints**: 0 llamadas de red bloqueantes, 0 desbordamientos gráficos (`RenderFlex overflow`), 100% de cumplimiento con la paleta de colores y tipografía del sistema de diseño  
**Scale/Scope**: 1 pantalla completa de pestaña persistente, 6 widgets especializados, 1 controlador Riverpod, 4 entidades/VOs y ~15 pruebas automatizadas  

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Principio I (Clean Architecture & Feature-First)**: PASA. La estructura separa estrictamente `domain/` (entidades, repositorios puros), `data/` (fuentes de datos y modelos) y `presentation/` (Riverpod notifier, widgets y pantalla).
- **Principio II (Spec-Driven & Test-First)**: PASA. Cada historia de usuario cuenta con escenarios independientes y pruebas unitarias/widget antes de la integración final.
- **Principio III (Fidelidad Visual Absoluta a Figma)**: PASA. Se replican exactamente los márgenes, colores de categoría (menta `#E8F5E9`, lavanda `#EDE7F6`, cálido `#FFF3E0`), formato de fecha, tira semanal con puntos de actividad y botones flotantes gemelos.
- **Principio IV (Riverpod, GoRouter y Persistencia)**: PASA. Se usa `StateNotifier` / `Notifier` con `agendaControllerProvider` y se mantiene integrada en la pestaña 2 de `StatefulShellRoute` (`AppRoutes.agenda`).
- **Principio V (Privacidad por Diseño)**: PASA. Los compromisos y horarios personales operan en modo Offline-First sin exponer datos sensibles a telemetría externa.
- **Principios VI y VII (Diferidos)**: PASA. El botón de micrófono proporciona retroalimentación informativa sin activar modelos pesados de LLM ni requerir permisos nativos invasivos.

## Project Structure

### Documentation (this feature)

```text
specs/008-agenda-calendar/
├── spec.md              # Especificación funcional aprobada
├── checklists/
│   └── requirements.md  # Validación de calidad (16/16 superados)
├── plan.md              # Este plan de implementación
├── research.md          # Investigación técnica y decisiones de diseño
├── data-model.md        # Entidades, Value Objects y estado reactivo
├── quickstart.md        # Guía de pruebas automatizadas y manuales
├── contracts/
│   └── agenda_ui_contract.md # Contratos del controlador y widgets
└── tasks.md             # Tareas atómicas generadas por /speckit-tasks
```

### Source Code (repository root)

```text
lib/features/agenda/
├── domain/
│   ├── entities/
│   │   ├── agenda_activity.dart       # Entidad inmutable de actividad
│   │   ├── agenda_category.dart       # Enum de categorías con estilos
│   │   └── agenda_state.dart          # Modelo de estado reactivo
│   └── repositories/
│       └── agenda_repository.dart     # Interfaz abstracta del repositorio
├── data/
│   ├── datasources/
│   │   └── local_agenda_datasource.dart # Fuente de datos local con mockups de Figma
│   └── repositories/
│       └── local_agenda_repository_impl.dart # Implementación del repositorio
└── presentation/
    ├── controllers/
    │   └── agenda_controller.dart     # Notifier y agendaControllerProvider
    ├── screens/
    │   └── agenda_screen.dart         # Pantalla principal reactiva (Pestaña 2)
    └── widgets/
        ├── agenda_header.dart         # Cabecera serena ("mindUC - Agenda")
        ├── weekly_day_strip.dart      # Selector semanal horizontal (Lun-Dom)
        ├── rhythm_balance_card.dart   # Tarjeta de ritmo ("X actividades · Y completadas")
        ├── category_filter_chips.dart # Chips de filtrado ("Todas", "Autocuidado", etc.)
        ├── activity_card.dart         # Tarjeta interactiva con checkmark y tachado
        └── activity_create_modal.dart # Modal para agendar nueva actividad

test/
├── unit/features/agenda/
│   └── agenda_controller_test.dart    # Pruebas unitarias de lógica y filtrado
└── widget/features/agenda/
    ├── weekly_day_strip_test.dart     # Pruebas del selector de días semanal
    ├── activity_card_test.dart        # Pruebas de conmutación de checkmark y estilos
    ├── activity_create_modal_test.dart# Pruebas de formulario modal
    └── agenda_screen_test.dart        # Pruebas de integración de pantalla completa
```

## Implementation Phases

### Phase 0: Setup & Foundational
- Modelar `AgendaCategory` con sus etiquetas y colores semánticos.
- Crear entidad inmutable `AgendaActivity` con hora formateada AM/PM y tachado visual.
- Crear `AgendaState` con getters de actividades por día, filtradas y resumen de balance.
- Crear interfaz abstracta `AgendaRepository`.
- Implementar `LocalAgendaDataSource` precargando las 4 actividades de Figma para el 24 de Octubre de 2024.
- Implementar `LocalAgendaRepositoryImpl`.
- Desarrollar `AgendaNotifier` y `agendaControllerProvider`.
- Escribir pruebas unitarias en `test/unit/features/agenda/agenda_controller_test.dart`.

### Phase 1: User Story 1 (P1 - MVP) - Visualización de Agenda, Tira Semanal y Filtros
- Implementar `AgendaHeader` con icono de campana y avatar.
- Implementar `WeeklyDayStrip` con cálculo dinámico de 7 días y puntos indicadores de densidad.
- Implementar `RhythmBalanceCard` con icono botánico y resumen de actividades.
- Implementar `CategoryFilterChips` con soporte de selección interactiva.
- Implementar `ActivityCard` mostrando horario, categoría, título, descripción y selector circular.
- Conectar componentes en `AgendaScreen` consumiendo `agendaControllerProvider`.
- Escribir pruebas de widget para `weekly_day_strip_test.dart` y `activity_card_test.dart`.

### Phase 2: User Story 2 (P2) - Marcado Consciente y Actualización de Ritmo
- Conectar el selector circular de `ActivityCard` con `toggleActivityCompletion(id)`.
- Aplicar estilo `TextDecoration.lineThrough` al título cuando `isCompleted == true`.
- Verificar actualización en tiempo real de `RhythmBalanceCard` ("X actividades · Y completadas").

### Phase 3: User Story 3 (P3) - Creación Manual de Actividades
- Implementar `ActivityCreateModal` con campos de título, descripción, hora y categoría.
- Conectar el botón flotante alargado `+ Nueva` con la invocación de `ActivityCreateModal`.
- Persistir la nueva actividad e insertarla en la jornada activa.
- Escribir pruebas de widget para `activity_create_modal_test.dart`.

### Phase 4: User Story 4 (P4) - Navegación Temporal y Acceso Flotante Asistido
- Conectar selección de días en `WeeklyDayStrip` para actualizar `selectedDate` y refrescar actividades.
- Conectar botón flotante de micrófono para disparar diálogo sereno explicativo del agendador de voz.

### Phase 5: Polish & Full Integration
- Verificar `AgendaScreen` dentro del `StatefulShellRoute` en `AppRoutes.agenda`.
- Escribir pruebas de integración en `test/widget/features/agenda/agenda_screen_test.dart`.
- Ejecutar `dart analyze` (0 issues) y `flutter test` (100% éxito).
