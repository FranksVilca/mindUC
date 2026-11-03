# Feature Specification: 003-home-dashboard (Dashboard Principal del Estudiante)

**Feature Branch**: `003-home-dashboard`

**Created**: 2026-11-02

**Status**: Draft

**Input**: User description: "003-home-dashboard: Dashboard principal del estudiante con check-in de ánimo, accesos rápidos y tareas del día"

---

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Vista Principal, Saludo Dinámico y Fecha en Píldora (Priority: P1) 🎯 MVP

Como estudiante universitario autenticado en mindUC,  
quiero ver una pantalla de inicio personalizada y tranquila con mi nombre de pila, la fecha actual y la barra de navegación institucional,  
para sentirme en un espacio propio y seguro nada más abrir la aplicación.

**Why this priority**: Es la puerta de entrada diaria del estudiante tras el login. Establece el tono sereno, empático y acogedor de la plataforma según el diseño oficial de Figma.

**Independent Test**: Puede probarse de forma independiente verificando que, al iniciar sesión, se despliega la cabecera con el logo `mindUC` y subtítulo `Inicio`, la campana de notificaciones con badge, el avatar circular de usuario, la píldora superior con la fecha del día en formato amigable (ej. "Jueves, 24 de Octubre"), el saludo cálido ("¡Hola, Camila! 🌿") y la pregunta de autoconocimiento "¿Cómo te sientes en este momento?".

**Acceptance Scenarios**:
1. **Given** un estudiante con sesión iniciada y nombre "Camila Soto", **When** ingresa a la pestaña de Inicio (`/home`), **Then** observa el saludo "¡Hola, Camila! 🌿" y la fecha de hoy formateada en español en una píldora botánica.
2. **Given** un estudiante sin nombre registrado o en sesión anónima, **When** ingresa a Inicio, **Then** el sistema muestra de forma elegante el saludo genérico "¡Hola, Estudiante! 🌿".
3. **Given** el estudiante en la pantalla de inicio, **When** pulsa el avatar de usuario o el icono de campana, **Then** se activa la interacción de retroalimentación táctil suave correspondiente.

---

### User Story 2 - Check-in Rápido de Estado de Ánimo en 1 Toque (Priority: P1)

Como estudiante que experimenta diversas cargas emocionales durante el semestre,  
quiero seleccionar mi estado de ánimo actual con un solo toque entre 5 opciones amables y visualmente diferenciadas,  
para tomar conciencia de mi sentir presente y registrar mi pulso emocional sin esfuerzo ni fricción cognitiva.

**Why this priority**: El check-in diario es el núcleo de la autoconciencia emocional en mindUC y alimenta las estadísticas y sugerencias de bienestar. Debe ser instantáneo (1 toque), sin formularios pesados.

**Independent Test**: Puede probarse independientemente renderizando la sección "Tu estado de ánimo", seleccionando cualquiera de los 5 estados emocionales (Calma, Feliz, Ansiosa, Cansada, Enérgica) y verificando que el elemento seleccionado cambia de estado visual y persiste la selección en el día actual.

**Acceptance Scenarios**:
1. **Given** la sección "Tu estado de ánimo" con el subtítulo "Selecciona uno", **When** el estudiante visualiza la fila horizontal de opciones, **Then** observa 5 tarjetas de color sereno con su respectiva iconografía y etiqueta: Calma (😌, fondo menta), Feliz (✨, fondo melocotón), Ansiosa (🌧️, fondo lavanda), Cansada (☕, fondo arena) y Enérgica (🌱, fondo verde suave).
2. **Given** el estudiante que aún no registra su ánimo de hoy, **When** toca la opción "Calma", **Then** dicha tarjeta se resalta visualmente (borde o contraste activo), se confirma el registro inmediato y se mantiene la selección si navega y regresa a la pantalla.
3. **Given** un estudiante que ya seleccionó "Calma" por la mañana, **When** por la tarde toca "Cansada", **Then** el sistema actualiza la emoción del día actual sin generar duplicados desordenados ni frustración.

---

### User Story 3 - Cuadrícula de Accesos Rápidos "Espacios para ti" (Priority: P2)

Como estudiante que busca gestionar su ritmo universitario,  
quiero disponer de tarjetas de acceso directo y claro a los cuatro pilares de bienestar y productividad (Relajación, Agenda, Comunidad y Mi progreso),  
para navegar fluidamente a la herramienta que necesito en el momento justo.

**Why this priority**: Facilita el descubrimiento y la navegación sin sobrecargar la barra inferior, permitiendo un salto contextual directo con información complementaria en cada tarjeta.

**Independent Test**: Puede probarse de forma independiente verificando que la cuadrícula 2x2 "Espacios para ti" renderiza las 4 tarjetas con sus colores temáticos, iconos circulares blancos, flechas indicadoras y subtítulos explicativos, y que al pulsar cada una se activa la navegación hacia la pantalla de destino respectiva.

**Acceptance Scenarios**:
1. **Given** la cuadrícula "Espacios para ti", **When** el estudiante la observa, **Then** ve cuatro tarjetas en disposición 2x2 con fondo pastel distintivo:
   - **Relajación**: Fondo verde menta suave, icono de meditación, titular "Relajación", subtítulo "Respira y libera tensión (10 min)".
   - **Agenda**: Fondo lavanda suave, icono de calendario, titular "Agenda", subtítulo "4 actividades pendientes hoy".
   - **Comunidad**: Fondo melocotón suave, icono de grupo comunitario, titular "Comunidad", subtítulo "Conecta en el foro anónimo UC".
   - **Mi progreso**: Fondo arena suave, icono de gráfica de crecimiento, titular "Mi progreso", subtítulo "Racha de 7 días continuos".
2. **Given** el estudiante en la pantalla de inicio, **When** pulsa la tarjeta "Relajación", **Then** el sistema navega a la sección de respiración y relajación consciente.
3. **Given** el estudiante en la pantalla de inicio, **When** pulsa la tarjeta "Agenda", **Then** el sistema conmuta a la pestaña correspondiente de Agenda.

---

### User Story 4 - Resumen Dinámico del Día y Métricas de Actividad (Priority: P3)

Como estudiante que organiza sus jornadas,  
quiero que las tarjetas de acceso rápido reflejen contadores reales de mi progreso y tareas (ej. número real de actividades pendientes para hoy y días de racha),  
para tener un panorama instantáneo de mis compromisos y mi constancia de autocuidado.

**Why this priority**: Aporta dinamismo y utilidad práctica en tiempo real a las tarjetas estáticas, unificando la productividad con la tranquilidad mental.

**Independent Test**: Puede probarse de forma independiente suministrando un listado de tareas del día y una racha acumulada, y comprobando que el texto de las tarjetas "Agenda" y "Mi progreso" se actualiza acorde a los datos del repositorio local/remoto.

**Acceptance Scenarios**:
1. **Given** 3 actividades pendientes programadas para hoy, **When** se carga el dashboard, **Then** la tarjeta de Agenda muestra "3 actividades pendientes hoy".
2. **Given** que todas las actividades del día han sido completadas, **When** se visualiza la tarjeta de Agenda, **Then** muestra un mensaje sereno como "Al día con tus actividades ✨".
3. **Given** un estudiante con una racha activa de 5 días, **When** consulta el dashboard, **Then** la tarjeta de Mi progreso muestra "Racha de 5 días continuos".

---

### Edge Cases

- **Usuario sin conexión a internet (Offline)**: El dashboard debe cargar instantáneamente desde la caché local (Firestore offline / almacenamiento persistente), permitiendo registrar el estado de ánimo localmente y encolando la sincronización cuando vuelva la conectividad.
- **Cambio de fecha a medianoche con la app abierta**: El componente de fecha y la consulta de tareas del día deben reaccionar al cambio de fecha del sistema sin necesidad de reiniciar la app.
- **Nombres de usuario muy largos o con caracteres especiales**: El saludo "¡Hola, [Nombre]!" debe truncar o ajustarse en una sola línea elegante utilizando únicamente el primer nombre o apodo, sin romper el espaciado ni generar desbordamiento (`overflow`).
- **Cero tareas programadas en la agenda**: La tarjeta de Agenda debe mostrar un mensaje tranquilizador (ej. "Sin pendientes para hoy 🌿") en lugar de un error o texto vacío.

---

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: El sistema DEBE mostrar en la cabecera superior el logo "mindUC" con subtítulo "Inicio", el acceso a notificaciones con indicador de alerta y el avatar del estudiante autenticado.
- **FR-002**: El sistema DEBE presentar una píldora visual destacada con la fecha del día actual formateada en español (ej. "Jueves, 24 de Octubre") acompañada de un icono de calendario.
- **FR-003**: El sistema DEBE saludar al estudiante por su primer nombre de forma personalizada ("¡Hola, [Primer Nombre]! 🌿") y mostrar la frase reflexiva "¿Cómo te sientes en este momento?".
- **FR-004**: El sistema DEBE proveer un selector horizontal de estado de ánimo de 5 opciones (Calma, Feliz, Ansiosa, Cansada, Enérgica), cada una con su icono distintivo, etiqueta textual y paleta de color establecida en el sistema de diseño de Figma.
- **FR-005**: El sistema DEBE permitir registrar o actualizar el estado de ánimo del día con un solo toque, proporcionando retroalimentación visual de selección activa y guardando el registro con marca de tiempo.
- **FR-006**: El sistema DEBE desplegar una cuadrícula de 2x2 ("Espacios para ti") compuesta por 4 tarjetas táctiles de esquinas redondeadas (22dp): Relajación, Agenda, Comunidad y Mi progreso.
- **FR-007**: Cada tarjeta de la cuadrícula DEBE contener su icono circular blanco temático, flecha de navegación discreta, título en negrita y subtítulo descriptivo contextual.
- **FR-008**: Al presionar cada tarjeta de "Espacios para ti", el sistema DEBE redirigir al estudiante a la ruta o pestaña correspondiente de la aplicación sin perder el estado del shell persistente.
- **FR-009**: Las tarjetas de "Agenda" y "Mi progreso" DEBEN reflejar métricas dinámicas basadas en las tareas pendientes del día y la racha de días de bienestar acumulada.
- **FR-010**: El sistema DEBE operar con soporte Offline-First, permitiendo visualizar la pantalla y marcar el estado de ánimo aun sin conexión activa a la red.

---

### Key Entities *(include if feature involves data)*

- **MoodType**: Enumeración de los 5 estados de ánimo soportados (`calma`, `feliz`, `ansiosa`, `cansada`, `energica`), con sus metadatos asociados (etiqueta legible en español, emoji/icono y código de color temático).
- **MoodEntry**: Registro inmutable de estado de ánimo que contiene identificador único, identificador del usuario (`userId`), fecha de registro (`dateString` formato `YYYY-MM-DD`), tipo de emoción (`MoodType`) y marca temporal de creación en milisegundos (`timestampMillis`).
- **HomeDashboardSummary**: Objeto de resumen que consolida la información requerida por la vista de inicio: primer nombre del usuario, fecha actual formateada, estado de ánimo registrado hoy (si existe), cantidad de tareas pendientes hoy y días de racha consecutivos.
- **QuickAccessItem**: Modelo descriptor de cada tarjeta de acceso rápido con título, subtítulo, ruta de navegación GoRouter, icono y color de fondo temático.

---

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Los estudiantes pueden completar su check-in emocional diario en menos de 2 segundos desde que se abre la aplicación (interacción de 1 solo toque).
- **SC-002**: La pantalla de inicio se renderiza y responde a interacciones de scroll y toques a 60 cuadros por segundo constantes, sin saltos visibles de renderizado.
- **SC-003**: El 100% de los elementos visuales, colores de fondo pastel, tipografías y radios de borde coinciden con el diseño oficial de Figma (`mindUC - Inicio.png`).
- **SC-004**: La navegación desde las tarjetas de acceso rápido hacia sus respectivos destinos se completa de forma instantánea sin tiempos de espera perceptibles ni reconstrucciones innecesarias de la interfaz.

---

## Assumptions

- **A-001**: La sesión del usuario ya está gestionada y validada por el módulo `002-auth-welcome`; el usuario actual cuenta con un `UserEntity` disponible en el estado global.
- **A-002**: Si los módulos de destino (Comunidad, Progreso, Respiración) están en desarrollo o fase preliminar, la navegación redirigirá a las rutas correspondientes o mostrará sus pantallas base respetando la arquitectura de rutas sin generar errores de pantalla negra.
- **A-003**: La persistencia del check-in diario se almacena en Firestore en la subcolección `users/{userId}/mood_entries/{dateString}` y localmente en caché offline de Firestore para garantizar disponibilidad sin red.
- **A-004**: La racha de días se calcula evaluando los días continuos con al menos una sesión de bienestar o check-in de ánimo registrado.

