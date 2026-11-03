# Research: 008-agenda-calendar

## Technical Context & Decisions

### 1. Manejo del Tiempo y Calendario Semanal
- **Decisión**: Utilizar la clase nativa de Dart `DateTime` junto con `SpanishDateFormatter` (`core/utils/date_formatter.dart`) para el cálculo de semanas, nombres de días y formateo en español.
- **Cálculo de Semana Calendario (ISO 8601)**:
  - Una función utilitaria pura o método en la entidad calcula el número de semana a partir del día del año:
    ```dart
    int get weekNumber {
      final firstDayOfYear = DateTime(year, 1, 1);
      final daysOffset = firstDayOfYear.weekday - 1;
      final firstMonday = firstDayOfYear.subtract(Duration(days: daysOffset));
      final diff = difference(firstMonday).inDays;
      return (diff / 7).floor() + 1;
    }
    ```
- **Tira Semanal Dinámica**:
  - Para cualquier fecha de referencia (por defecto el 24 de Octubre de 2024 para mantener fidelidad visual idéntica al mockup de Figma o fecha actual), se genera una lista inmutable de 7 fechas correspondientes al Lunes-Domingo de esa semana.
  - Cada elemento expone abreviatura en español (`Lun`, `Mar`, `Mié`, `Jue`, `Vie`, `Sáb`, `Dom`), número de día (`21`, `22`, etc.), y conteo de actividades para los puntos indicadores de densidad (`•` / `••`).

### 2. Categorías Conscientes y Colores Semánticos
- **Categorías oficiales identificadas en Figma**:
  - `Autocuidado`: Color de fondo `MindColors.autocuidado` (`#E8F5E9`), acento `MindColors.autocuidadoAccent` (`#4CAF50`).
  - `Estudio / Trabajo` (`Trabajo`): Color de fondo `MindColors.estudioTrabajo` (`#EDE7F6`), acento `MindColors.estudioTrabajoAccent` (`#7E57C2`).
  - `Salud mental`: Color de fondo `MindColors.saludMental` (`#FFF3E0`), acento `MindColors.saludMentalAccent` (`#FF9800`).
- **Filtros rápidos**:
  - `Todas`: Muestra todas las actividades del día seleccionado.
  - `Autocuidado`: Filtra solo actividades con categoría `autocuidado`.
  - `Estudio / Trabajo`: Filtra solo actividades de tipo académico o laboral.

### 3. Modelo de Datos y Balance Consciente ("Ritmo en equilibrio")
- **Fórmula de Balance**:
  - Total de actividades programadas para el día: `totalActivities = activitiesForDay.length`.
  - Actividades completadas: `completedActivities = activitiesForDay.where((a) => a.isCompleted).length`.
  - Mensaje dinámico de la tarjeta: `"$totalActivities actividades · $completedActivities completadas"`.
  - Progreso normalizado: `progress = totalActivities > 0 ? (completedActivities / totalActivities) : 0.0`.
- **Interacción de Tachado**:
  - Al alternar el estado a `isCompleted == true`, el título adopta `TextDecoration.lineThrough` con un color secundario suave (`MindColors.textTertiary`), y el selector circular muestra fondo menta con checkmark blanco.

### 4. Arquitectura de Persistencia Local (Offline-First)
- **Cumplimiento de la Constitución (Principio I y IV)**:
  - Repositorio abstracto `AgendaRepository` en capa de dominio.
  - `LocalAgendaDataSource` en capa de datos que inicializa las 4 actividades del mockup y permite persistir, alternar y añadir tareas sin requerir red.
  - Preparado para sincronización transparente con Cloud Firestore cuando se active el modo conectado.

### 5. Botón de Asistente por Voz y Modal `+ Nueva`
- **Botón Micrófono (`Icons.mic_none_rounded`)**:
  - En esta fase (conforme a los Principios VI y VII que difieren modelos pesados), el botón de voz proporciona una respuesta amigable explicando el próximo agendador de voz guiada o permitiendo una prueba sonora serena.
- **Modal `+ Nueva`**:
  - `ActivityCreateModal`: Hoja inferior que solicita título, descripción opcional, selector de horario (TimeOfDay) y selector de categoría consciente, insertando la nueva actividad en la jornada seleccionada.
