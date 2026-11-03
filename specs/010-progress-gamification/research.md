# Research: 010-progress-gamification

## Technical Context & Decisions

### 1. Principio III: Métricas Compasivas y Gamificación sin Ansiedad
- **Mandato Constitucional**:
  - Queda prohibida cualquier dinámica de culpa, vergüenza, fuego que se apaga o cadenas rotas ante días sin registro.
  - La racha se concibe como un hito de autocuidado activo y constancia orgánica ("7 días consecutivos"), acompañada de la metáfora botánica: *"🌱 Tu brote de serenidad floreció hoy con tu pausa matutina"*.
  - Las intenciones semanales son *"Metas sin prisa, enfocadas en sentirte bien"*, sin alertas estresantes ni clasificaciones competitivas entre compañeros.
  - El cierre de la experiencia reafirma la autocompasión: *“El progreso no es lineal; cada pausa que te das cuenta como una victoria auténtica.”*.

### 2. Desglose Visual y Tokens de Diseño (Figma: `mindUC - Progreso y Gamificacion.png`)
- **Cabecera (`ProgressHeader`)**:
  - Botón de retorno `<` (`onBack`) hacia la pantalla anterior.
  - Título superior en mayúsculas sutiles: `"MINDUC"`.
  - Subtítulo: `"Gamificación Detallada"`.
  - Avatar circular a la derecha (`34x34`, icono de usuario).
- **Insignia y Título de Apertura**:
  - Insignia píldora: `"🌱 Crecimiento consciente"` con fondo `Color(0xFFE2F0E7)` y texto `Color(0xFF2C4C3B)`.
  - Título principal: `"Mi Progreso & Florecimiento"` (22sp, `MindColors.textPrimary`).
  - Lema compasivo: `"Celebrando cada paso hacia tu bienestar, a tu propio ritmo."`.
- **Tarjeta de Racha Activa (`ActiveStreakCard`)**:
  - Contenedor verde salvia pastel (`Color(0xFFEAF1ED)`), borde redondeado (`18dp`), borde sutil (`Color(0xFFD6E4DB)`).
  - Título en mayúsculas: `"RACHA DE AUTOCUIDADO ACTIVO"` (10.5sp, bold).
  - Distintivo circular superior derecho con icono de flor/brote.
  - Métrica destacada: `"7 días"` (30sp bold) `"consecutivos"` (14sp regular).
  - Franja semanal de 7 días: `L M X J V S D`:
    - Días completados: círculo pastel suave con icono de brote (`Icons.eco_rounded`).
    - Día domingo florecido: círculo verde bosque (`Color(0xFF3B5648)`) con flor blanca (`Icons.spa_rounded`).
- **Sección "Momentos de pausa" (`WeeklyPauseGrid`)**:
  - Encabezado: `"Momentos de pausa"` a la izquierda, `"Esta semana"` a la derecha.
  - Cuadrícula 2x2:
    1. Respiración consciente: `145 min` — `Respiración consciente y calma interior` (icono `Icons.air_rounded` en círculo verde agua `Color(0xFFD3EBE1)`).
    2. Pomodoro: `12 sesiones` — `Enfoque amable Pomodoro completado` (icono `Icons.timer_rounded` en círculo lila `Color(0xFFE6E3F4)`).
    3. Diario íntimo: `9 reflexiones` — `Entradas sinceras en diario íntimo` (icono `Icons.edit_note_rounded` en círculo melocotón `Color(0xFFFDECE8)`).
    4. Equilibrio semanal: `85%` — `Equilibrio y descanso semanal` (icono `Icons.balance_rounded` en círculo salvia `Color(0xFFE5EDE8)`).
- **Sección "Jardín de logros" (`AchievementsGarden`)**:
  - Encabezado: `"Jardín de logros"` con pastilla `"3 de 4"`, subtítulo `"Reconocimientos orgánicos a tu constancia"`.
  - Cuadrícula 2x2 con fondos pasteles suaves:
    1. `Semilla de Paz` (fondo verde `Color(0xFFEDF6F0)`): `1ª semana seguida de respiración guiada`, pastilla `✓ Florecida`.
    2. `Mente Serena` (fondo lila `Color(0xFFF2F0FA)`): `10 pausas activas completadas`, pastilla `✓ Florecida`.
    3. `Voz Auténtica` (fondo rosa `Color(0xFFFDF0ED)`): `5 notas reflexivas en tu diario`, pastilla `✓ Florecida`.
    4. `Foco Lúcido` (fondo salvia neutro `Color(0xFFEEF3F0)`): `5h en modo concentración plena`, barra de progreso horizontal con etiqueta `4h de 5h (80%)`.
- **Sección "Intenciones de la semana" (`WeeklyIntentionsCard`)**:
  - Contenedor con borde redondeado `18dp`, fondo crema suave.
  - Encabezado: `"Intenciones de la semana"`, pastilla con icono de corazón `🤍`, subtítulo `"Metas sin prisa, enfocadas en sentirte bien"`.
  - 3 ítems con interacción de avance:
    1. `Hacer 3 pausas activas antes del almuerzo`: Círculo checkmark verde, texto tachado, `3 de 3 completadas hoy`.
    2. `Tomar un paseo consciente de 10 min`: Icono reloj de arena, barra lineal, `2 / 3 días`.
    3. `Desconectar pantallas 30 min antes de dormir`: Icono luna, barra lineal, `2 / 4 noches`.
- **Tarjeta de Recordatorio de Autocompasión (`SelfCompassionCard`)**:
  - Fondo neutro sereno (`Color(0xFFF4EFE6)`), icono sol `Icons.wb_sunny_outlined`.
  - Cita: *“El progreso no es lineal; cada pausa que te das cuenta como una victoria auténtica.”*.
  - Pie: *Recordatorio de autocompasión*.

### 3. Principios Diferidos (Post-MVP)
- **Principio VI (IA y Gamificación Avanzada)**: En esta fase, no se utilizan LLMs externos ni algoritmos dinámicos complejos de predicción emocional; las estadísticas se calculan localmente a partir de las sesiones completadas por el estudiante.
- **Principio VII (Bloqueo OS de Apps)**: Las intenciones de desconexión de pantallas son voluntarias y compasivas, sin intercepción de procesos del sistema operativo.

### 4. Persistencia y Arquitectura (Offline-First)
- `ProgressRepository` (Dominio) abstracto desacoplado de Firebase o frameworks.
- `LocalProgressDataSource` (Datos) con almacenamiento en memoria local que provee los valores del mockup de Figma y permite la actualización reactiva de intenciones.
