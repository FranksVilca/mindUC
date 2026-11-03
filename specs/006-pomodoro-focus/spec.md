# Feature Specification: Concentración Pomodoro & Paisajes Sonoros (006-pomodoro-focus)

**Feature Branch**: `006-pomodoro-focus`

**Created**: 2026-11-03

**Status**: Draft

**Input**: User description: "006-pomodoro-focus: Temporizador reactivo de concentración Pomodoro (25m enfoque / 5m descanso / 15m largo), paisajes sonoros relajantes (Lluvia campus, Cafetería calma, Bosque), vinculación de tarea u objetivo académico en curso, y modo enfoque consciente con distracción cero conforme a los principios de mindUC."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Temporizador Pomodoro Reactivo e Intervalos Conscientes (Priority: P1)

Como estudiante universitario en periodo de estudio o evaluaciones, quiero contar con un temporizador Pomodoro circular claro, intuitivo y estéticamente sereno que marque mis bloques de concentración (25 min) y pausas de descanso (5 min corto / 15 min largo), para estructurar mis jornadas académicas con ritmo consciente y prevenir el agotamiento mental.

**Why this priority**: Es el núcleo operativo de la concentración. Sin un temporizador reactivo confiable que gestione los estados (iniciar, pausar, saltar, reiniciar) y visualice el ciclo de 4 bloques, no existe valor funcional mínimo para el estudiante.

**Independent Test**: Puede validarse completamente abriendo la pantalla de Concentración Pomodoro, seleccionando "Enfoque" o descansos, iniciando el cronómetro con "Iniciar enfoque", pausándolo con "Pausar enfoque", saltando al siguiente intervalo con `>|` y reiniciando con `↺`, verificando la progresión visual del arco circular y del indicador numérico `MM:SS`.

**Acceptance Scenarios**:

1. **Given** que el estudiante ingresa a la pantalla de Concentración Pomodoro, **When** visualiza el selector de intervalos, **Then** se muestran las opciones "Enfoque (25m)", "Corto (5m)" y "Largo (15m)", encontrándose "Enfoque" seleccionado por defecto con el tiempo `25:00`.
2. **Given** un intervalo en estado detenido o pausado, **When** el usuario presiona "Iniciar enfoque", **Then** el botón transmuta fluidamente a "Pausar enfoque", el indicador de estado muestra "Bloque activo" y el tiempo restante comienza su cuenta regresiva segundo a segundo junto al avance del arco circular.
3. **Given** un intervalo en curso (ej. en `18:41`), **When** el usuario presiona "Pausar enfoque", **Then** la cuenta regresiva se detiene en ese segundo exacto, el botón cambia a "Reanudar enfoque" y el progreso circular se mantiene estático.
4. **Given** un intervalo en curso o pausado, **When** el usuario presiona el botón de reinicio `↺`, **Then** el cronómetro vuelve al tiempo inicial del intervalo seleccionado (`25:00` o `05:00`) en estado pausado.
5. **Given** un intervalo en curso, **When** el usuario presiona el botón de saltar `>|` o el temporizador alcanza `00:00`, **Then** el sistema avanza al siguiente bloque del ciclo Pomodoro (ej. de Enfoque a Descanso Corto) y actualiza la barra segmentada de ciclos.

---

### User Story 2 - Progreso de Ciclos y Vinculación de Objetivo Académico (Priority: P2)

Como estudiante enfocado, quiero visualizar en qué ciclo de la sesión me encuentro (ej. "Ciclo 2 de 4") y tener visible en todo momento mi objetivo académico actual (ej. "Lectura Cap. 4 — Psicología Social"), con la opción de editarlo rápidamente, para mantener claridad sobre la meta de aprendizaje y no dispersar mi atención.

**Why this priority**: El marco Pomodoro requiere contextualizar el esfuerzo en bloques acumulados (típicamente 4 ciclos antes de un descanso largo) y anclar el tiempo a una tarea concreta para evitar la procrastinación.

**Independent Test**: Puede validarse iniciando sesión, observando la barra superior de 4 segmentos donde el ciclo 1 aparece completo y el ciclo 2 en progreso, y tocando el icono de edición (lápiz) de la tarjeta "OBJETIVO EN CURSO" para actualizar el texto de la tarea.

**Acceptance Scenarios**:

1. **Given** una sesión Pomodoro activa ("Sesión de la tarde"), **When** el usuario observa la cabecera de progreso, **Then** visualiza la insignia "Ciclo X de 4" y una barra de 4 cápsulas horizontales segmentadas que reflejan gráficamente los ciclos completados, el ciclo en curso y los restantes.
2. **Given** la tarjeta de "OBJETIVO EN CURSO", **When** el usuario toca el botón de edición (icono lápiz), **Then** se despliega un diálogo o campo de edición accesible que permite cambiar el título de la tarea académica.
3. **Given** que el usuario introduce un nuevo objetivo (ej. "Preparar informe Laboratorio 2") y confirma, **When** vuelve a la pantalla principal de concentración, **Then** la tarjeta refleja de inmediato el nuevo objetivo persistido.

---

### User Story 3 - Paisajes Sonoros Relajantes y Control de Volumen (Priority: P3)

Como estudiante en un entorno ruidoso o con fatiga sensorial, quiero seleccionar un paisaje sonoro de fondo relajante ("Lluvia campus", "Cafetería calma", "Bosque natural") y regular su volumen suavemente, para inducir un estado de relajación y concentración inmersiva sin salir de la aplicación.

**Why this priority**: El acompañamiento acústico pasivo es un elemento característico del diseño de bienestar de mindUC visible en el mockup de Figma que potencia el estado de calma y enfoque mental.

**Independent Test**: Puede validarse navegando a la sección "Ambiente sonoro", seleccionando cualquiera de las tarjetas de paisajes sonoros ("Lluvia campus", "Cafetería calma", "Bosque"), verificando la activación visual del badge "En reproducción", y deslizando la barra de volumen para modular el nivel de audio.

**Acceptance Scenarios**:

1. **Given** la sección "Ambiente sonoro" con el badge "Audio relajante", **When** el usuario visualiza las opciones, **Then** se presentan las tarjetas horizontales de "Lluvia campus" (con subtítulo "En reproducción" o "Detenido"), "Cafetería calma" ("Murmullo suave") y "Bosque natural" ("Natural").
2. **Given** una pista de sonido seleccionada, **When** el usuario toca otra pista (ej. "Cafetería calma"), **Then** la pista anterior se desactiva y la nueva pista pasa a estado "En reproducción", destacándose con borde o acento visual verde.
3. **Given** un sonido en reproducción, **When** el usuario vuelve a tocar la misma pista activa, **Then** la reproducción se pausa/silencia de manera conmutable.
4. **Given** el control de volumen ubicado bajo las tarjetas de sonido, **When** el usuario desliza la barra entre los iconos de altavoz mínimo y máximo, **Then** el volumen se ajusta proporcionalmente en el estado del controlador.

---

### User Story 4 - Modo Enfoque Profundo Consciente (Principio VII) (Priority: P4)

Como estudiante comprometido con su concentración, quiero poder activar el "Modo enfoque profundo" para silenciar simbólicamente distracciones digitales habituales (ej. Instagram, TikTok, WhatsApp) y recibir recordatorios conscientes de regreso a la calma si desvío mi atención.

**Why this priority**: Presente en el mockup oficial de Figma. Cumple rigurosamente el Principio VII de la Constitución (alcance diferido de bloqueo nativo del SO), ofreciendo valor como pacto consciente de autocuidado y compromiso del estudiante sin recurrir a APIs invasivas de control parental o accesibilidad.

**Independent Test**: Puede validarse accionando el interruptor (switch) de la tarjeta "Modo enfoque profundo", observando el cambio de estado activo/inactivo, la visualización de las apps protegidas simbólicamente (`Instagram 🔒`, `TikTok 🔒`, `WhatsApp 🔒`) y la retroalimentación compasiva al interactuar con el control.

**Acceptance Scenarios**:

1. **Given** la tarjeta inferior "Modo enfoque profundo" con icono de escudo, **When** el usuario visualiza la tarjeta, **Then** se lee el título "Modo enfoque profundo", subtítulo explicativo "3 apps silenciadas temporalmente" y chips de badges con candado para Instagram, TikTok y WhatsApp.
2. **Given** el interruptor de modo enfoque en estado inactivo, **When** el usuario activa el switch, **Then** el switch cambia a color verde activo y el estado de la sesión registra el modo profundo habilitado.
3. **Given** que el usuario toca la tarjeta o solicita detalles sobre el modo enfoque profundo, **When** se despliega información de soporte, **Then** se comunica con claridad que opera bajo un compromiso consciente de autocuidado y distracción cero conforme a las directrices de bienestar de la UC, sin interceptar arbitrariamente procesos externos del teléfono.

---

### Edge Cases

- **Abandono o suspensión de la aplicación en segundo plano**: Si el estudiante minimiza la aplicación o recibe una llamada telefónica mientras el temporizador está corriendo, el tiempo transcurrido real debe calcularse con base en la marca temporal (`DateTime.now()`) para garantizar que al regresar el tiempo restante sea matemáticamente exacto sin desincronizaciones por congelamiento del hilo de ejecución.
- **Llegada a cero (00:00)**: Cuando la cuenta regresiva llega a cero, el sistema detiene el conteo, emite una señal visual y auditiva/háptica suave de finalización, incrementa el contador de ciclos (si era un bloque de enfoque) y sugiere amablemente la transición al intervalo de descanso correspondiente.
- **Reinicio (`↺`) durante un ciclo avanzado**: Si el usuario pulsa reiniciar mientras transcurre el ciclo 3 de 4, se reinicia únicamente el contador de tiempo del bloque activo actual a su duración máxima original (ej. 25:00), preservando intactos los ciclos 1 y 2 ya superados.
- **Objetivo en curso vacío o cancelado**: Si el usuario abre el diálogo de edición del objetivo académico y borra todo el texto o presiona cancelar, el sistema mantiene el objetivo preexistente o restaura un valor predeterminado sereno ("Sesión de estudio concentrado") sin generar estados nulos ni romper la interfaz.
- **Uso sin conexión a internet (Offline-First)**: El 100% de la funcionalidad del temporizador Pomodoro, los indicadores de ciclo, el modo enfoque consciente y los bucles de sonido ambiental deben operar de forma íntegra sin conexión a la red.

---

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: El sistema DEBE proveer una pantalla dedicada para la sesión de concentración Pomodoro accesible mediante la ruta declarativa persistente `AppRoutes.pomodoroSession`.
- **FR-002**: El sistema DEBE ofrecer una barra superior de navegación con botón de retroceso (`<`), título "Minduc — Concentración (Pomodoro)", subtítulo "mindUC" y botón de opciones (`⋮`).
- **FR-003**: El sistema DEBE mostrar un indicador de sesión con etiqueta temática ("Sesión de la tarde"), insignia de progreso de ciclos ("Ciclo X de 4") y una barra segmentada de 4 cápsulas horizontales con relleno proporcional a los ciclos completados y en progreso.
- **FR-004**: El sistema DEBE ofrecer un selector segmentado horizontal para alternar entre tres tipos de intervalos: "Enfoque" (25 min por defecto), "Corto" (5 min por defecto) y "Largo" (15 min por defecto).
- **FR-005**: El sistema DEBE presentar una tarjeta principal con un cronómetro circular visual que trace el avance porcentual del tiempo y exhiba en su núcleo el indicador de estado ("Bloque activo" / "En pausa"), el tiempo digital restante en formato `MM:SS` (ej. `18:41`) y el texto de duración total ("de 25:00 min").
- **FR-006**: El sistema DEBE proveer tres controles de reproducción: botón circular izquierdo de reinicio (`↺`), botón central prominente tipo píldora verde para alternar entre "Iniciar enfoque" / "Pausar enfoque" / "Reanudar enfoque", y botón circular derecho de salto al siguiente intervalo (`>|`).
- **FR-007**: El sistema DEBE mostrar una tarjeta de "OBJETIVO EN CURSO" con icono de marcador/libro, título de la tarea académica activa y botón con icono de lápiz para edición instantánea mediante diálogo interactivo.
- **FR-008**: El sistema DEBE incorporar una sección de "Ambiente sonoro" con icono de ondas (`||||`), título de sección, insignia "Audio relajante" y un carrusel o fila horizontal de tarjetas seleccionables: "Lluvia campus", "Cafetería calma" y "Bosque natural".
- **FR-009**: Cada tarjeta de paisaje sonoro DEBE indicar su estado actual ("En reproducción", "Murmullo suave", "Natural") e iluminarse con borde/acento verde al estar seleccionada, permitiendo alternar entre pistas o pausar el audio al volver a tocar la tarjeta activa.
- **FR-010**: El sistema DEBE proveer un control de deslizamiento (slider) horizontal para ajustar el volumen del paisaje sonoro, flanqueado por iconos de altavoz mínimo y máximo.
- **FR-011**: El sistema DEBE incluir una tarjeta inferior para el "Modo enfoque profundo" con icono de escudo, subtítulo informativo ("3 apps silenciadas temporalmente"), interruptor conmutable (switch) y chips de insignia bloqueada (`Instagram 🔒`, `TikTok 🔒`, `WhatsApp 🔒`).
- **FR-012**: De estricta conformidad con el **Principio VII (Diferido)** de la Constitución de mindUC, el modo enfoque profundo NO DEBE invocar APIs invasivas de bloqueo a nivel del sistema operativo; su funcionamiento debe basarse en compromiso consciente y recordatorios locales de distracción cero.
- **FR-013**: El cálculo del temporizador DEBE sustentarse en marcas temporales de sistema para prevenir pérdidas o retrasos de tiempo cuando la pantalla se apague o la aplicación pase a segundo plano.
- **FR-014**: Toda la información de sesión (objetivo en curso, ciclo actual, configuración de volumen y modo enfoque) DEBE gestionarse de forma reactiva y centralizada mediante Riverpod (`StateNotifier` / `Notifier`).
- **FR-015**: La navegación desde el Hub de Bienestar (`WellnessToolsGrid`, tarjeta "Concentración") DEBE redirigir limpiamente a `AppRoutes.pomodoroSession`.

---

### Key Entities *(include if feature involves data)*

- **`PomodoroSession`**: Entidad de dominio que modela el estado integral de la sesión Pomodoro.
  - Atributos clave: `title` (ej. "Sesión de la tarde"), `currentCycle` (entero 1 a 4), `totalCycles` (4 por defecto), `activeIntervalType` (`focus`, `shortBreak`, `longBreak`), `currentObjective` (texto de la tarea en curso), `isRunning` (booleano), `remainingSeconds` (entero), `totalDurationSeconds` (entero), `isDeepFocusActive` (booleano).
- **`PomodoroIntervalType`**: Enumeración de dominio para los tipos de intervalo.
  - Valores: `focus` (25 min / 1500 s), `shortBreak` (5 min / 300 s), `longBreak` (15 min / 900 s).
- **`SoundscapeTrack`**: Entidad de dominio para representar una pista ambiental relajante.
  - Atributos clave: `id` (identificador único), `title` (ej. "Lluvia campus"), `subtitle` (ej. "En reproducción"), `iconAsset` o `iconData`, `soundType` (`rain`, `cafe`, `forest`), `isPlaying` (booleano).
- **`SoundscapeState`**: Entidad de soporte para la gestión del audio ambiental.
  - Atributos clave: `selectedTrackId` (id de la pista activa o null), `volume` (flotante de 0.0 a 1.0), `isPlaying` (booleano).

---

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: El estudiante puede iniciar, pausar o reanudar el temporizador de concentración con un solo toque y una latencia de respuesta visual inferior a 100 ms.
- **SC-002**: El temporizador mantiene una precisión temporal exacta (desviación < 1 segundo a lo largo de un bloque completo de 25 minutos), incluso ante eventos de suspensión breve o bloqueo de pantalla.
- **SC-003**: La conmutación entre intervalos (Enfoque 25m, Corto 5m, Largo 15m) actualiza inmediatamente la carátula digital y el arco porcentual al 100% en menos de 50 ms.
- **SC-004**: La edición del "Objetivo en curso" se realiza en menos de 3 pasos (tocar lápiz, escribir, guardar) y se refleja en pantalla instantáneamente.
- **SC-005**: El 100% de las pruebas unitarias de controladores y pruebas de widgets de la pantalla de Pomodoro se ejecutan con éxito (cobertura completa de estados: reproducción, pausa, cambio de sonido, ciclos).
- **SC-006**: Cero advertencias (`0 warnings`) reportadas por el analizador estático de Dart (`dart analyze`).
- **SC-007**: El 100% de la experiencia de usuario y diseño visual reproduce fielmente el mockup de referencia `mindUC - Concentracion (Pomodoro).png` sin violar el Principio VII de la Constitución.

---

## Assumptions

- **Alineación con el Sistema de Diseño Centralizado**: Los colores (verdes salvia `AppColors.primary`, fondos orgánicos crema `AppColors.background`, grises neutros `AppColors.textSecondary`), tipografías (`GoogleFonts.outfit`) y radios de tarjeta (16 a 24 dp) se reutilizan directamente desde el módulo central ya establecido (`001-core-foundation`).
- **Arquitectura de Temporizadores Probada**: El controlador de estado se inspirará en el patrón reactivo de temporizador por pulsos ya implementado exitosamente en `004-breathing-relaxation` (`BreathingController`), adaptado a intervalos Pomodoro y ciclo de 4 bloques.
- **Simulación Acústica Consciente**: Para garantizar funcionamiento offline sin requerir descargas pesadas de audio de red en esta fase, la capa de presentación mantendrá el estado reactivo del reproductor y volumen, pudiendo conectarse a fuentes locales de audio ligero o sintetizado.
- **Principio VII (Bloqueo diferido)**: El estudiante comprende y valora que el "Modo enfoque profundo" es un asistente de compromiso interior y distracción consciente, no una aplicación de control coercitivo que interfiera con el sistema operativo de su dispositivo.

