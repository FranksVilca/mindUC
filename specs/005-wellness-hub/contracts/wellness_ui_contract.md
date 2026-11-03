# UI Contract: 005-wellness-hub

**Feature**: 005-wellness-hub  
**Date**: 2026-11-02  
**Interface Type**: Flutter Widget UI Contract & Riverpod State Specification  

---

## 1. Contratos de Componentes Visuales

### 1.1 `WellnessHeader`
- **Propósito**: Cabecera superior según `mindUC - Bienestar.png`.
- **Inputs**:
  - `VoidCallback? onNotificationTap`: Acción al pulsar la campana.
  - `VoidCallback? onProfileTap`: Acción al pulsar el avatar.

### 1.2 `SanctuaryBadge`
- **Propósito**: Píldora botánica de modo santuario (`🌱 SANCTUARY MODE`).
- **Inputs**:
  - `String label`: Texto de la insignia (por defecto `'SANCTUARY MODE'`).
  - `bool isEnabled`: Si el modo está encendido.

### 1.3 `SuggestedExerciseCard`
- **Propósito**: Tarjeta destacada del ejercicio sugerido diario.
- **Inputs**:
  - `WellnessSuggestedExercise exercise`: Entidad con datos del ejercicio.
  - `VoidCallback onStart`: Callback al tocar `▶ Comenzar (5 min)`.
- **Efecto**: Dispara la navegación directa a la sesión de respiración relajante.

### 1.4 `WellnessToolsGrid`
- **Propósito**: Cuadrícula de 2 columnas por 2 filas de herramientas de autocuidado.
- **Inputs**:
  - `List<WellnessToolItem> tools`: Lista de las 4 herramientas.
  - `ValueChanged<WellnessToolItem> onToolTap`: Callback al pulsar cualquiera de las tarjetas.

### 1.5 `AiAssistantComingSoonDialog`
- **Propósito**: Diálogo compasivo y sereno que informa que el Asistente IA está en preparación ética comunitaria (cumplimiento del Principio VI).
- **Inputs**:
  - `VoidCallback onDismiss`: Cierra el diálogo.

---

## 2. Contrato del Controlador Riverpod: `WellnessController`

```dart
abstract class WellnessControllerContract {
  /// Inicia el ejercicio de respiración sugerido precargando la técnica 4-7-8 y 5 min.
  void startSuggestedExercise(BuildContext context);

  /// Gestiona la navegación de la tarjeta seleccionada de la cuadrícula.
  void onToolSelected(BuildContext context, WellnessToolItem tool);
}
```
