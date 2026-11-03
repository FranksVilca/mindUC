# Research: 005-wellness-hub

**Feature**: 005-wellness-hub  
**Date**: 2026-11-02  
**Purpose**: Documentar decisiones técnicas y arquitectónicas para el Hub de Bienestar de mindUC.

---

## 1. Decisiones de Arquitectura y Navegación

### Decisión 1: Integración con GoRouter y Shell Persistente
- **Decisión**: `WellnessScreen` se posiciona formalmente en la rama `index 1` (`AppRoutes.wellness`) del `StatefulShellRoute.indexedStack` en `lib/core/router/app_router.dart`.
- **Razón**: Conserva la barra de navegación persistente con 4 pestañas oficiales (Inicio, Bienestar, Agenda, Perfil) y preserva el desplazamiento vertical del estudiante cuando conmuta entre pestañas sin reconstrucciones costosas de UI.
- **Alternativas descartadas**: Navegar con rutas planas tipo `pushReplacement` destruía el árbol de estado y provocaba parpadeos visuales al volver de otras secciones.

### Decisión 2: Inicio en Un Solo Toque ("1-Tap") del Ejercicio Sugerido
- **Decisión**: La tarjeta "EJERCICIO SUGERIDO PARA TI HOY" tiene el botón `▶ Comenzar (5 min)` que configura automáticamente el `breathingSessionControllerProvider` con la técnica `BreathingTechnique.relaxing478` y la duración `300` segundos (5 min) antes o durante la transición a `AppRoutes.breathingSession`.
- **Razón**: Cumple con el objetivo de reducción de fricción cognitiva (FR-005). El estudiante fatigado solo toca 1 botón y entra directo al ejercicio guiado relajante.
- **Alternativas descartadas**: Llevar al estudiante a la pantalla de respiración y requerirle cambiar manualmente la técnica y el tiempo aumentaba la carga cognitiva y contravenía la intención del diseño de Figma.

### Decisión 3: Manejo de Módulos Diferidos y Enlaces Secundarios
- **Decisión**:
  - Para `Asistente IA ✨`: En estricto cumplimiento del Principio VI (Ética de IA y Gamificación Diferida), pulsar esta tarjeta despliega un diálogo sereno `AiAssistantComingSoonDialog` informando que el acompañante de escucha compasiva está en fase de validación ética para la comunidad UC.
  - Para `Concentración`: Conecta con `AppRoutes.pomodoroSession`. Si aún está en construcción, muestra una vista de reserva o ruta modular serena.
  - Para `Diario Personal`: Conecta con `AppRoutes.journalNew`.
- **Razón**: Permite tener la cuadrícula 100% interactiva y funcional sin violar la Constitución ni requerir dependencias de LLM externas no aprobadas.
- **Alternativas descartadas**: Deshabilitar u ocultar la tarjeta de IA alteraba la composición visual exacta del mockup `mindUC - Bienestar.png`.

### Decisión 4: Sistema de Colores y Tokens Botánicos
- **Decisión**: Asignar exactamente los tokens temáticos preexistentes en `MindColors`:
  - `MindColors.autocuidado` (`0xFFEAF1ED`): Fondo de la píldora "SANCTUARY MODE", tarjeta de ejercicio sugerido y tarjeta "Respiración".
  - `MindColors.estudioTrabajo` (`0xFFEBE8F7`): Fondo lavanda suave para "Diario personal".
  - `MindColors.descanso` (`0xFFE5F0F5`): Fondo celeste suave para "Asistente IA ✨".
  - `MindColors.saludMental` (`0xFFFCE7E1`): Fondo coral suave para "Concentración".
  - `MindColors.primaryDark` (`0xFF4C6B5E`): Botón `▶ Comenzar (5 min)` e iconos destacados.
- **Razón**: Fidelidad absoluta al Principio III (Figma como Verdad Visual).

---

## 2. Evaluación de Rendimiento

- La pantalla de Bienestar es estática/reactiva y no requiere tickers continuos de 60 fps (a diferencia de `BreathingCircleVisualizer`), lo que permite que el primer frame se renderice en < 30 ms.
- Se utiliza `SingleChildScrollView` con `physics: BouncingScrollPhysics()` para garantizar soporte ergonómico en pantallas de menor altura sin desbordamiento.
