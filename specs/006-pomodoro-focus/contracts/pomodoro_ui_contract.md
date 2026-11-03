# UI Contract & Controller Specification: Concentración Pomodoro (006-pomodoro-focus)

**Feature Branch**: `006-pomodoro-focus`  
**Date**: 2026-11-03  
**Status**: Ready  

---

## 1. Contrato de Ruta y Navegación

| Propiedad | Valor |
| :--- | :--- |
| **Ruta GoRouter** | `AppRoutes.pomodoroSession` (`/pomodoro-session`) |
| **Entradas de Acceso** | 1. `WellnessToolsGrid` (tarjeta 2x2 "Concentración").<br>2. Navegación directa o enlace de recomendación diaria. |
| **Salidas de Navegación** | 1. Botón de retroceso (`<` en cabecera) invoca `context.pop()`. |

---

## 2. Contrato de Notifier / Controlador (`PomodoroNotifier`)

El controlador hereda de `StateNotifier<PomodoroState>` y se inyecta mediante el provider global `pomodoroControllerProvider`.

```dart
abstract class IPomodoroController {
  /// Inicia o reanuda la cuenta regresiva del intervalo activo
  void startTimer();

  /// Pausa la cuenta regresiva del intervalo activo
  void pauseTimer();

  /// Alterna entre iniciar y pausar
  void toggleTimer();

  /// Reinicia el intervalo activo a su duración inicial completa
  void resetInterval();

  /// Salta al siguiente intervalo (Enfoque <-> Descanso) actualizando ciclos
  void skipInterval();

  /// Cambia manualmente el tipo de intervalo seleccionado
  void selectIntervalType(PomodoroIntervalType type);

  /// Actualiza el objetivo académico asociado
  void updateObjective(String newObjective);

  /// Selecciona una pista de ambiente sonoro o conmuta su reproducción si ya estaba seleccionada
  void toggleSoundscapeTrack(String trackId);

  /// Modifica el volumen del ambiente sonoro (0.0 a 1.0)
  void setSoundscapeVolume(double volume);

  /// Conmuta el estado del Modo Enfoque Profundo (Compromiso Consciente)
  void toggleDeepFocus(bool enabled);
}
```

---

## 3. Contratos de Widgets Específicos

### 3.1 `PomodoroHeader`
- **Props**:
  - `VoidCallback? onBack`: Invocado al presionar `<`.
  - `VoidCallback? onOptions`: Invocado al presionar `⋮`.
- **Renderiza**:
  - Botón de retroceso IconButton.
  - Columna con título "Minduc — Concentración (Pomodoro)" y subtítulo "mindUC".
  - Botón de opciones IconButton.

### 3.2 `PomodoroCycleProgress`
- **Props**:
  - `String sessionTitle`: e.g. `"Sesión de la tarde"`.
  - `int currentCycle`: e.g. `2`.
  - `int totalCycles`: e.g. `4`.
- **Renderiza**:
  - Fila superior: badge verde claro con icono botánico + título de sesión a la izquierda; badge gris con "Ciclo X de Y" a la derecha.
  - Fila inferior: 4 cápsulas horizontales segmentadas que reflejan el estado de cada ciclo.

### 3.3 `IntervalSelectorRow`
- **Props**:
  - `PomodoroIntervalType selectedType`: Intervalo activo.
  - `ValueChanged<PomodoroIntervalType> onTypeSelected`: Callback al pulsar una opción.
- **Renderiza**:
  - Fila segmentada con cápsula destacada blanca con sombra para la opción activa y gris transparente para las inactivas ("Enfoque", "Corto (5m)", "Largo (15m)").

### 3.4 `PomodoroTimerCard`
- **Props**:
  - `String objective`: Título del objetivo actual.
  - `VoidCallback onEditObjective`: Callback para editar el objetivo.
  - `PomodoroState state`: Estado actual del temporizador.
  - `VoidCallback onToggle`: Callback de iniciar/pausar.
  - `VoidCallback onReset`: Callback de reinicio (`↺`).
  - `VoidCallback onSkip`: Callback de saltar intervalo (`>|`).
- **Renderiza**:
  - Subtarjeta de objetivo con icono de marcapáginas y botón lápiz.
  - Cronómetro circular con arco de progreso verde (`MindColors.primary`), etiqueta "Bloque activo", tiempo digital (e.g. `18:41`) y duración total (e.g. `de 25:00 min`).
  - Fila inferior de controles: botón de reinicio circular, botón píldora verde "Pausar enfoque" / "Iniciar enfoque", y botón circular de salto.

### 3.5 `SoundscapeSection`
- **Props**:
  - `List<SoundscapeTrack> tracks`: Lista de paisajes sonoros.
  - `String? selectedTrackId`: ID del sonido activo.
  - `bool isPlaying`: Si el sonido está reproduciéndose.
  - `double volume`: Nivel de volumen.
  - `ValueChanged<String> onTrackSelected`: Callback al tocar una tarjeta de sonido.
  - `ValueChanged<double> onVolumeChanged`: Callback al deslizar el volumen.
- **Renderiza**:
  - Título con icono de ondas `||||`, texto "Ambiente sonoro" y badge "Audio relajante".
  - Fila horizontal desplazable de tarjetas ("Lluvia campus", "Cafetería calma", "Bosque natural").
  - Barra de deslizamiento (Slider) de volumen flanqueada por altavoces.

### 3.6 `DeepFocusCard`
- **Props**:
  - `bool isEnabled`: Estado del switch.
  - `ValueChanged<bool> onToggle`: Callback de alternancia.
  - `VoidCallback? onLearnMore`: Diálogo formativo compasivo según Principio VII.
- **Renderiza**:
  - Icono de escudo, título "Modo enfoque profundo", subtítulo "3 apps silenciadas temporalmente".
  - Switch verde activo/gris inactivo.
  - Chips de badges (`Instagram 🔒`, `TikTok 🔒`, `WhatsApp 🔒`).
