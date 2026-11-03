# UI Contract: 004-breathing-relaxation

**Feature**: 004-breathing-relaxation  
**Date**: 2026-11-02  
**Interface Type**: Flutter Widget UI Contract & Riverpod State Specification  

---

## 1. Contrato del Controlador: `BreathingSessionNotifier`

```dart
abstract class BreathingSessionControllerContract {
  /// Inicia o reanuda el ciclo de respiración guiada.
  void playOrPause();

  /// Reinicia la sesión al segundo 0 del ciclo 1.
  void resetSession();

  /// Detiene y finaliza la sesión activa.
  Future<void> stopSession();

  /// Cambia la técnica de respiración activa recalculando fases y ciclos.
  void setTechnique(BreathingTechnique technique);

  /// Selecciona la duración objetivo en segundos (180, 300, 600, o 0 para Modo Libre).
  void setTargetDuration(int targetSeconds);
}
```

---

## 2. Contrato de Componentes Visuales

### 2.1 `BreathingCircleVisualizer`
- **Propósito**: Visualizador central circular pulsante con arco perimetral de progreso, texto de fase, temporizador de fase y guía biomecánica corporal.
- **Inputs**:
  - `BreathingPhase phase`: Fase en curso (`inhale`, `hold`, `exhale`, `rest`).
  - `int secondsRemaining`: Segundos restantes en la fase activa.
  - `double phaseProgressFraction`: Fracción de avance de la fase actual (0.0 a 1.0).
  - `bool isRunning`: Si la animación debe estar activa o en pausa.

### 2.2 `TechniqueSelectorRow`
- **Propósito**: Barra superior con el dropdown de técnica a la izquierda y el contador de ciclos a la derecha.
- **Inputs**:
  - `BreathingTechnique currentTechnique`: Técnica activa.
  - `int currentCycle`: Ciclo actual.
  - `int totalCycles`: Total de ciclos calculados para la duración.
  - `ValueChanged<BreathingTechnique> onTechniqueChanged`: Callback al elegir técnica.

### 2.3 `SessionProgressCard`
- **Propósito**: Tarjeta con icono de temporizador, tiempo restante ("07:43 / 10:00") y barra lineal de avance.
- **Inputs**:
  - `int elapsedSeconds`: Segundos transcurridos.
  - `int targetSeconds`: Meta en segundos (0 si es libre).
  - `double progressFraction`: Fracción de progreso total (0.0 a 1.0).

### 2.4 `BreathingControlsRow`
- **Propósito**: Fila de 3 botones de control (Reiniciar, Botón principal cápsula "Pausar/Iniciar sesión", Detener).
- **Inputs**:
  - `bool isRunning`: Determina si el botón central muestra pausa o play.
  - `VoidCallback onReset`: Callback de reinicio.
  - `VoidCallback onPlayPause`: Callback de play/pausa.
  - `VoidCallback onStop`: Callback de finalización.

### 2.5 `DurationPresetsPill`
- **Propósito**: Cápsula inferior segmentada con "3 min", "5 min", "10 min", "Libre".
- **Inputs**:
  - `int currentTargetSeconds`: Duración actual.
  - `ValueChanged<int> onPresetSelected`: Callback con la nueva duración en segundos.
