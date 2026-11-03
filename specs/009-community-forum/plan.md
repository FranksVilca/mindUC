# Implementation Plan: 009-community-forum

**Branch**: `009-community-forum` | **Date**: 2026-11-03 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `specs/009-community-forum/spec.md`

## Summary

Implementar la pantalla completa de "Comunidad UC Consciente" (`CommunityScreen`) en la ruta `AppRoutes.community` (`/community`), con fidelidad absoluta al mockup oficial `mindUC - Comunidad.png`. El módulo incorpora un banner de espacio seguro con aviso de identidad protegida y moderación empática, botón de acción "+ Compartir reflexión anónima", selector horizontal de filtros por sentir ("Todo", "Estrés académico", "Desahogo y calma", etc.), cronología reactiva de hilos con alias efímeros ficticios (`@BúhoCurioso`, `@BroteCalmo`, `@LluviaSuave`), tarjetas incrustadas enriquecidas (insight de pausas respiratorias, botón "Probar" para la Guía 4–7–8 enlazado a la sesión de respiración, respuesta más apoyada), barra interactiva de reacciones conscientes (`🤍❤️`, `🌿`, `💡`, `🫂`, `💬`), y modal de creación de reflexiones anónimas sin exposición de datos personales, cumpliendo estrictamente con el Principio V de la Constitución.

## Technical Context

**Language/Version**: Dart 3.12+ con Sound Null Safety estricto  
**Primary Dependencies**: Flutter SDK 3.x, `flutter_riverpod: ^2.6.1`, `go_router: ^14.8.1`  
**Storage**: En memoria y local en dispositivo (`LocalCommunityDataSource`), desacoplado para sincronización en Cloud Firestore bajo Offline-First  
**Testing**: `flutter_test` (pruebas unitarias para controladores y modelos, pruebas de widget para tarjetas, modales y pantalla completa)  
**Target Platform**: Mobile (Android / iOS) & Desktop  
**Project Type**: Mobile Application (Feature-First Clean Architecture)  
**Performance Goals**: 60 fps en desplazamiento de lista; conmutación de reacciones y filtrado en < 100 ms  
**Constraints**: Cero fuga de correos institucionales o identificadores reales del estudiante (Principio V), 0 desbordamientos gráficos (`RenderFlex overflow`)  
**Scale/Scope**: 1 pantalla completa accesible desde Inicio, 5 widgets especializados, 1 controlador Riverpod, 5 entidades/VOs y ~15 pruebas automatizadas  

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Principio I (Clean Architecture & Feature-First)**: PASA. Se estructura estrictamente en `lib/features/community_forum/` (`domain/`, `data/`, `presentation/`).
- **Principio II (Spec-Driven & Test-First)**: PASA. Pruebas unitarias de controlador y pruebas de widget previas a la composición final de la pantalla.
- **Principio III (Fidelidad Visual Absoluta a Figma)**: PASA. Replicación exacta de márgenes, colores (fondos salvia `#E5EFE6`, chips de sentir, avatares temáticos) y tipografía de `mindUC - Comunidad.png`.
- **Principio IV (Riverpod, GoRouter y Persistencia)**: PASA. Se usa `StateNotifier` con `communityControllerProvider` y se reemplaza el Scaffold provisional en `AppRoutes.community`.
- **Principio V (Privacidad por Diseño y Soberanía del Usuario)**: PASA. Separación lógica y de datos total entre el usuario autenticado y los alias efímeros generados. Ninguna publicación contiene el correo del autor.
- **Principios VI y VII (Diferidos)**: PASA. La moderación y generación de alias se resuelven mediante reglas deterministas locales y semánticas sin invocar LLMs pesados.

## Project Structure

### Documentation (this feature)

```text
specs/009-community-forum/
├── spec.md              # Especificación funcional aprobada
├── checklists/
│   └── requirements.md  # Validación de calidad (16/16 superados)
├── plan.md              # Este plan de implementación
├── research.md          # Investigación técnica y decisiones de diseño
├── data-model.md        # Entidades, Value Objects y estado reactivo
├── quickstart.md        # Guía de pruebas automatizadas y manuales
├── contracts/
│   └── community_ui_contract.md # Contratos del controlador y widgets
└── tasks.md             # Tareas atómicas generadas por /speckit-tasks
```

### Source Code (repository root)

```text
lib/features/community_forum/
├── domain/
│   ├── entities/
│   │   ├── community_avatar.dart      # Enum de avatares ficticios
│   │   ├── community_mood_category.dart # Enum de categorías de sentir
│   │   ├── embedded_card_data.dart    # Value Object de tarjetas incrustadas
│   │   ├── community_post.dart        # Entidad inmutable de publicación comunitaria
│   │   └── community_state.dart       # Estado reactivo para Riverpod
│   └── repositories/
│       └── community_repository.dart  # Interfaz abstracta del repositorio
├── data/
│   ├── datasources/
│   │   └── local_community_datasource.dart # Fuente de datos local con hilos de Figma
│   └── repositories/
│       └── local_community_repository_impl.dart # Implementación del repositorio
└── presentation/
    ├── controllers/
    │   └── community_controller.dart  # Notifier y communityControllerProvider
    ├── screens/
    │   └── community_screen.dart      # Pantalla principal (AppRoutes.community)
    └── widgets/
        ├── community_header.dart      # Cabecera serena ("mindUC — Comunidad")
        ├── community_banner_card.dart # Banner "Comunidad UC Consciente" (Espacio Seguro)
        ├── mood_filter_chips.dart     # Chips de filtro por sentir y contador de hilos
        ├── community_post_card.dart   # Tarjeta de publicación con reacciones
        └── community_post_create_modal.dart # Modal para compartir reflexión anónima

test/
├── unit/features/community_forum/
│   └── community_controller_test.dart # Pruebas unitarias de controlador y reacciones
└── widget/features/community_forum/
    ├── community_post_card_test.dart  # Pruebas de renderizado de tarjeta y reacciones
    ├── community_post_create_modal_test.dart # Pruebas de modal de publicación anónima
    └── community_screen_test.dart     # Pruebas de integración de pantalla completa
```

## Implementation Phases

### Phase 1: Setup & Foundational
- Modelar `CommunityAvatar`, `CommunityMoodCategory`, `EmbeddedCardData` y `CommunityPost`.
- Modelar `CommunityState` con filtrado reactivo.
- Crear interfaz abstracta `CommunityRepository`.
- Implementar `LocalCommunityDataSource` precargando los 3 hilos oficiales de Figma (`@BúhoCurioso`, `@BroteCalmo`, `@LluviaSuave`).
- Implementar `LocalCommunityRepositoryImpl`.
- Desarrollar `CommunityNotifier` y `communityControllerProvider`.
- Escribir pruebas unitarias en `community_controller_test.dart`.

### Phase 2: User Story 1 (P1 - MVP) - Espacio Seguro, Filtros y Cronología
- Implementar `CommunityHeader` con navegación de retorno y avatar.
- Implementar `CommunityBannerCard` con distintivos "ESPACIO SEGURO UC", "• Moderado con empatía" y nota de identidad protegida.
- Implementar `MoodFilterChips` con opciones "Todo", "Estrés académico", etc. y contador de hilos activos.
- Implementar `CommunityPostCard` con avatar, alias, facultad, chips temáticos, texto y tarjetas incrustadas.
- Integrar la pantalla `CommunityScreen` en `lib/features/community_forum/presentation/screens/community_screen.dart`.
- Conectar en `AppRoutes.community` en `lib/core/router/app_router.dart`.
- Escribir pruebas de widget para `community_post_card_test.dart`.

### Phase 3: User Story 2 (P2) - Reacciones Conscientes Interactivas
- Conectar botones de reacción (`🤍❤️`, `🌿`, `💡`, `🫂`) a `notifier.toggleReaction(postId, reactionKey)`.
- Manejar alternancia inmediata y estados activos visuales sin latencia.

### Phase 4: User Story 3 (P3) - Publicación Anónima con Alias Efímero
- Implementar `CommunityPostCreateModal` con generador aleatorio de alias, selector de facultad y etiquetas de sentir.
- Conectar el botón "+ Compartir reflexión anónima" para abrir el modal y publicar el nuevo hilo.
- Escribir pruebas de widget para `community_post_create_modal_test.dart`.

### Phase 5: User Story 4 (P4) - Tarjetas Enriquecidas y Moderación Compasiva
- Enlazar el botón "Probar" de la Guía 4–7–8 a `AppRoutes.breathingSession`.
- Añadir el menú de opciones compasivas (`⋮`) con opción de reporte y guardado.

### Phase 6: Polish & Full Integration
- Escribir pruebas de integración en `community_screen_test.dart`.
- Ejecutar `dart analyze` y `flutter test` asegurando 100% de éxito.
