# Feature Specification: Diario Personal Íntimo & Registro Emocional (007-personal-journal)

**Feature Branch**: `007-personal-journal`

**Created**: 2026-11-03

**Status**: Draft

**Input**: User description: "007-personal-journal: Espacio sagrado de diario íntimo con cifrado local por diseño (Principio V), selector de pulso emocional ('¿Cómo late tu corazón hoy?'), creación de entradas reflexivas, y cronología de huellas interiores ('Tus huellas interiores')."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Cronología de Huellas Interiores y Visualización Segura (Priority: P1) 🎯 MVP

Como estudiante que experimenta altas cargas académicas y emocionales, quiero ingresar a "Mi Diario Personal" y revisar la cronología de mis reflexiones previas ("Tus huellas interiores") con su insignia emocional, fecha, título, extracto y garantía visual de privacidad, para reconectar con mis aprendizajes personales en un espacio de absoluta confidencialidad y calma.

**Why this priority**: Es el núcleo de lectura y contención del diario. Sin la visualización clara y serena de las huellas interiores acumuladas, el estudiante no percibe el valor de continuidad ni la seguridad de su espacio reflexivo.

**Independent Test**: Puede validarse completamente desplegando la pantalla del diario, verificando el banner de privacidad protegida, la lista cronológica de tarjetas reflexivas (con insignias como `🌸 En calma`, `✨ Agradecida`, `🌿 Reflexiva`), fecha y hora, extracto de texto, el indicador "🔒 Solo visible en este teléfono" y el contador de entradas en la cabecera ("3 entradas").

**Acceptance Scenarios**:

1. **Given** que el usuario ingresa a la pantalla de Diario Personal, **When** observa la cabecera, **Then** visualiza la insignia "ESPACIO SAGRADO", el título "Mi Diario Personal", y el banner de seguridad "🔒 Un espacio solo para ti. Tus pensamientos están protegidos y cifrados en tu dispositivo 🔒".
2. **Given** que existen entradas registradas en el dispositivo, **When** el usuario visualiza la sección "Tus huellas interiores", **Then** se exhibe la lista ordenada de reflexiones con badge de emoción correspondiente, fecha formateada en español (ej. "Hoy, 24 Octubre · 21:15"), título reflexivo, resumen del texto y tiempo estimado de lectura (ej. "2 min de lectura").
3. **Given** que no existen entradas previas registradas, **When** el usuario accede a la sección, **Then** se muestra un estado sereno de bienvenida que invita compasivamente a plasmar la primera reflexión sin mensajes de error ni vacíos abruptos.

---

### User Story 2 - Selector de Pulso Emocional ("¿Cómo late tu corazón hoy?") (Priority: P2)

Como estudiante que desea tomar conciencia de su estado afectivo antes de escribir, quiero sintonizar en un toque cómo late mi corazón mediante 5 opciones de pulso emocional ("Agradecida", "En calma", "Reflexiva", "Cansada", "Abrumada"), para reconocer mis emociones sin juicio y categorizar mis reflexiones.

**Why this priority**: El chequeo emocional rápido reduce la barrera de entrada a la escritura reflexiva, permitiendo al estudiante plasmar su estado anímico incluso cuando dispone de poco tiempo.

**Independent Test**: Puede validarse tocando cualquiera de los 5 estados emocionales en la tarjeta "¿Cómo late tu corazón hoy?", verificando que la opción seleccionada (ej. "En calma") se resalta con fondo verde suave y acento botánico, y actualiza el pulso emocional activo de la sesión.

**Acceptance Scenarios**:

1. **Given** la tarjeta "¿Cómo late tu corazón hoy?" con el subtítulo "Sintoniza tu sentir", **When** el usuario la observa, **Then** visualiza 5 opciones horizontales: "Agradecida" (estrellas), "En calma" (flor), "Reflexiva" (brote/planta), "Cansada" (nube) y "Abrumada" (ola marina).
2. **Given** que "En calma" se encuentra seleccionado por defecto, **When** el usuario pulsa sobre "Agradecida", **Then** el selector conmuta inmediatamente resaltando la nueva emoción activa y deseleccionando la anterior.

---

### User Story 3 - Creación y Edición de Entradas Reflexivas (Priority: P3)

Como estudiante que desea vaciar sus pensamientos o procesar un día complejo, quiero presionar "+ Nueva entrada reflexiva" o tocar el icono de edición (lápiz) de una tarjeta previa para redactar o modificar una reflexión con título, texto libre y emoción asociada, guardándola de forma segura e instantánea.

**Why this priority**: Permite la interacción de escritura activa y edición, completando el ciclo reflexivo del estudiante.

**Independent Test**: Puede validarse pulsando el botón "+ Nueva entrada reflexiva", completando el formulario modal con título y cuerpo reflexivo, presionando "Guardar reflexión", y comprobando que la nueva entrada se incorpora de inmediato a la cima de la cronología de "Tus huellas interiores".

**Acceptance Scenarios**:

1. **Given** la pantalla del Diario Personal, **When** el usuario pulsa el botón lavanda "+ Nueva entrada reflexiva", **Then** se despliega una vista o diálogo modal de creación con selector de pulso emocional, campo para título de reflexión y área de texto expandible para pensamientos libres.
2. **Given** el formulario de creación completado con título y contenido, **When** el usuario presiona "Guardar reflexión", **Then** la entrada se persiste localmente y aparece reflejada de inmediato en la lista de huellas interiores.
3. **Given** una entrada reflexiva existente, **When** el usuario toca el icono de lápiz en su tarjeta, **Then** se abre el formulario precargado con sus datos actuales, permitiendo editar el texto y guardar los cambios.

---

### User Story 4 - Privacidad por Diseño y Almacenamiento Local Soberano (Principio V) (Priority: P4)

Como estudiante universitario que comparte pensamientos vulnerables e íntimos, quiero tener la certeza absoluta de que mis entradas nunca se transmitirán a internet, servidores externos de Firebase ni analíticas de terceros, permaneciendo exclusivamente en el almacenamiento protegido de mi propio teléfono móvil.

**Why this priority**: Es un mandato estricto del **Principio V** de la Constitución de mindUC (*Privacidad por Diseño, Seguridad y Soberanía del Usuario*). El diario no tolera fugas de privacidad ni sincronizaciones remotas no autorizadas.

**Independent Test**: Puede validarse inspeccionando los contratos de datos y la capa de almacenamiento, confirmando que ninguna llamada de red se ejecuta al crear, editar o listar entradas del diario, y que cada tarjeta exhibe el compromiso formal "🔒 Solo visible en este teléfono".

**Acceptance Scenarios**:

1. **Given** cualquier operación en el módulo del diario (crear, leer, editar, eliminar), **When** se ejecuta en el dispositivo, **Then** se procesa íntegramente en almacenamiento local seguro sin invocar servicios remotos de red ni Cloud Firestore.
2. **Given** que el usuario visualiza las tarjetas de su diario, **When** lee el pie de cada reflexión, **Then** se reitera explícitamente el texto "Solo visible en este teléfono" junto al icono de candado cerrado.

---

### Edge Cases

- **Entrada reflexiva con campos en blanco**: Si el usuario intenta guardar una reflexión sin título o sin contenido, el sistema previene el guardado y resalta con suavidad el campo requerido sin mensajes de error estridentes.
- **Entrada reflexiva sumamente extensa**: Si el estudiante escribe múltiples párrafos, la tarjeta de la cronología trunca visualmente el texto a 2-3 líneas con puntos suspensivos ("..."), preservando el texto íntegro en memoria para su lectura completa al abrir la entrada.
- **Eliminación accidental de una huella interior**: Si el usuario abre el menú de opciones (`⋮`) de una tarjeta y selecciona eliminar, el sistema solicita una confirmación compasiva antes de borrar definitivamente el registro del almacenamiento local.
- **Uso sin conexión**: El 100% de la funcionalidad del diario (lectura, pulso emocional, escritura, edición) opera sin interrupciones y sin degradación en modo avión o sin red.

---

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: El sistema DEBE proveer una pantalla dedicada para "Mi Diario Personal" accesible mediante la ruta declarativa `AppRoutes.journalNew` y navegable desde la tarjeta "Diario personal" del Hub de Bienestar.
- **FR-002**: El sistema DEBE exhibir una barra superior serena con logo "mindUC", subtítulo "Minduc — Diario Personal", campana de notificaciones y avatar de perfil de usuario.
- **FR-003**: El sistema DEBE mostrar la insignia botánica "ESPACIO SAGRADO" junto con el título principal "Mi Diario Personal".
- **FR-004**: El sistema DEBE desplegar un banner destacado de privacidad con icono de candado y texto explícito: "Un espacio solo para ti. Tus pensamientos están protegidos y cifrados en tu dispositivo".
- **FR-005**: El sistema DEBE proveer un botón de acción principal de color lavanda suave con icono y texto "+ Nueva entrada reflexiva".
- **FR-006**: El sistema DEBE presentar la tarjeta de pulso emocional "¿Cómo late tu corazón hoy?" con subtítulo "Sintoniza tu sentir" y 5 selectores interactivos: "Agradecida", "En calma", "Reflexiva", "Cansada" y "Abrumada".
- **FR-007**: El sistema DEBE destacar visualmente la emoción activa seleccionada mediante borde o relleno de acento botánico.
- **FR-008**: El sistema DEBE mostrar la sección "Tus huellas interiores" con icono de brote/planta, título de sección y una insignia con el conteo total de reflexiones registradas (ej. "3 entradas").
- **FR-009**: Cada tarjeta de reflexión DEBE exhibir: insignia de pulso emocional con icono (ej. `🌸 En calma`), fecha y hora formateada en español (ej. "Hoy, 24 Octubre · 21:15"), título de la reflexión, extracto del contenido, botón de edición (lápiz), botón de menú de opciones (`⋮`), aviso "🔒 Solo visible en este teléfono" y tiempo estimado de lectura (ej. "2 min de lectura").
- **FR-010**: El sistema DEBE calcular automáticamente el tiempo estimado de lectura de cada reflexión en base a la longitud del texto (1 minuto por cada ~150-200 palabras, mínimo 1 min).
- **FR-011**: El sistema DEBE proveer un diálogo o modal interactivo para crear una nueva entrada con selector de emoción, campo de título y campo de contenido reflexivo.
- **FR-012**: El sistema DEBE permitir la edición de cualquier entrada preexistente al tocar el botón de lápiz de su tarjeta respectiva.
- **FR-013**: El sistema DEBE permitir la eliminación de una entrada reflexiva a través del menú de opciones (`⋮`), solicitando confirmación compasiva previa.
- **FR-014**: De estricta conformidad con el **Principio V** de la Constitución de mindUC, el sistema DEBE almacenar todas las entradas exclusivamente en almacenamiento local seguro del dispositivo, garantizando que los datos reflexivos no se sincronicen remotamente ni queden expuestos.
- **FR-015**: La gestión de estado DEBE ser centralizada y reactiva mediante Riverpod (`StateNotifier` / `Notifier`).

---

### Key Entities *(include if feature involves data)*

- **`JournalMoodPulse`**: Enumeración de estados emocionales disponibles.
  - Valores: `agradecida` ("Agradecida", icono estrella/destellos), `enCalma` ("En calma", icono flor rosa), `reflexiva` ("Reflexiva", icono brote lavanda), `cansada` ("Cansada", icono nube), `abrumada` ("Abrumada", icono ola marina).
  - Atributos: `label`, `iconName`, `accentColor`, `backgroundColor`.
- **`JournalEntry`**: Entidad de dominio inmutable que representa una huella interior.
  - Atributos: `id` (String único), `title` (String), `content` (String), `moodPulse` (`JournalMoodPulse`), `createdAt` (DateTime), `updatedAt` (DateTime?).
  - Getters: `formattedDate` (String formateado en español), `readingTimeMinutes` (int), `previewSnippet` (String truncado a ~120 caracteres).
- **`JournalState`**: Entidad de soporte reactivo administrada por el controlador.
  - Atributos: `entries` (Lista inmutable de `JournalEntry`), `selectedMoodPulse` (`JournalMoodPulse`), `isLoading` (bool).
  - Getters: `entryCount` (int), `hasEntries` (bool).

---

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: El estudiante puede acceder a su diario personal y visualizar sus huellas interiores en menos de 200 ms desde el Hub de Bienestar.
- **SC-002**: La conmutación del pulso emocional en la tarjeta "¿Cómo late tu corazón hoy?" responde visualmente en menos de 50 ms.
- **SC-003**: El flujo de creación de una nueva entrada reflexiva puede completarse en menos de 30 segundos (abrir modal, ingresar título/texto y guardar).
- **SC-004**: El 100% de los datos de las reflexiones se almacena y recupera localmente sin emitir ninguna solicitud de red HTTP/Firebase (0 llamadas remotas).
- **SC-005**: 100% de cobertura en pruebas unitarias del controlador del diario y pruebas de widgets de la pantalla y tarjetas reflexivas.
- **SC-006**: 0 advertencias (`0 warnings`) reportadas por el analizador estático de Dart (`dart analyze`).
- **SC-007**: El 100% de la interfaz refleja fielmente la tipografía, paleta serena y geometría de `mindUC - Diario Personal.png`.

---

## Assumptions

- **Alineación con el Sistema de Diseño Centralizado**: Colores (`MindColors.primary`, `MindColors.surfaceSubtle`, `MindColors.estudioTrabajo`), tipografía Outfit y esquinas redondeadas (16 a 24 dp) coinciden con el estándar global.
- **Persistencia Local Offline-First**: Para la persistencia de datos local, se utilizará una fuente de datos desacoplada en memoria / local (`LocalJournalDataSource`), respetando el repositorio abstracto y posibilitando pruebas deterministas.
- **Principio V (Soberanía y Privacidad)**: La bandera "Solo visible en este teléfono" es un compromiso real y no meramente cosmético; no existe sincronización remota con Cloud Firestore para el diario íntimo.
