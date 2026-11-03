# Feature Specification: 008-agenda-calendar

**Feature Branch**: `008-agenda-calendar`

**Created**: 2026-11-03

**Status**: Draft

**Input**: User description: "008-agenda-calendar"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Visualización de la Agenda Consciente, Tira Semanal y Lista de Tareas (Priority: P1) 🎯 MVP

Como estudiante de la UC,
quiero consultar la vista de "Mi Agenda consciente" con el selector semanal interactivo y el listado de actividades del día organizadas por horarios y categorías,
para tener claridad de mis compromisos académicos y de autocuidado sin experimentar abrumamiento mental.

**Why this priority**: Es la pantalla central de la Pestaña 2 del Shell persistente (`AgendaScreen`), fundamental para organizar el tiempo estudiantil con un enfoque de bienestar compasivo.

**Independent Test**: Cargar la pantalla de Agenda (`AppRoutes.agenda`) y verificar que se renderice la cabecera ("mindUC - Agenda"), el selector semanal con los días Lun a Dom destacando el día activo, la tarjeta de resumen ("Ritmo en equilibrio"), los chips de filtro ("Todas", "Autocuidado", "Estudio / Trabajo") y las 4 tarjetas de actividades iniciales de Figma con sus horarios y categorías correspondientes.

**Acceptance Scenarios**:

1. **Given** un estudiante que navega a la pestaña de Agenda,
   **When** se inicializa la pantalla,
   **Then** visualiza el título "Mi Agenda consciente", la fecha formateada en español (ej. "Jueves, Octubre 2024 • Semana 43"), la tira semanal con el día actual seleccionado y la lista de actividades planificadas.
2. **Given** la lista de actividades del día con diversas categorías,
   **When** el estudiante pulsa el chip "Autocuidado",
   **Then** la lista filtra instantáneamente para mostrar solo las actividades clasificadas bajo esa categoría, actualizando la vista sin recargar la pantalla.
3. **Given** la lista filtrada,
   **When** el estudiante pulsa el chip "Todas",
   **Then** la lista vuelve a desplegar la totalidad de las actividades del día seleccionado.

---

### User Story 2 - Marcado Consciente de Actividades y Actualización de "Ritmo en equilibrio" (Priority: P2)

Como estudiante,
quiero marcar una actividad como completada o desmarcarla como pendiente tocando su selector circular,
para registrar mi progreso diario de forma amable y observar la actualización inmediata del contador de "Ritmo en equilibrio".

**Why this priority**: La sensación de logro amable y seguimiento del ritmo diario es esencial para la autorregulación emocional y el bienestar del estudiante.

**Independent Test**: Tocar el selector circular de una actividad pendiente y verificar que su icono cambie a completado con checkmark (`✓`), su título se muestre con estilo tachado suave (strikethrough) y la tarjeta "Ritmo en equilibrio" incremente en tiempo real el número de actividades completadas (ej. de "2 completadas" a "3 completadas").

**Acceptance Scenarios**:

1. **Given** una actividad pendiente como "Caminata al aire libre sin pantallas",
   **When** el estudiante pulsa sobre su círculo de verificación,
   **Then** la actividad pasa al estado completada, el círculo se llena con acento verde menta y checkmark blanco, el título adopta un tachado sutil y el contador de "Ritmo en equilibrio" se actualiza a "3 completadas".
2. **Given** una actividad previamente completada como "Meditación matutina y respiración",
   **When** el estudiante pulsa nuevamente su selector,
   **Then** la actividad retorna al estado pendiente, removiendo el tachado y reduciendo el conteo de completadas en la tarjeta de ritmo.

---

### User Story 3 - Creación y Edición Manual de Actividades Conscientes (Priority: P3)

Como estudiante,
quiero presionar el botón flotante `+ Nueva` para registrar una nueva actividad con título, descripción, horario y categoría,
para organizar mis propios hábitos de estudio o pausas conscientes directamente en mi agenda.

**Why this priority**: Permite al estudiante personalizar su planificación diaria añadiendo compromisos reales del semestre o pausas de relajación.

**Independent Test**: Tocar el botón `+ Nueva`, completar los campos de la hoja modal (título, descripción, hora, categoría) y confirmar; verificar que la nueva actividad aparezca en la lista del día seleccionado y el contador de actividades aumente (ej. de 4 a 5 actividades).

**Acceptance Scenarios**:

1. **Given** la pantalla de Agenda,
   **When** el estudiante pulsa el botón `+ Nueva`,
   **Then** se abre un diálogo modal sereno que solicita título, descripción opcional, hora de la actividad y selección de categoría ("Autocuidado", "Estudio / Trabajo", "Salud mental").
2. **Given** el formulario modal completado con datos válidos,
   **When** el estudiante presiona "Guardar actividad",
   **Then** la actividad se almacena, el modal se cierra y la nueva tarjeta se inserta en el orden cronológico correspondiente.
3. **Given** el formulario modal con título vacío,
   **When** el estudiante intenta guardar,
   **Then** se muestra una advertencia compasiva sin perder la información ingresada.

---

### User Story 4 - Navegación Temporal y Acceso Rápido Asistido (Priority: P4)

Como estudiante,
quiero cambiar de día pulsando cualquier día en la tira semanal o pulsar el botón de micrófono para activar el agendador por voz,
para planificar con fluidez diferentes días de la semana y acceder a herramientas de asistencia rápida.

**Why this priority**: Facilita la movilidad semanal y prepara la integración modular con el futuro agendador de voz de la Fase 3.

**Independent Test**: Tocar un día diferente en la tira semanal (ej. "Vie 25") y verificar que se resalte como activo y muestre las actividades de esa fecha; pulsar el botón de micrófono y verificar la respuesta visual o diálogo informativo del agendador de voz.

**Acceptance Scenarios**:

1. **Given** la tira semanal con "Jue 24" activo,
   **When** el estudiante pulsa el chip "Vie 25",
   **Then** el selector visual se traslada al día 25 y la lista de actividades se actualiza a las correspondientes a ese día.
2. **Given** la pantalla de Agenda,
   **When** el estudiante pulsa el botón flotante de micrófono,
   **Then** se dispara la acción de asistencia por voz o diálogo informativo del agendador consciente según el diseño.

---

### Edge Cases

- **Día sin actividades registradas**: Si el estudiante selecciona un día de la semana sin tareas, se muestra un estado sereno y no punitivo indicando *"Día despejado para descansar o fluir a tu propio ritmo 🌿"* junto al botón para añadir una nueva actividad.
- **Cambio de semana o límite de mes**: La tira semanal maneja transiciones limpias de fin de mes respetando el cálculo de número de semana y días calendario reales.
- **Persistencia sin conexión**: Todas las operaciones de consulta, marcado y creación funcionan fluidamente sin conexión a internet (Offline-First).
- **Textos largos de actividad**: Los títulos y descripciones de las actividades manejan `TextOverflow.ellipsis` o expansión equilibrada sin generar desbordamientos de píxeles (`RenderFlex overflow`).

---

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: El sistema DEBE proveer la pantalla `AgendaScreen` como destino principal de la Pestaña 2 del Shell de navegación (`AppRoutes.agenda`).
- **FR-002**: El sistema DEBE mostrar una cabecera con el logo `mindUC`, el subtítulo `Agenda`, icono de campana de notificaciones y avatar de estudiante.
- **FR-003**: El sistema DEBE mostrar la sección de fecha dinámica con el día, mes, año y el número de semana del año (ej. "Jueves, Octubre 2024 • Semana 43").
- **FR-004**: El sistema DEBE presentar un selector semanal horizontal con 7 días (Lunes a Domingo), mostrando la abreviatura del día, el número, puntos indicadores de densidad de tareas y resaltando el día actualmente seleccionado.
- **FR-005**: El sistema DEBE incluir una tarjeta de resumen "Ritmo en equilibrio" que visualice un icono circular botánico, el recuento total de actividades y completadas del día (ej. "4 actividades · 2 completadas") y un enlace al "Historial >".
- **FR-006**: El sistema DEBE ofrecer una fila de filtros por categoría ("Todas", "Autocuidado", "Estudio / Trabajo", "Salud mental"), permitiendo filtrar la lista de actividades en un solo toque.
- **FR-007**: El sistema DEBE desplegar tarjetas de actividad con: selector circular de estado (pendiente/completado), hora formateada (AM/PM), píldora de categoría con color distintivo, título (con estilo tachado si está completada) y descripción.
- **FR-008**: El sistema DEBE permitir conmutar el estado de completitud de cualquier actividad al tocar su selector circular, recalculando de forma reactiva el contador de "Ritmo en equilibrio".
- **FR-009**: El sistema DEBE incluir un botón flotante alargado `+ Nueva` que abra un modal sereno para ingresar título, descripción, categoría y horario de una nueva actividad.
- **FR-010**: El sistema DEBE incluir un botón flotante circular con icono de micrófono para disparar el flujo de agendamiento guiado por voz.
- **FR-011**: El sistema DEBE persistir las actividades y su estado de completitud localmente en el repositorio de agenda bajo arquitectura limpia y Offline-First.

### Key Entities *(include if feature involves data)*

- **AgendaActivity**: Entidad que representa un compromiso, sesión de estudio o práctica de bienestar en la agenda. Atributos: `id`, `title`, `description`, `scheduledTime` (DateTime), `category` (AgendaCategory), `isCompleted` (bool), `createdAt` (DateTime).
- **AgendaCategory**: Enumeración de categorías de balance consciente. Valores: `autocuidado`, `estudioTrabajo`, `saludMental`. Incluye etiqueta en español, color semántico asociado y color de fondo suave.
- **DaySchedule**: Value Object que agrupa las actividades de un día específico, calculando el total de actividades, completadas y porcentaje de equilibrio.
- **AgendaState**: Estado inmutable para Riverpod que contiene la fecha seleccionada, la categoría de filtro activa, la lista de actividades filtradas, el conteo de completadas y el estado de carga.

---

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: El 100% de los elementos visuales del mockup `mindUC - Agenda y Calendario.png` están representados con exactitud milimétrica (cabecera, selector semanal, tarjeta de ritmo, filtros, tarjetas de tarea y botones flotantes).
- **SC-002**: La conmutación de estado completada/pendiente y el filtrado por categorías responden en menos de 100 ms sin bloqueos de la interfaz.
- **SC-003**: La pantalla cuenta con una cobertura de pruebas exhaustiva (pruebas unitarias para el controlador/repositorio y pruebas de widget para componentes de agenda y pantalla completa).
- **SC-004**: `dart analyze` reporta 0 issues y 0 advertencias, y la suite completa de pruebas del proyecto (`flutter test`) mantiene el 100% de éxito.

---

## Assumptions

- Se precargan inicialmente las 4 actividades de ejemplo reflejadas en el mockup de Figma para garantizar una experiencia visual inmediata y coherente con el diseño.
- El botón de micrófono proporciona una respuesta visual armoniosa (diálogo o notificación serena) anticipando el módulo de agendamiento semántico por voz de etapas posteriores sin bloquear la experiencia de usuario.
- La persistencia de datos opera de manera autónoma en el dispositivo mediante Clean Architecture, compatible con sincronización de Cloud Firestore.
