# Feature Specification: 010-progress-gamification

**Feature Branch**: `010-progress-gamification`

**Created**: 2026-11-03

**Status**: Draft

**Input**: User description: "010-progress-gamification"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Visualización del Espacio de Florecimiento, Racha Compasiva y Momentos de Pausa (Priority: P1) 🎯 MVP

Como estudiante universitario de la UC que busca cuidar su bienestar mental de manera sostenida,
quiero ingresar a la pantalla de "Mi Progreso & Florecimiento" para observar mi racha de autocuidado activo y las métricas de mis momentos de pausa semanales,
para validar con amabilidad el esfuerzo invertido en mi salud emocional sin experimentar la ansiedad de métricas punitivas ni tablas de competencia.

**Why this priority**: Constituye el núcleo visual y conceptual de la pantalla según el mockup de Figma (`mindUC - Progreso y Gamificacion.png`) y materializa de forma directa el **Principio III de la Constitución** (Métricas Compasivas y Gamificación sin Ansiedad).

**Independent Test**: Navegar a la pantalla de Progreso (`AppRoutes.progress`) y verificar que se renderice la cabecera serena, la insignia de "🌱 Crecimiento consciente", el título "Mi Progreso & Florecimiento", la tarjeta de racha activa ("7 días consecutivos" con la franja L-M-X-J-V-S-D) y la cuadrícula 2x2 de "Momentos de pausa" con sus 4 métricas semanales (145 min respiración, 12 sesiones pomodoro, 9 reflexiones diario, 85% equilibrio semanal).

**Acceptance Scenarios**:

1. **Given** un estudiante que navega a la ruta `/progress` desde la tarjeta "Mi progreso" de Inicio,
   **When** la pantalla se renderiza,
   **Then** visualiza la cabecera con retorno, la tarjeta verde suave de "RACHA DE AUTOCUIDADO ACTIVO" con el indicador de "7 días consecutivos", el mensaje de serenidad florecida y los 7 días de la semana con sus respectivos brotes.
2. **Given** la sección "Momentos de pausa",
   **When** el estudiante revisa sus hábitos semanales,
   **Then** encuentra 4 tarjetas independientes con sus iconos temáticos, valores destacados y descripciones compasivas:
     - 🌬️ `145 min` — Respiración consciente y calma interior.
     - ⏱️ `12 sesiones` — Enfoque amable Pomodoro completado.
     - ✍️ `9 reflexiones` — Entradas sinceras en diario íntimo.
     - ⚖️ `85%` — Equilibrio y descanso semanal.

---

### User Story 2 - Jardín de Logros Orgánicos y Reconocimientos Botánicos (Priority: P2)

Como estudiante que progresa paso a paso en sus prácticas de bienestar,
quiero explorar mi "Jardín de logros" para ver qué hábitos han florecido y cuáles continúan creciendo orgánicamente,
para recibir refuerzo positivo y celebrar mi constancia sin caer en dinámicas de comparación tóxica o estrés por desbloqueos forzados.

**Why this priority**: Complementa el florecimiento personal con metáforas botánicas compasivas inspiradas en el mockup de Figma y la Constitución.

**Independent Test**: Inspeccionar el área "Jardín de logros" y verificar que muestre el encabezado con la insignia "3 de 4", subtítulo "Reconocimientos orgánicos a tu constancia" y las 4 tarjetas de logros:
1. `Semilla de Paz` con insignia `✓ Florecida`.
2. `Mente Serena` con insignia `✓ Florecida`.
3. `Voz Auténtica` con insignia `✓ Florecida`.
4. `Foco Lúcido` con barra de progreso lineal al `80%` y etiqueta `4h de 5h (80%)`.

**Acceptance Scenarios**:

1. **Given** la sección "Jardín de logros",
   **When** el estudiante visualiza sus reconocimientos,
   **Then** identifica de forma clara los logros florecidos mediante pastillas con fondo suave y texto distintivo (`✓ Florecida`), acompañados de sus iconos y explicaciones empáticas.
2. **Given** un logro en desarrollo como "Foco Lúcido",
   **When** el estudiante observa su estado,
   **Then** visualiza una barra de progreso sutil sin alarmas ni recordatorios estridentes, mostrando el avance acumulado (`4h de 5h (80%)`).

---

### User Story 3 - Seguimiento de Intenciones Semanales y Recordatorio de Autocompasión (Priority: P3)

Como estudiante con rutinas académicas cambiantes,
quiero consultar mis "Intenciones de la semana" y marcar el avance de mis metas amables,
para avanzar a mi propio ritmo sin la presión de listas de tareas inflexibles y recibir un recordatorio compasivo que reafirme que mi valor no depende de mi productividad.

**Why this priority**: Da carácter accionable y reflexivo a la pantalla, permitiendo al estudiante interactuar con sus intenciones de autocuidado y cerrar la experiencia con una cita de autocompasión.

**Independent Test**: Desplazarse a la sección "Intenciones de la semana", verificar la presencia de las 3 metas amables con sus estados (completada con checkmark, 2/3 días con barra y 2/4 noches con barra), tocar una intención para actualizar reactivamente su progreso y constatar la visualización de la tarjeta de recordatorio compasivo al final de la pantalla.

**Acceptance Scenarios**:

1. **Given** la sección "Intenciones de la semana",
   **When** el estudiante revisa sus intenciones,
   **Then** observa la meta "Hacer 3 pausas activas antes del almuerzo" marcada como completada con check verde circular y texto tachado, "Tomar un paseo consciente de 10 min" con progreso `2 / 3 días`, y "Desconectar pantallas 30 min antes de dormir" con progreso `2 / 4 noches`.
2. **Given** una intención no completada,
   **When** el estudiante pulsa sobre ella para registrar un avance,
   **Then** su indicador numérico y barra de progreso avanzan reactivamente de manera fluida.
3. **Given** el pie de la pantalla,
   **When** el estudiante llega al final del contenido,
   **Then** visualiza la tarjeta con icono de sol matutino y la cita: *“El progreso no es lineal; cada pausa que te das cuenta como una victoria auténtica.”* con el rótulo *Recordatorio de autocompasión*.

---

### User Story 4 - Navegación Integrada desde Inicio y Retorno Fluido (Priority: P4)

Como estudiante que utiliza el panel principal de mindUC,
quiero presionar la tarjeta de acceso rápido "Mi progreso" en Inicio para llegar fluidamente a la pantalla de Progreso y Florecimiento y contar con un botón de retorno,
para moverme de forma intuitiva y coherente por la aplicación.

**Why this priority**: Garantiza la cohesión de navegación en el shell de mindUC, eliminando el Scaffold provisional de `/progress`.

**Independent Test**: Desde la pantalla de Inicio (`HomeScreen`), pulsar la tarjeta "Mi progreso" del acceso rápido y verificar la transición inmediata hacia `CommunityScreen` / `ProgressScreen`, y comprobar que el botón de retorno (`<`) devuelva al usuario al estado anterior.

**Acceptance Scenarios**:

1. **Given** la pantalla de Inicio de mindUC,
   **When** el estudiante toca la tarjeta de acceso rápido "Mi progreso",
   **Then** GoRouter navega a `AppRoutes.progress` y despliega la pantalla completa de Gamificación Detallada.
2. **Given** la pantalla de Progreso,
   **When** el estudiante pulsa el botón `<` de la cabecera,
   **Then** la navegación regresa de forma inmediata a la pantalla precedente.

---

### Edge Cases

- **Estudiante recién registrado (Día 1 / Sin historial previo)**: La racha se presenta como "1 día activo" o siembra inicial sin alertas de "Racha perdida" ni mensajes de castigo. La metáfora es de brote recién plantado.
- **Pausa de varios días por periodo de exámenes o vacaciones**: El sistema jamás muestra penalizaciones, cadenas rotas ni estados degradados. Simplemente muestra el estado actual e invita a un nuevo momento de calma con amabilidad.
- **Dispositivos con pantallas pequeñas (360x640)**: Las cuadrículas de "Momentos de pausa" y "Jardín de logros" utilizan espaciado adaptable o desplazamiento vertical sin producir errores de desbordamiento de píxeles (`RenderFlex overflow`).
- **Uso sin conexión (Offline-First)**: Los datos de progreso, logros e intenciones se almacenan de manera local y están disponibles inmediatamente aun sin conexión a internet.

---

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: El sistema DEBE proveer la pantalla `ProgressScreen` vinculada a la ruta declarativa `AppRoutes.progress` (`/progress`) en `app_router.dart`.
- **FR-002**: El sistema DEBE mostrar una cabecera serena con botón de retorno `<` (`onBack`), títulos centrados `"MINDUC"` y `"Gamificación Detallada"`, y avatar de usuario a la derecha.
- **FR-003**: El sistema DEBE incluir la insignia de categoría `"🌱 Crecimiento consciente"`, el título principal `"Mi Progreso & Florecimiento"` y el subtítulo compasivo `"Celebrando cada paso hacia tu bienestar, a tu propio ritmo."`.
- **FR-004**: El sistema DEBE presentar la tarjeta `"RACHA DE AUTOCUIDADO ACTIVO"` con contador destacado (`7 días consecutivos`), mensaje inspirador botánico y franja semanal de 7 días (`L`, `M`, `X`, `J`, `V`, `S`, `D`) con iconos de brotes activos.
- **FR-005**: El sistema DEBE proveer una cuadrícula con 4 métricas de `"Momentos de pausa"` correspondientes a la semana en curso:
  1. Tiempo de respiración consciente en minutos (`145 min`).
  2. Sesiones amables de concentración Pomodoro (`12 sesiones`).
  3. Reflexiones sinceras en el diario personal (`9 reflexiones`).
  4. Porcentaje de equilibrio y descanso semanal (`85%`).
- **FR-006**: El sistema DEBE incluir la sección `"Jardín de logros"` con distintivo de avance (`3 de 4`) y subtítulo `"Reconocimientos orgánicos a tu constancia"`.
- **FR-007**: El sistema DEBE renderizar los 4 logros orgánicos de Figma:
  1. `Semilla de Paz` (1ª semana seguida de respiración guiada) — Estado: *Florecida*.
  2. `Mente Serena` (10 pausas activas completadas) — Estado: *Florecida*.
  3. `Voz Auténtica` (5 notas reflexivas en tu diario) — Estado: *Florecida*.
  4. `Foco Lúcido` (5h en modo concentración plena) — Estado: *En progreso (4h de 5h - 80%)* con barra lineal.
- **FR-008**: El sistema DEBE implementar la sección `"Intenciones de la semana"` con icono de corazón y subtítulo `"Metas sin prisa, enfocadas en sentirte bien"`.
- **FR-009**: El sistema DEBE permitir registrar y conmutar el avance de las intenciones semanales (ej. pausas activas, paseo consciente, desconexión de pantallas nocturna).
- **FR-010**: El sistema DEBE incluir al final de la pantalla la tarjeta de `"Recordatorio de autocompasión"` con icono solar y la cita reflexiva: *“El progreso no es lineal; cada pausa que te das cuenta como una victoria auténtica.”*.
- **FR-011**: El sistema DEBE aplicar rigurosamente el **Principio III de la Constitución**, excluyendo cualquier mecanismo de culpa, cadenas rotas punitivas o clasificaciones competitivas entre estudiantes.
- **FR-012**: El sistema DEBE operar bajo arquitectura limpia y *Offline-First* a través de `ProgressRepository` y `LocalProgressDataSource`.

### Key Entities *(include if feature involves data)*

- **ActiveStreak**: Value Object que representa la racha activa de autocuidado. Atributos: `daysCount` (int), `message` (String), `completedDays` (List<bool> de longitud 7 correspondientes a L-M-X-J-V-S-D), `currentDayIndex` (int).
- **WeeklyPauseMetrics**: Value Object que resume los momentos de pausa semanales. Atributos: `breathingMinutes` (int), `pomodoroSessions` (int), `journalEntriesCount` (int), `balancePercentage` (int).
- **OrganicAchievement**: Entidad inmutable que representa un reconocimiento botánico. Atributos: `id` (String), `title` (String), `description` (String), `category` (enum: peace, mind, voice, focus), `isBloomed` (bool), `currentProgress` (double), `maxProgress` (double), `progressLabel` (String?).
- **WeeklyIntention**: Entidad inmutable de meta amable. Atributos: `id` (String), `title` (String), `currentUnits` (int), `targetUnits` (int), `unitLabel` (String), `isCompleted` (bool), `iconType` (enum: pauses, walk, screens).
- **ProgressSummaryState**: Estado inmutable global del módulo que contiene la racha activa, las métricas semanales, la lista de logros y las intenciones de la semana.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: La pantalla de Gamificación Detallada carga y visualiza todos sus bloques en menos de 300 ms en el dispositivo.
- **SC-002**: 100% de cumplimiento del Principio III: ninguna pantalla, mensaje ni notificación contiene lenguaje punitivo o generador de culpa ante días sin registro.
- **SC-003**: El marcado de avance en una intención semanal actualiza visualmente el estado del elemento de forma instantánea (< 16 ms / 60 fps).
- **SC-004**: Cobertura de pruebas unitarias y de widgets del 100% para los nuevos componentes, repositorios y controladores del módulo `progress_gamification`.

## Assumptions

- Los datos iniciales provienen de `LocalProgressDataSource` con los valores oficiales reflejados en el mockup de Figma (`7 días`, `145 min`, `12 sesiones`, `9 reflexiones`, `85%`, etc.).
- Las sesiones de respiración, pomodoro y entradas de diario del estudiante alimentan de forma acumulativa el resumen semanal.
- El diseño respeta los tokens de color del sistema de diseño de mindUC (`MindColors`) con fondos suaves en crema y verde salvia.

