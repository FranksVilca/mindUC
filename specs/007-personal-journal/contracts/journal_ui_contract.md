# UI Contract & Controller Specification: Diario Personal Íntimo (007-personal-journal)

**Feature Branch**: `007-personal-journal`  
**Date**: 2026-11-03  
**Status**: Ready  

---

## 1. Contrato de Ruta y Navegación

| Propiedad | Valor |
| :--- | :--- |
| **Ruta GoRouter Principal** | `AppRoutes.journalNew` (`/journal/new` o `/journal`) |
| **Entradas de Acceso** | 1. `WellnessToolsGrid` (tarjeta 2x2 "Diario personal").<br>2. Acceso directo por enlace. |
| **Salidas de Navegación** | 1. Botón de retroceso (`<` en AppBar o botón superior) invoca `context.pop()`. |

---

## 2. Contrato de Notifier / Controlador (`JournalNotifier`)

Inyectable mediante el provider global `journalControllerProvider`.

```dart
abstract class IJournalController {
  /// Selecciona el pulso emocional del día
  void selectMoodPulse(JournalMoodPulse pulse);

  /// Crea y persiste localmente una nueva entrada reflexiva
  Future<void> createEntry({
    required String title,
    required String content,
    JournalMoodPulse? moodPulse,
  });

  /// Actualiza una entrada reflexiva existente
  Future<void> updateEntry({
    required String id,
    required String title,
    required String content,
    required JournalMoodPulse moodPulse,
  });

  /// Elimina una entrada reflexiva del almacenamiento local
  Future<void> deleteEntry(String id);
}
```

---

## 3. Contratos de Widgets Específicos

### 3.1 `JournalHeader`
- **Props**:
  - `VoidCallback? onBack`: Callback para regresar.
  - `VoidCallback? onNotification`: Callback para ver notificaciones.
  - `VoidCallback? onProfile`: Callback para abrir perfil.
- **Renderiza**:
  - Logo "mindUC", subtítulo "Minduc — Diario Personal", campana con indicador y avatar de usuario.

### 3.2 `JournalPrivacyBanner`
- **Props**: Ninguno (estático).
- **Renderiza**:
  - Insignia circular "ESPACIO SAGRADO".
  - Título principal "Mi Diario Personal".
  - Banner verde claro / beige con icono de candado y texto: "🔒 Un espacio solo para ti. Tus pensamientos están protegidos y cifrados en tu dispositivo 🔒".

### 3.3 `EmotionalPulseSelector`
- **Props**:
  - `JournalMoodPulse selectedPulse`: Emoción activa.
  - `ValueChanged<JournalMoodPulse> onPulseSelected`: Callback al tocar una emoción.
- **Renderiza**:
  - Tarjeta blanca con título "¿Cómo late tu corazón hoy?" y subtítulo "Sintoniza tu sentir".
  - Fila horizontal de 5 botones de pulso ("Agradecida", "En calma", "Reflexiva", "Cansada", "Abrumada") con fondo verde activo en la seleccionada.

### 3.4 `JournalEntryCard`
- **Props**:
  - `JournalEntry entry`: Entrada a visualizar.
  - `VoidCallback onEdit`: Callback para editar.
  - `VoidCallback onDelete`: Callback para eliminar.
- **Renderiza**:
  - Chip con icono y etiqueta de emoción (ej. `🌸 En calma`).
  - Fecha formateada en español.
  - Iconos de acción: lápiz de edición y menú de tres puntos (`⋮`).
  - Título reflexivo en negrita.
  - Extracto del contenido (2 líneas con puntos suspensivos).
  - Pie con indicador "🔒 Solo visible en este teléfono" y tiempo de lectura (ej. "2 min de lectura").

### 3.5 `JournalEntryEditModal`
- **Props**:
  - `JournalEntry? existingEntry`: Entrada existente para edición o null para nueva entrada.
  - `JournalMoodPulse defaultPulse`: Emoción por defecto.
  - `void Function(String title, String content, JournalMoodPulse pulse) onSave`: Callback al guardar.
- **Renderiza**:
  - Título ("Nueva entrada reflexiva" o "Editar reflexión").
  - Selector de emoción.
  - Campo de texto para título.
  - Área de texto para contenido reflexivo.
  - Botones "Cancelar" y "Guardar reflexión".

