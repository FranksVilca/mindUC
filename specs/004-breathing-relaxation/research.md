# Research & Decisions: 004-breathing-relaxation

**Feature**: 004-breathing-relaxation (Respiración y Relajación Consciente)  
**Date**: 2026-11-02  
**Status**: Resolved  

---

## 1. Animación Circular Suave y Frecuencia de Refresco (60 FPS)

### Context & Challenge
El círculo de respiración debe expandirse gradualmente durante la inhalación, mantenerse firme en la retención y contraerse pacíficamente durante la exhalación sin saltos ni micro-pausas que puedan provocar distracción o ansiedad en el estudiante.

### Decision
Utilizar un `AnimationController` con `SingleTickerProviderStateMixin` acoplado al controlador de sesión:
- **Curvas**: `Curves.easeInOutCubic` para una expansión orgánica que imita el llenado pulmonar fisiológico.
- **Renderizado del Arco**: `CustomPainter` (`BreathingCirclePainter`) que dibuja el anillo punteado de fondo y el arco de progreso continuo en color verde salvia oscuro (`MindColors.primaryDark`).
- **Escalado del Círculo**: `Transform.scale` con rango de `1.0` (reposo/vacío) a `1.22` (inhalación plena).

### Alternatives Considered
- *Temporizadores `Timer.periodic(100ms)` con setState manual*: Rechazado por generar micro-tirones y alto consumo innecesario de CPU en móviles comparado con los `Ticker` nativos de Flutter a 60 fps.

---

## 2. Gestión de Tiempo y Precisión ante Pérdida de Foco

### Context & Challenge
Si el estudiante bloquea la pantalla momentáneamente o atiende una notificación del sistema, un contador basado exclusivamente en `ticks` acumulados puede desfasarse respecto al tiempo real de reloj.

### Decision
El controlador mantiene tanto la fase activa como la marca temporal de inicio de la fase (`phaseStartEpochMillis`). Al reanudar o recibir eventos del ciclo de vida de la aplicación (`AppLifecycleState.resumed`), el controlador calcula el tiempo real transcurrido recalculando la fase y los segundos restantes con base en `DateTime.now().millisecondsSinceEpoch`.

---

## 3. Catálogo de Técnicas Respiratorias y Biomecánica

### Context & Challenge
Se requiere cubrir tanto los patrones del Documento de Diseño v0.1 (8s inhalación, 7s exhalación) como las técnicas ampliamente reconocidas en bienestar estudiantil y mockups de Figma.

### Decision
Configurar un catálogo predeterminado inmutable `BreathingTechnique.presets`:
1. **Respiración 4-4-4 (Caja / Box Breathing)**: 4s inhala, 4s retén, 4s exhala (ideal para calmar la mente antes de exámenes o presentaciones).
2. **Respiración 4-7-8 (Relajante)**: 4s inhala, 7s retén, 8s exhala (estimula el sistema parasimpático para reducir ansiedad aguda o insomnio).
3. **Respiración Serena 8-7**: 8s inhala, 7s exhala (patrón original del Design Document para desconexión y pausa serena).

Cada técnica define sus guías biomecánicas textuales asociadas ("EXPANDE EL ABDOMEN", "MANTÉN LA CALMA", "LIBERA LA TENSIÓN").

---

## 4. Persistencia Offline-First del Registro de Sesión

### Context & Challenge
El tiempo invertido en la respiración debe registrarse para validar la racha de bienestar del día, funcionando tanto en modo avión como en sincronización con Cloud Firestore.

### Decision
Implementar `BreathingRepository` con `BreathingRepositoryImpl`:
- Escribe el registro en `users/{userId}/breathing_sessions/{sessionId}`.
- Si no hay conexión o se está en pruebas, opera mediante `FakeBreathingDataSource`.
- Notifica al repositorio de estado de ánimo o dashboard de que se completó una sesión consciente en la fecha actual.

---

## 5. Resumen de Decisiones Técnicas

| Aspecto | Decisión | Justificación |
| :--- | :--- | :--- |
| **Arquitectura** | Clean Architecture Feature-First (`lib/features/breathing/`) | Conforme a Constitución v1.1.0 (Principio I). |
| **Controlador** | `StateNotifier<BreathingSessionState>` con Riverpod | Desacoplamiento de lógica temporal y árbol de widgets (Principio IV). |
| **Animación** | `AnimationController` + `CustomPainter` | Rendimiento continuo garantizado a 60 fps (SC-001). |
| **Fidelidad Visual** | Mockup `mindUC - Respiracion y Relajacion.png` (paleta menta, botones de cápsula) | Conforme a Principio III. |
| **Persistencia** | Cloud Firestore + Offline Cache | Respeto a Principio IV y V. |

