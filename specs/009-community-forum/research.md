# Research: 009-community-forum

## Technical Context & Decisions

### 1. Principio V: Privacidad por Diseño y Generación de Alias Efímeros
- **Requisito Constitucional**: El estudiante autenticado (ej. `camila.soto@uc.cl`) nunca debe exponer su correo o nombre real en el foro. Los alias deben ser autónomos, ficticios y efímeros (`@BúhoCurioso`, `@BroteCalmo`, `@LluviaSuave`, etc.).
- **Mecanismo de Generación de Alias**:
  - Un generador aleatorio combina adjetivos y animales/elementos botánicos serenos:
    - Animales/Naturaleza: `Búho`, `Brote`, `Lluvia`, `Brizna`, `Roble`, `Canto`, `Espiga`.
    - Adjetivos: `Curioso`, `Calmo`, `Suave`, `Sereno`, `Verde`, `Atento`, `Luminoso`.
    - Roles empáticos: `Búho Sereno`, `Brote Verde`, `Brizna Serena`, `Guardián Calmo`.
  - Iconos de Avatar asociados:
    - Luna / Noche (`Icons.nightlight_round`)
    - Planta / Brote (`Icons.eco_rounded`)
    - Gota de agua / Lluvia (`Icons.water_drop_rounded`)
    - Flor / Spa (`Icons.spa_rounded`)

### 2. Categorías Emocionales y Filtros por Sentir
- **Filtros oficiales en Figma**:
  - `Todo`: Todos los hilos activos.
  - `Estrés académico`: Hilos enfocados en exigencia, exámenes, entregas, síndrome del impostor.
  - `Desahogo y calma`: Desahogo emocional, reflexiones tranquilizantes.
  - `Hábito saludable`: Prácticas de respiración, pausas, autocuidado estudiantil.
  - `Vulnerabilidad`: Expresión honesta de dificultades y empatía mutua.
- **Conteo de Hilos**:
  - Encabezado dinámico: `"Filtrar por sentir"` y a la derecha `"${state.activeThreadCount} hilos activos"`.

### 3. Tarjetas Incrustadas en Hilos Comunitarios (Embedded Cards)
- El mockup de Figma exhibe tres tipos enriquecidos de complementos visuales dentro de los hilos:
  1. **Insight de Impacto Respiratorio (`insightNotice`)**:
     - Ejemplo: *"5 compañeros han tomado una pausa respiratoria tras leer esto."* con icono `Icons.self_improvement_rounded`.
  2. **Herramienta de Bienestar Recomendada (`breathingPrompt`)**:
     - Ejemplo: *"Guía 4–7–8 recomendada — 3 min · Sesión de calma"* con botón interactivo `"Probar"` que navega a `AppRoutes.breathingSession`.
  3. **Respuesta Más Apoyada (`topReply`)**:
     - Ejemplo: *"🌱 Respuesta más apoyada: '¡Nos pasa a muchos, no estás sola! Estás exactamente donde mereces estar. Paso a paso 🌻'"*.

### 4. Barra de Reacciones Empáticas
- **Diseño sin vanidad ni contienda**:
  - Los botones de reacción usan iconos expresivos con contadores discretos:
    - `🤍❤️`: Cariño y apoyo incondicional (`support`).
    - `🌿`: Calma y serenidad (`calm`).
    - `💡`: Nueva perspectiva o claridad (`insight`).
    - `🫂`: Abrazo y acompañamiento comunitario (`hug`).
    - `💬`: Conteo de comentarios solidarios (`comments`).
  - La interacción de tocar una reacción la alterna de forma reactiva en el estado local del estudiante.

### 5. Persistencia y Arquitectura (Offline-First)
- `CommunityRepository` (Dominio) desacoplado de cualquier SDK.
- `LocalCommunityDataSource` (Datos) con almacenamiento en memoria/local que precarga los 3 hilos oficiales de Figma y almacena las nuevas reflexiones sin sincronizar datos personales del usuario a Firestore en esta fase.
