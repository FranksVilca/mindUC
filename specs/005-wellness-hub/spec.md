# Feature Specification: 005-wellness-hub

**Feature Branch**: `005-wellness-hub`  
**Created**: 2026-11-02  
**Status**: Draft  
**Input**: User description: "005-wellness-hub: Hub principal de Bienestar con accesos a respiración, pomodoro, diario y hábitos de autocuidado"  
**Mockup Reference**: [`docs/mockups/mindUC - Bienestar.png`](../../docs/mockups/mindUC%20-%20Bienestar.png)  

---

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Navegación al Espacio de Bienestar y Tarjeta de Ejercicio Sugerido (Priority: P1) 🎯 MVP

Como estudiante universitario agobiado por el estudio continuo,  
quiero acceder a la pestaña de Bienestar en cualquier momento y recibir una sugerencia personalizada de ejercicio rápido (ej. Respiración 4-7-8 por 5 minutos) con un solo toque para iniciar,  
para recuperar mi centro de calma sin perder tiempo configurando opciones complejas.

**Why this priority**: Constituye la experiencia central del segundo tab del shell (`AppRoutes.wellness`). Proporciona una intervención de bienestar inmediata (1 solo toque) que reduce la fricción cognitiva del estudiante.

**Independent Test**: Puede probarse de forma independiente navegando a la pestaña "Bienestar" en la barra inferior, verificando que se renderiza la cabecera, la píldora "SANCTUARY MODE", el saludo inspirador, y la tarjeta destacada "EJERCICIO SUGERIDO PARA TI HOY" con su botón "Comenzar (5 min)", el cual navega a la sesión de respiración configurada.

**Acceptance Scenarios**:
1. **Given** el estudiante en la aplicación con la barra de navegación persistente, **When** pulsa la pestaña "Bienestar", **Then** la vista muestra la cabecera centrada ("mindUC / Bienestar"), la campana con indicador, el avatar del usuario, la píldora botánica `🌱 SANCTUARY MODE` y el título `Tu espacio de bienestar ✨`.
2. **Given** la tarjeta de ejercicio sugerido visible, **When** el estudiante visualiza su contenido, **Then** observa el subtítulo de categoría `EJERCICIO SUGERIDO PARA TI HOY`, el título `Respiración 4–7–8`, la descripción `Técnica antiestrés recomendada para despejar la sobrecarga`, el icono de aire en círculo menta, la etiqueta `🟢 Ciclo guiado` y el botón de cápsula verde oscuro `▶ Comenzar (5 min)`.
3. **Given** la tarjeta destacada, **When** el estudiante pulsa `▶ Comenzar (5 min)`, **Then** la app navega a la sesión de respiración (`/breathing-session`) precargando la técnica `Respiración 4-7-8 (Relajante)` y la duración de 300 segundos (5 min).

---

### User Story 2 - Cuadrícula de Accesos Rápidos de Bienestar (Priority: P1)

Como estudiante que desea elegir una práctica de bienestar específica,  
quiero una cuadrícula visualmente armónica con tarjetas temáticas de herramientas (Respiración, Diario personal, Asistente IA, Concentración) identificadas con insignias temporales o de privacidad,  
para elegir el autocuidado que mejor responde a mi necesidad del momento.

**Why this priority**: Organiza todas las modalidades de bienestar de mindUC en un espacio centralizado y coherente, reflejando el sistema de diseño botánico de Figma.

**Independent Test**: Puede probarse de forma independiente verificando que la cuadrícula 2x2 renderiza las 4 tarjetas con sus respectivos colores pastel, insignias en la esquina superior derecha (`3 min`, `Privado`, `24/7`, `25m`), títulos, descripciones y manejadores de pulsación.

**Acceptance Scenarios**:
1. **Given** la cuadrícula de bienestar, **When** se renderiza en pantalla, **Then** muestra exactamente 4 tarjetas con disposición 2x2:
   - **Respiración**: Fondo verde menta suave (`MindColors.autocuidado`), insignia `3 min`, icono de brisa, título "Respiración" y descripción "Guía rítmica para calmar mente y...".
   - **Diario personal**: Fondo lavanda suave (`MindColors.estudioTrabajo`), insignia `Privado`, icono de libreta, título "Diario personal" y descripción "Expresa tus pensamientos sin...".
   - **Asistente IA ✨**: Fondo celeste suave (`MindColors.descanso`), insignia `24/7`, icono de robot compasivo, título "Asistente IA ✨" y descripción "Acompañamiento y escucha compasiva.".
   - **Concentración**: Fondo coral suave (`MindColors.saludMental`), insignia `25m`, icono de temporizador, título "Concentración" y descripción "Bloques con sonidos de la naturaleza.".
2. **Given** la tarjeta "Respiración", **When** el estudiante la toca, **Then** el sistema navega a la sesión de respiración consciente (`/breathing-session`).
3. **Given** la tarjeta "Concentración", **When** el estudiante la toca, **Then** el sistema navega a la ruta de Pomodoro (`/pomodoro-session`) o pantalla de concentración.
4. **Given** la tarjeta "Diario personal", **When** el estudiante la toca, **Then** el sistema navega al diario íntimo (`/journal/new`).
5. **Given** la tarjeta "Asistente IA ✨", **When** el estudiante la toca, **Then** en cumplimiento del Principio VI (IA diferida), la app despliega un diálogo sereno informando que el Asistente Compasivo está en fase de preparación segura para la comunidad UC.

---

### User Story 3 - Integración con Shell y Estado de Navegación Persistente (Priority: P2)

Como estudiante que navega cotidianamente entre sus clases y sus pausas de autocuidado,  
quiero que la pestaña Bienestar conserve su posición de desplazamiento y estado al alternar entre Inicio, Bienestar, Agenda y Perfil,  
para tener una experiencia de uso fluida sin recargas innecesarias ni pérdida de contexto.

**Why this priority**: Asegura la integración consistente con la arquitectura `StatefulShellRoute` de GoRouter y el Principio IV de la Constitución.

**Independent Test**: Navegar de Inicio a Bienestar, hacer scroll, cambiar a Agenda y volver a Bienestar; el scroll y el estado deben persistir sin parpadeos.

**Acceptance Scenarios**:
1. **Given** el estudiante en la pestaña Bienestar, **When** pulsa la pestaña "Inicio" u otra del menú inferior, **Then** cambia de pantalla instantáneamente sin destruir la instancia de Bienestar.
2. **Given** que el usuario regresa a la pestaña "Bienestar", **When** la pantalla se muestra, **Then** el icono de "Bienestar" en la barra inferior permanece destacado con su círculo verde salvia y su etiqueta activa.

---

### Edge Cases

- **Usuario pulsa el botón Comenzar (5 min) con una sesión previa interrumpida**: El sistema reconfigura el temporizador a 5 minutos y técnica 4-7-8, ofreciendo comenzar fresca la pausa sugerida.
- **Dispositivos con pantallas pequeñas (ancho < 360 dp)**: La cuadrícula 2x2 debe mantener espaciados responsivos y permitir scroll vertical sin desbordes de píxeles (`RenderFlex overflow`).
- **Modo sin conexión a internet**: Toda la pantalla de Bienestar y el ejercicio sugerido deben operar 100% de manera offline sin requerir conexión a la red.
- **Pulsación sobre módulos no completados (Asistente IA)**: Despliega modal informativo sereno sin bloquear ni generar errores de navegación.

---

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: El sistema DEBE renderizar en la pestaña Bienestar la cabecera superior con el texto "mindUC" en negrita y "Bienestar" en gris medio, la campana de notificaciones con punto de aviso y el avatar circular del estudiante.
- **FR-002**: El sistema DEBE mostrar la insignia serena `🌱 SANCTUARY MODE` con fondo verde menta suave y bordes redondeados.
- **FR-003**: El sistema DEBE presentar el título principal `Tu espacio de bienestar ✨` y el texto de acompañamiento: `Tómate una pausa consciente. Cada pequeño respiro renueva tu energía interior.`.
- **FR-004**: El sistema DEBE desplegar la tarjeta destacada de ejercicio sugerido con:
  - Etiqueta superior en mayúsculas `EJERCICIO SUGERIDO PARA TI HOY`.
  - Título `Respiración 4–7–8`.
  - Subtítulo `Técnica antiestrés recomendada para despejar la sobrecarga`.
  - Icono ilustrativo de brisa en contenedor circular.
  - Indicador de estado `🟢 Ciclo guiado`.
  - Botón interactivo de cápsula verde oscuro `▶ Comenzar (5 min)`.
- **FR-005**: Al pulsar el botón `▶ Comenzar (5 min)` de la tarjeta sugerida, el sistema DEBE navegar a `/breathing-session` preconfigurando la técnica en `relaxing_478` y la duración en 300 segundos.
- **FR-006**: El sistema DEBE presentar una cuadrícula de 2 columnas por 2 filas con las siguientes herramientas de autocuidado:
  - **Tarjeta 1 (Respiración)**: Fondo `MindColors.autocuidado`, insignia `3 min`, navegación a `/breathing-session`.
  - **Tarjeta 2 (Diario personal)**: Fondo `MindColors.estudioTrabajo`, insignia `Privado`, navegación a `/journal/new`.
  - **Tarjeta 3 (Asistente IA ✨)**: Fondo `MindColors.descanso`, insignia `24/7`, despliegue de diálogo informativo compasivo (Principio VI).
  - **Tarjeta 4 (Concentración)**: Fondo `MindColors.saludMental`, insignia `25m`, navegación a `/pomodoro-session`.
- **FR-007**: La pantalla DEBE implementarse como una vista responsiva con soporte de desplazamiento suave (`SingleChildScrollView`) que evite cualquier desbordamiento de pantalla en cualquier factor de forma móvil.
- **FR-008**: La pantalla DEBE estar integrada como la rama 1 (`index 1`) del `StatefulShellRoute` en `app_router.dart`, reemplazando el placeholder previo de `WellnessScreen`.

---

### Key Entities *(include if feature involves data)*

- **WellnessSuggestedExercise**: Representa el ejercicio destacado del día. Atributos: `id`, `categoryTitle`, `title`, `description`, `techniqueId`, `durationSeconds`, `badgeLabel`.
- **WellnessToolItem**: Representa cada herramienta de la cuadrícula 2x2. Atributos: `id`, `title`, `subtitle`, `badgeText`, `iconData`, `backgroundColor`, `targetRoute`.

---

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: El estudiante puede acceder a su ejercicio sugerido e iniciar la sesión de respiración con un solo toque en menos de 2 segundos.
- **SC-002**: Coincidencia visual de 100% con los elementos, colores y tipografía del mockup oficial `mindUC - Bienestar.png`.
- **SC-003**: 0 desbordes visuales (`overflows`) en pruebas de widget simuladas en resoluciones estándar (360x640 hasta 412x915 dp).
- **SC-004**: Tiempos de renderizado inicial de la pestaña de Bienestar inferiores a 100 ms sin bloqueos del hilo principal de UI.
- **SC-005**: 100% de pruebas unitarias y de widgets aprobadas sin advertencias en `dart analyze`.

---

## Assumptions

- Se reutiliza la sesión de respiración implementada en `004-breathing-relaxation` (`AppRoutes.breathingSession`), permitiendo inicializarla con parámetros de técnica (`relaxing_478`) y duración (`300s`).
- El Asistente IA permanece diferido según el Principio VI de la Constitución de mindUC; la tarjeta correspondiente proporciona feedback compasivo informativo sin simular llamadas de red ni dependencias externas.
- El módulo Pomodoro y Diario personal contarán con rutas registradas o modales de destino que no rompan la navegación si aún están en fase de construcción.

