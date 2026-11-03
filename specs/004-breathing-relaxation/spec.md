# Feature Specification: 004-breathing-relaxation (Respiración y Relajación Consciente)

**Feature Branch**: `004-breathing-relaxation`

**Created**: 2026-11-02

**Status**: Draft

**Input**: User description: "004-breathing-relaxation: Ejercicios guiados de respiración consciente con temporizador circular animado, técnicas (Caja 4-4-4, Relajante 4-7-8) y registro de sesiones"

---

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Sesión de Respiración Guiada con Visualizador Circular Pulsante (Priority: P1) 🎯 MVP

Como estudiante universitario que experimenta tensión, sobrecarga académica o ansiedad,  
quiero una guía visual serena con un círculo animado que se expande y contrae rítmicamente indicando la acción ("Inhala suave", "Retén el aire", "Exhala despacio") y la cuenta regresiva en segundos,  
para regular mi sistema nervioso y recuperar el foco mental en cualquier momento del día.

**Why this priority**: Es la funcionalidad central del módulo de respiración y relajación según el diseño de Figma y el Documento de Diseño v0.1. Permite una pausa de bienestar inmediata e intuitiva.

**Independent Test**: Puede probarse de forma independiente navegando a la pantalla de respiración, verificando que el visualizador circular responde a las fases de respiración con animación continua, muestra la fase activa, el segundero numérico (ej. "2s"), la indicación corporal biomecánica ("EXPANDE EL ABDOMEN") y permite pausar y reanudar con el botón central de cápsula.

**Acceptance Scenarios**:
1. **Given** la pantalla de respiración abierta, **When** el usuario visualiza el centro de la pantalla, **Then** observa un círculo botánico verde menta (`MindColors.autocuidado`) con arco de progreso circular exterior, icono superior de respiración, texto de fase en negrita ("Inhala suave"), contador en segundos ("2s") y frase biomecánica ("EXPANDE EL ABDOMEN").
2. **Given** una sesión activa en fase de inhalación, **When** concluyen los segundos asignados, **Then** el círculo transiciona suavemente a la fase de retención o exhalación con la instrucción y animación respectiva sin interrupciones bruscas.
3. **Given** una sesión en curso, **When** el usuario pulsa "Pausar sesión", **Then** el temporizador y la animación se detienen en el segundo actual y el botón conmuta a "Reanudar sesión".
4. **Given** una sesión pausada, **When** el usuario pulsa el botón circular de reinicio (izquierda), **Then** la sesión vuelve al inicio del ciclo 1 con el tiempo reestablecido.

---

### User Story 2 - Selector de Técnicas Terapéuticas y Contador de Ciclos (Priority: P1)

Como estudiante que necesita adaptarse a diferentes situaciones (concentración antes de un examen vs. relajación antes de dormir),  
quiero alternar entre técnicas validadas (Respiración Cuadrada/Caja 4-4-4, Relajante 4-7-8, o Serena 8-7) y ver el avance de mis ciclos,  
para elegir el ritmo biomecánico más apropiado y monitorear mi constancia.

**Why this priority**: Diferentes estados emocionales demandan diferentes ratios de respiración; la técnica debe ser personalizable con 1 toque sin salir de la sesión.

**Independent Test**: Puede probarse de forma independiente seleccionando una técnica en el dropdown/modal superior y verificando que los tiempos por fase y el total de ciclos calculados se actualizan automáticamente en el contador superior ("Ciclo X de Y").

**Acceptance Scenarios**:
1. **Given** el selector de técnica superior, **When** el estudiante pulsa la píldora verde ("Respiración 4-4-4 (Caja)"), **Then** se despliegan las técnicas disponibles:
   - **Respiración 4-4-4 (Caja)**: Inhala 4s, Retén 4s, Exhala 4s.
   - **Respiración 4-7-8 (Relajante)**: Inhala 4s, Retén 7s, Exhala 8s.
   - **Respiración Serena 8-7**: Inhala 8s, Exhala 7s.
2. **Given** que el usuario cambia a "Respiración 4-7-8 (Relajante)", **When** se ejecuta el ciclo, **Then** la fase de inhalación dura 4s, la de retención 7s y la de exhalación 8s con sus respectivas indicaciones visuales.
3. **Given** la píldora derecha de ciclos, **When** se completa una ronda completa de respiración, **Then** el contador avanza (ej. de "Ciclo 1 de 12" a "Ciclo 2 de 12").

---

### User Story 3 - Tarjeta de Progreso Temporal y Selector de Duración (Priority: P2)

Como estudiante con pausas de tiempo variables entre clases,  
quiero elegir cuánto tiempo dedicar a mi ejercicio (3 min, 5 min, 10 min o Modo Libre) y ver el tiempo restante de un vistazo,  
para adaptar la práctica a mi disponibilidad sin preocuparme por mirar el reloj externo.

**Why this priority**: Brinda flexibilidad temporal para estudiantes con horarios ajustados y provee certidumbre sobre el progreso de la sesión.

**Independent Test**: Puede probarse de forma independiente cambiando el selector segmentado inferior entre "3 min", "5 min", "10 min" y "Libre", y verificando que la tarjeta de progreso superior recalcula el tiempo total y la barra lineal de avance.

**Acceptance Scenarios**:
1. **Given** la tarjeta de progreso superior, **When** la sesión está en curso, **Then** muestra el icono de temporizador, la etiqueta "Tiempo restante", el contador digital "MM:SS / MM:SS" (ej. "07:43 / 10:00") y una barra horizontal de progreso lineal verde suave.
2. **Given** el selector de duración inferior (3 min, 5 min, 10 min, Libre), **When** el usuario toca "5 min", **Then** la opción seleccionada se resalta con fondo verde menta y la tarjeta superior ajusta la meta a "05:00".
3. **Given** que el usuario selecciona el modo "Libre", **When** la sesión inicia, **Then** la tarjeta superior muestra "Tiempo transcurrido: MM:SS" sin límite forzado ni cuenta atrás regresiva.

---

### User Story 4 - Finalización Consciente, Resumen y Registro de Sesión (Priority: P3)

Como estudiante comprometido con su bienestar a largo plazo,  
quiero que al terminar la sesión se reconozca mi esfuerzo con un resumen tranquilizador y se registre el tiempo dedicado,  
para alimentar mi racha de autocuidado y ver florecer mi constancia en el dashboard.

**Why this priority**: El refuerzo positivo no punitivo consolida el hábito de respiración consciente y conecta este módulo con el progreso general del estudiante.

**Independent Test**: Puede probarse de forma independiente dejando expirar el tiempo de la sesión o pulsando el botón de finalizar (cuadrado de stop), verificando que aparece el diálogo/tarjeta de resumen y que la sesión se persiste localmente y en Firestore.

**Acceptance Scenarios**:
1. **Given** una sesión que alcanza el 100% del tiempo estipulado, **When** concluye el último ciclo, **Then** la app emite una confirmación visual serena y presenta un modal con:
   - Felicitación amable ("¡Pausa consciente completada! 🌿").
   - Minutos respirados (ej. "10 minutos").
   - Ciclos completados (ej. "12 ciclos").
   - Botón primario ("Volver al inicio" o "Hacer otra pausa").
2. **Given** un estudiante que decide finalizar antes de tiempo tocando el botón de Stop, **When** la sesión ha durado al menos 1 minuto, **Then** se le ofrece la opción de registrar los minutos completados o salir en calma.
3. **Given** la finalización confirmada, **When** el estudiante regresa al inicio, **Then** el dashboard reconoce la actividad en su racha de bienestar del día.

---

### Edge Cases

- **Usuario sale de la pantalla o bloquea el teléfono durante la sesión**: El estado del temporizador debe calcularse a partir del tiempo real de reloj (`DateTime.now()`) al volver a primer plano, garantizando sincronía exacta sin saltos erráticos.
- **Transición entre modos de duración con sesión pausada**: Al cambiar la duración (ej. de 10 min a 3 min), si el tiempo ya transcurrido supera la nueva duración, la sesión debe ofrecer marcarse como completada de inmediato.
- **Interrupción por llamada o notificación del sistema**: La sesión se pausa automáticamente para no perder el ritmo biomecánico del estudiante.
- **Modo avión o sin conexión a internet**: Todo el ejercicio de respiración opera de forma 100% offline; el registro de la sesión se guarda en caché local y se sincroniza automáticamente con Firestore al restablecerse la red.

---

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: El sistema DEBE mostrar en la barra superior el botón de retroceso hacia la pantalla previa, el título centrado "Sesion Respiracion" con subtítulo "mindUC", la campana de notificaciones y el avatar del usuario.
- **FR-002**: El sistema DEBE incluir un selector desplegable de técnica de respiración en la parte superior izquierda que permita conmutar entre al menos: "Respiración 4-4-4 (Caja)", "Respiración 4-7-8 (Relajante)" y "Respiración Serena 8-7".
- **FR-003**: El sistema DEBE incluir un indicador de ciclos en la parte superior derecha que muestre el ciclo en curso y el total proyectado (ej. "Ciclo 6 de 12").
- **FR-004**: El sistema DEBE presentar una tarjeta de estado temporal con el icono de temporizador, el texto "Tiempo restante", el tiempo digital formateado "MM:SS / MM:SS" y una barra de progreso lineal continua.
- **FR-005**: El sistema DEBE renderizar en el centro un visualizador circular animado que expanda su escala durante la inhalación, se mantenga estable durante la retención y se contraiga suavemente durante la exhalación a 60 cuadros por segundo.
- **FR-006**: El visualizador circular DEBE mostrar el icono temático de aire, la instrucción de fase en negrita ("Inhala suave", "Retén el aire", "Exhala despacio"), el segundero numérico de la fase ("2s") y la guía biomecánica en mayúsculas espaciadas ("EXPANDE EL ABDOMEN", "MANTÉN LA CALMA", "LIBERA LA TENSIÓN").
- **FR-007**: El sistema DEBE proveer una fila inferior de controles con:
  - Botón circular izquierdo para reiniciar la sesión al ciclo 1.
  - Botón de cápsula central amplio para "Pausar sesión" / "Iniciar sesión" / "Reanudar sesión".
  - Botón circular derecho para detener y finalizar la sesión.
- **FR-008**: El sistema DEBE presentar un selector segmentado horizontal de duración predefinida con las opciones "3 min", "5 min", "10 min" y "Libre", destacando visualmente la opción activa con estilo botánico.
- **FR-009**: Al concluir la duración programada, el sistema DEBE detener la animación de forma armónica y desplegar un resumen con los minutos dedicados y ciclos alcanzados.
- **FR-010**: El sistema DEBE persistir los datos de la sesión completada (tiempo en segundos, técnica utilizada, ciclos y timestamp) en almacenamiento local y en Cloud Firestore bajo el esquema de usuario autenticado.

---

### Key Entities *(include if feature involves data)*

- **BreathingTechnique**: Entidad inmutable que define una técnica de respiración: identificador (`id`), nombre (`name`), descripción breve (`description`), segundos de inhalación (`inhaleSeconds`), segundos de retención tras inhalar (`holdSeconds`), segundos de exhalación (`exhaleSeconds`) y segundos de pausa post-exhalación (`postHoldSeconds`).
- **BreathingPhase**: Enumeración de fases del ciclo: `inhale` (Inhala suave), `hold` (Retén el aire), `exhale` (Exhala despacio), `rest` (Pausa en calma). Cada una con su guía biomecánica corporal predeterminada.
- **BreathingSessionState**: Estado inmutable de la sesión activa: técnica seleccionada, fase actual, segundos restantes de la fase actual, segundos totales transcurridos, segundos totales objetivo, ciclo actual, ciclos totales, estado de ejecución (`idle`, `running`, `paused`, `completed`).
- **BreathingSessionLog**: Registro inmutable de sesión completada: identificador único (`id`), `userId`, `techniqueId`, `durationSeconds`, `cyclesCompleted`, `dateString` (`YYYY-MM-DD`) y `timestampMillis`.

---

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: La animación circular de expansión y contracción se ejecuta de manera continua a 60 cuadros por segundo constantes, sin tirones (`jank`) ni saltos visuales durante las transiciones de fase.
- **SC-002**: El 100% de los elementos visuales, colores (fondos menta, sage oscuro, arenas), tipografías y radios coinciden con el diseño oficial de Figma (`mindUC - Respiracion y Relajacion.png`).
- **SC-003**: El cambio de técnica o duración de sesión se aplica de forma instantánea en menos de 100 milisegundos sin requerir recargar la pantalla.
- **SC-004**: Los ejercicios de respiración funcionan con autonomía total sin conexión a internet (Offline-First), permitiendo completar y registrar sesiones en modo avión.

---

## Assumptions

- **A-001**: El temporizador visual no depende de la reproducción obligatoria de archivos de audio para operar; las señales sonoras o hápticas serán sutiles y respetarán el modo silencioso del dispositivo.
- **A-002**: Si el usuario está autenticado, la sesión se sincroniza con su historial de bienestar en `users/{userId}/breathing_sessions`; si está en modo invitado o anónimo, se almacena en memoria/almacenamiento local seguro.
- **A-003**: La técnica predeterminada al ingresar es "Respiración 4-4-4 (Caja)" con una duración sugerida de "10 min", exactamente como se ilustra en el mockup oficial de Figma.

