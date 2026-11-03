# Implementation Plan: Diario Personal Íntimo (007-personal-journal)

**Branch**: `007-personal-journal` | **Date**: 2026-11-03 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/007-personal-journal/spec.md`

## Summary

Implementar el módulo completo de Diario Personal (`features/personal_journal/`) fiel al mockup oficial de Figma `mindUC - Diario Personal.png`:
1. Espacio sagrado de diario íntimo con banner de privacidad protegida e indicador "🔒 Solo visible en este teléfono", en cumplimiento del **Principio V** de la Constitución (Privacidad por Diseño y Almacenamiento Local Soberano).
2. Selector interactivo de pulso afectivo "¿Cómo late tu corazón hoy?" con 5 opciones ("Agradecida", "En calma", "Reflexiva", "Cansada", "Abrumada") y acento botánico reactivo.
3. Cronología de "Tus huellas interiores" con contador de entradas, insignias emocionales con icono, fecha formateada en español, título, resumen de contenido, tiempo estimado de lectura, y opciones de edición y eliminación.
4. Botón lavanda prominente `+ Nueva entrada reflexiva` y diálogo modal accesible para redactar y editar reflexiones.
5. Cobertura completa de pruebas unitarias y de widgets (`flutter test`) y cero advertencias (`dart analyze`).

---

## Technical Context

**Language/Version**: Dart 3.12.x / Flutter 3.44.x (Sound Null Safety estricto)  
**Primary Dependencies**: `flutter_riverpod: ^2.6.1`, `go_router: ^14.8.1`, `google_fonts: ^6.3.3`  
**Storage**: Almacenamiento local desacoplado en memoria y persistencia local protegida (0 llamadas de red, 0 Firestore)  
**Testing**: `flutter_test` (Pruebas unitarias para controladores y dominio; pruebas de widgets para componentes visuales y pantalla)  
**Target Platform**: Android, iOS, Web  
**Project Type**: Módulo funcional en aplicación móvil Flutter (Clean Architecture Feature-First)  
**Performance Goals**: Carga de reflexiones instantánea (< 50 ms), respuesta visual inmediata al sintonizar pulso emocional  
**Constraints**: 100% Offline-First, confidencialidad absoluta (Principio V: sin telemetría ni sincronización remota no consentida)  
**Scale/Scope**: 1 pantalla completa (`JournalScreen`), 5 widgets modulares de presentación, 1 modal de edición, 1 controlador reactivo (`JournalNotifier`), 2 entidades de dominio y 4 archivos de prueba  

---

## Constitution Check

*GATE: Evaluado y Aprobado conforme a `.specify/memory/constitution.md`*

| Principio Constitucional | Estado | Justificación y Validación |
| :--- | :---: | :--- |
| **I. Clean Architecture Feature-First** | ✅ PASS | Estructura en `lib/features/personal_journal/` desacoplada en `domain/`, `data/` y `presentation/`. |
| **II. Spec-Driven & Test-First** | ✅ PASS | Tareas atómicas vinculadas a especificación y contratos, con suites de tests unitarios y de widgets. |
| **III. Fidelidad Visual Absoluta (Figma)** | ✅ PASS | Réplica exacta de `mindUC - Diario Personal.png`: paleta serena (`MindColors`), tipografías (`Outfit`), radios redondeados y sombras. |
| **IV. Riverpod, GoRouter & Firebase** | ✅ PASS | Control de estado mediante `journalControllerProvider` (`StateNotifier`), conectado a ruta declarativa `AppRoutes.journalNew`. |
| **V. Privacidad por Diseño & Cifrado Local** | ✅ PASS | Almacenamiento 100% local en el dispositivo; prohibición de sincronización remota de pensamientos íntimos sin consentimiento explícito. |
| **VI. [DIFERIDO] Ética IA y Gamificación** | ✅ PASS | Mantiene diferida la gamificación avanzada y modelos LLM. |
| **VII. [DIFERIDO] Bloqueo Nativo del SO** | ✅ PASS | No aplica restricciones externas del sistema operativo. |

---

## Project Structure

### Documentation (this feature)

```text
specs/007-personal-journal/
├── spec.md              # Especificación funcional validada
├── plan.md              # Este plan de implementación
├── research.md          # Decisiones de arquitectura y mitigación técnica
├── data-model.md        # Entidades de dominio y modelo de estado reactivo
├── contracts/
│   └── journal_ui_contract.md  # Contrato de controlador y componentes UI
├── quickstart.md        # Guía de validación automatizada y flujos de usuario
└── checklists/
    └── requirements.md  # Checklist de calidad de especificación
```

### Source Code (repository layout)

```text
lib/
└── features/
    └── personal_journal/
        ├── domain/
        │   ├── entities/
        │   │   ├── journal_entry.dart         # Entidad inmutable de reflexión personal
        │   │   ├── journal_mood_pulse.dart    # Enumeración con los 5 pulsos emocionales
        │   │   └── journal_state.dart         # Value object del estado reactivo del diario
        │   └── repositories/
        │       └── journal_repository.dart    # Interfaz abstracta del repositorio
        ├── data/
        │   ├── datasources/
        │   │   └── local_journal_datasource.dart # Fuente de datos local en memoria/dispositivo
        │   └── repositories/
        │       └── local_journal_repository_impl.dart # Implementación local Offline-First
        └── presentation/
            ├── controllers/
            │   └── journal_controller.dart    # Notifier reactivo con operaciones CRUD locales
            ├── screens/
            │   └── journal_screen.dart        # Pantalla principal "Mi Diario Personal"
            └── widgets/
                ├── journal_header.dart        # Cabecera con logo, título y avatar
                ├── journal_privacy_banner.dart # Insignia "ESPACIO SAGRADO" y banner de cifrado
                ├── emotional_pulse_selector.dart # Selector "¿Cómo late tu corazón hoy?"
                ├── journal_entry_card.dart    # Tarjeta de huella interior con badge y "Solo visible"
                └── journal_entry_edit_modal.dart # Modal para redactar y editar reflexiones

test/
├── unit/
│   └── features/
│       └── personal_journal/
│           └── journal_controller_test.dart   # Pruebas unitarias de CRUD local y pulso emocional
└── widget/
    └── features/
        └── personal_journal/
            ├── emotional_pulse_selector_test.dart # Pruebas del selector de 5 estados
            ├── journal_entry_card_test.dart       # Pruebas de renderizado de tarjeta reflexiva
            └── journal_screen_test.dart           # Pruebas de integración de la pantalla completa
```

---

## Complexity Tracking

*No se detectan desviaciones arquitectónicas ni violaciones constitucionales que requieran justificación excepcional.*
