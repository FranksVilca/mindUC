# Feature Specification: 009-community-forum

**Feature Branch**: `009-community-forum`

**Created**: 2026-11-03

**Status**: Draft

**Input**: User description: "009-community-forum"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Visualización del Espacio Seguro UC y Cronología de Hilos Comunitarios (Priority: P1) 🎯 MVP

Como estudiante de la UC,
quiero ingresar al espacio de "Comunidad UC Consciente" para leer vivencias y reflexiones de otros compañeros con identidades protegidas y filtrarlas por sentir,
para sentirme acompañado en mi trayectoria universitaria y validar mis emociones en un entorno seguro y libre de juicios.

**Why this priority**: Constituye el núcleo del foro colaborativo (Módulo 4 de mindUC y Principio V), permitiendo al estudiante acceder a la red de apoyo mutuo con estricta protección de su privacidad.

**Independent Test**: Navegar a la pantalla de Comunidad (`AppRoutes.community`) y verificar que se visualice la cabecera serena, el banner de espacio seguro con aviso de moderación e identidad protegida, el botón para compartir, los chips de filtro ("Todo", "Estrés académico", "Desahogo y calma") y las publicaciones iniciales de Figma con sus alias efímeros (`@BúhoCurioso`, `@BroteCalmo`, `@LluviaSuave`).

**Acceptance Scenarios**:

1. **Given** un estudiante autenticado que pulsa el acceso a Comunidad desde Inicio o la ruta `/community`,
   **When** se carga la pantalla,
   **Then** visualiza la cabecera ("mindUC — Comunidad"), el banner "Comunidad UC Consciente" con la insignia "🛡 Identidad protegida: todos los alias son ficticios y efímeros", el conteo de hilos activos y la lista de publicaciones.
2. **Given** la lista con hilos de diversas temáticas,
   **When** el estudiante pulsa el chip "Estrés académico",
   **Then** la lista filtra instantáneamente para desplegar únicamente las publicaciones relacionadas con desahogo académico o exámenes.
3. **Given** el filtro activo,
   **When** el estudiante pulsa el chip "Todo",
   **Then** se restablece la lista completa de publicaciones de la comunidad.

---

### User Story 2 - Reacciones Conscientes y Empatía Mutua (Priority: P2)

Como estudiante que lee una reflexión comunitaria,
quiero tocar los botones de reacción compasiva (`🤍❤️` cariño/apoyo, `🌿` calma, `💡` perspectiva, `🫂` abrazo) en una publicación,
para brindar soporte emocional inmediato a mi compañero de forma respetuosa sin emitir comentarios intrusivos.

**Why this priority**: La interacción compasiva sin métricas de vanidad ni competencia es fundamental para la salud mental estudiantil acorde al diseño de Figma.

**Independent Test**: Tocar cualquiera de los botones de reacción en una tarjeta de publicación y verificar que su contador se incremente instantáneamente y el botón adopte un estado activo visualmente distinguible.

**Acceptance Scenarios**:

1. **Given** una publicación comunitaria con `42` reacciones de apoyo (`🤍❤️`),
   **When** el estudiante pulsa sobre dicha reacción,
   **Then** el contador se incrementa a `43` y el botón se resalta reactivamente como activo.
2. **Given** una reacción previamente marcada por el estudiante,
   **When** el estudiante vuelve a pulsar sobre ella,
   **Then** la reacción se retira de forma suave y el contador se decrementa.

---

### User Story 3 - Publicación de Reflexión Anónima con Alias Efímero (Priority: P3)

Como estudiante que necesita desahogarse o compartir un hábito de calma,
quiero presionar "+ Compartir reflexión anónima" para redactar un mensaje eligiendo un alias ficticio y una etiqueta de sentir,
para expresar lo que vivo sin temor a que mi correo institucional o nombre real queden expuestos.

**Why this priority**: Cumple directamente con el Principio V de la Constitución, garantizando la desvinculación absoluta entre el perfil del estudiante y la identidad pública del foro.

**Independent Test**: Pulsar "+ Compartir reflexión anónima", completar el modal seleccionando facultad, categoría de sentir y texto, confirmar publicación; verificar que la nueva publicación aparezca en la cima de la cronología con el alias efímero asignado y sin referencias al correo del autor.

**Acceptance Scenarios**:

1. **Given** la pantalla de Comunidad,
   **When** el estudiante pulsa "+ Compartir reflexión anónima",
   **Then** se despliega una hoja modal serena con un alias ficticio generado automáticamente (ej. `@BúhoCurioso`, `@BroteCalmo`, `@BriznaSerena`), selector de facultad y chips de sentir ("Necesito desahogo", "Hábito saludable", "Vulnerabilidad").
2. **Given** el formulario modal con texto reflexivo válido,
   **When** el estudiante presiona "Publicar en comunidad",
   **Then** la reflexión se añade a la lista comunitaria en el dispositivo/repositorio, el modal se cierra y el conteo de hilos activos se actualiza.
3. **Given** el formulario modal con texto vacío,
   **When** el estudiante intenta publicar,
   **Then** se muestra un aviso amigable pidiéndole escribir su sentir antes de continuar.

---

### User Story 4 - Interacción con Tarjetas de Bienestar Integradas y Menú Ético (Priority: P4)

Como estudiante que encuentra una recomendación práctica en un hilo comunitario,
quiero pulsar el botón "Probar" en una guía de respiración recomendada o usar el menú de opciones para reportar contenido sensible,
para pasar de la lectura a una práctica de calma inmediata o resguardar el espacio ético del campus.

**Why this priority**: Conecta el foro colaborativo con los módulos de autocuidado de mindUC (como Respiración 4-7-8) y provee herramientas de moderación ética.

**Independent Test**: Tocar el botón "Probar" en la tarjeta de la Guía 4-7-8 de la publicación de `@BroteCalmo` y verificar la navegación hacia `AppRoutes.breathingSession`; tocar el menú `⋮` y comprobar las opciones de apoyo y reporte empático.

**Acceptance Scenarios**:

1. **Given** una publicación con tarjeta de herramienta de bienestar recomendada ("Guía 4–7–8 recomendada"),
   **When** el estudiante pulsa "Probar",
   **Then** la aplicación navega fluidamente a la sesión interactiva de respiración guiada.
2. **Given** cualquier tarjeta de publicación,
   **When** el estudiante pulsa el botón de opciones `⋮`,
   **Then** se despliega un menú compasivo con opciones para "Guardar reflexión" y "Reportar con empatía".

---

### Edge Cases

- **Intento de publicación con datos personales explícitos**: El sistema valida que el estudiante no incluya correos electrónicos (`@uc.cl`) ni números telefónicos en el cuerpo del texto para preservar el anonimato.
- **Publicaciones sin conexión (Offline-First)**: La lista de publicaciones precargadas y las nuevas reflexiones creadas localmente se visualizan de inmediato sin fallar ante la falta de conexión.
- **Hilos sin reacciones previas**: Si un nuevo hilo no tiene reacciones, los botones se muestran con conteo en 0 sin errores de renderizado.
- **Textos extensos**: Las reflexiones admiten párrafos múltiples con espaciado respirable sin producir desbordamientos de pantalla (`RenderFlex overflow`).

---

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: El sistema DEBE proveer la pantalla `CommunityScreen` accesible a través de la ruta declarativa `AppRoutes.community` (`/community`).
- **FR-002**: El sistema DEBE renderizar una cabecera serena con botón de retorno, títulos `mindUC` y `Minduc — Comunidad`, campana de notificaciones y avatar de estudiante.
- **FR-003**: El sistema DEBE incluir el banner "Comunidad UC Consciente" con insignia "ESPACIO SEGURO UC", distintivo "• Moderado con empatía" y aviso de privacidad de identidades efímeras.
- **FR-004**: El sistema DEBE incluir el botón de acción alargado "+ Compartir reflexión anónima" en tono verde salvia pastel (`#C5DEC9`).
- **FR-005**: El sistema DEBE ofrecer una barra horizontal de filtrado por sentir ("Todo", "Estrés académico", "Desahogo y calma", "Hábito saludable", "Vulnerabilidad") junto al conteo de hilos activos.
- **FR-006**: El sistema DEBE desplegar tarjetas de publicación con: avatar temático, alias ficticio efímero (ej. `@BúhoCurioso`), título de rol (ej. `Búho Sereno`), facultad y tiempo transcurrido (ej. `Ingeniería · Hace 2h`), menú `⋮`, chips temáticos y texto de la reflexión.
- **FR-007**: El sistema DEBE permitir incluir tarjetas complementarias en las publicaciones: insight de pausas colectivas, recomendación de técnica guiada con botón "Probar" (enlace a respiración), o respuesta más apoyada.
- **FR-008**: El sistema DEBE proporcionar una barra de reacciones empáticas (`🤍❤️`, `🌿`, `💡`, `🫂`, `💬`) que permita conmutar las reacciones del usuario e incrementar/decrementar el contador en tiempo real.
- **FR-009**: El sistema DEBE proveer el modal `CommunityPostCreateModal` para redactar una nueva reflexión asignando un alias efímero aleatorio sin revelar nunca el correo real del estudiante.
- **FR-010**: El sistema DEBE persistir las publicaciones y reacciones bajo arquitectura limpia y Offline-First a través de `CommunityRepository` y `LocalCommunityDataSource`.

### Key Entities *(include if feature involves data)*

- **CommunityPost**: Entidad inmutable que representa un hilo del foro. Atributos: `id`, `authorAlias` (ej. `@BúhoCurioso`), `authorRole` (ej. `Búho Sereno`), `avatarType` (enum de avatares botánicos/animales), `faculty` (ej. `Ingeniería`), `content` (String), `tags` (List<String>), `moodCategory` (CommunityMoodCategory), `createdAt` (DateTime), `timeAgoString` (String), `supportCount` (int), `calmCount` (int), `insightCount` (int), `hugCount` (int), `commentCount` (int), `userReactions` (Set<String>), `embeddedType` (EmbeddedCardType: none, breathingPrompt, insightNotice, topReply).
- **CommunityMoodCategory**: Categoría emocional para filtrado (`estresAcademico`, `desahogoCalma`, `habitoSaludable`, `vulnerabilidad`).
- **CommunityState**: Estado inmutable para Riverpod que gestiona la lista de publicaciones, el filtro activo, el conteo de hilos y el estado de carga.

---

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: El 100% de los elementos visuales del mockup `mindUC - Comunidad.png` están representados con exactitud milimétrica (cabecera, banner seguro, botón compartir, filtros de sentir, 3 tarjetas de publicación con sus respectivos complementos incrustados y barra de reacciones).
- **SC-002**: Las reacciones y el filtrado por sentir responden de forma instantánea (< 100 ms) sin latencia perceptible ni bloqueos.
- **SC-003**: Cero exposición de datos personales: ninguna entidad, payload o interfaz expone correos electrónicos reales ni nombres de usuario institucionales (cumplimiento total del Principio V).
- **SC-004**: `dart analyze` reporta 0 issues y 0 advertencias, y la suite completa de pruebas (`flutter test`) mantiene el 100% de éxito.

---

## Assumptions

- Se precargan inicialmente las 3 publicaciones representadas en el mockup de Figma (`@BúhoCurioso`, `@BroteCalmo`, `@LluviaSuave`) para brindar una experiencia comunitaria inmediata y visualmente auténtica.
- El botón "Probar" en la tarjeta de `@BroteCalmo` navega limpiamente a `AppRoutes.breathingSession`.
- Las reacciones del usuario se gestionan en memoria local durante la sesión actual con soporte para persistencia offline.
