# UI Contract: 003-home-dashboard

**Feature**: 003-home-dashboard  
**Date**: 2026-11-02  
**Interface Type**: Flutter Widget UI Contract & Riverpod State Specification  

---

## 1. Interfaz de Estado: `HomeDashboardState`

```dart
class HomeDashboardState {
  final bool isLoading;
  final String? errorMessage;
  final DashboardSummary summary;
  final MoodType? selectedMood;
  final bool isSavingMood;

  const HomeDashboardState({
    this.isLoading = false,
    this.errorMessage,
    required this.summary,
    this.selectedMood,
    this.isSavingMood = false,
  });

  HomeDashboardState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    DashboardSummary? summary,
    MoodType? selectedMood,
    bool? isSavingMood,
  });
}
```

---

## 2. Contrato de Notifier: `HomeDashboardNotifier`

```dart
abstract class HomeDashboardControllerContract {
  /// Carga inicial del resumen del dashboard (usuario, fecha, tareas pendientes, racha).
  Future<void> loadDashboard();

  /// Registra o actualiza el estado de ánimo seleccionado con un solo toque.
  Future<bool> selectMood(MoodType mood);

  /// Limpia posibles errores.
  void clearError();
}
```

---

## 3. Contrato de Componentes Visuales (Widgets)

### 3.1 `HomeHeader`
- **Propósito**: Muestra la marca centrada `mindUC` con subtítulo `Inicio`, campana de alertas a la derecha y avatar del usuario.
- **Inputs**:
  - `String? userDisplayName`: Nombre completo o de pila del usuario.
  - `VoidCallback? onNotificationPressed`: Callback al pulsar la campana.
  - `VoidCallback? onAvatarPressed`: Callback al pulsar el avatar.

### 3.2 `DatePill`
- **Propósito**: Renderiza la cápsula con icono de calendario y fecha en español (`Jueves, 24 de Octubre`).
- **Inputs**:
  - `String formattedDate`: Texto de fecha generado.

### 3.3 `MoodSelectorRow`
- **Propósito**: Fila horizontal de 5 tarjetas emocionales amables (Calma, Feliz, Ansiosa, Cansada, Enérgica) con selección táctil instantánea.
- **Inputs**:
  - `MoodType? selectedMood`: Estado de ánimo actualmente activo.
  - `ValueChanged<MoodType> onMoodSelected`: Callback al pulsar un estado.
  - `bool isSaving`: Indicador de si se está persistiendo el cambio.

### 3.4 `QuickAccessGrid`
- **Propósito**: Cuadrícula de 2x2 para las tarjetas "Relajación", "Agenda", "Comunidad" y "Mi progreso".
- **Inputs**:
  - `List<QuickAccessItem> items`: Lista de los 4 elementos descriptores.
  - `ValueChanged<QuickAccessItem> onItemTapped`: Callback de navegación.
