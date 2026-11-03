# Research & Technical Decisions: Diario Personal Íntimo (007-personal-journal)

**Feature Branch**: `007-personal-journal`  
**Date**: 2026-11-03  
**Status**: Resolved  

---

## 1. Almacenamiento Local Protegido y Soberanía de Datos (Principio V)

### Decisión
Implementar un repositorio desacoplado `JournalRepository` con implementación exclusivamente local (`LocalJournalRepositoryImpl`) y fuente de datos local (`LocalJournalDataSource`).
- Toda reflexión, pulso emocional y marca temporal se procesa y persiste estrictamente en el dispositivo del estudiante.
- No se realiza ninguna solicitud de red HTTP, WebSocket ni sincronización con Firebase Cloud Firestore.
- Se deja preparada la interfaz de cifrado para almacenamiento seguro en reposo (`flutter_secure_storage` / AES local).

### Justificación
- El **Principio V** de la Constitución de mindUC (*Privacidad por Diseño, Seguridad y Soberanía del Usuario*) establece de forma explícita que las reflexiones del diario personal jamás deben sincronizarse en servidores externos sin consentimiento, protegiendo la intimidad del estudiante.
- Cumple con la etiqueta explícita de Figma: *"🔒 Solo visible en este teléfono"*.
- Garantiza funcionamiento 100% Offline-First sin latencia.

### Alternativas Consideradas
- **Sincronización remota con Cloud Firestore**: Descartada de raíz por colisión frontal con el Principio V de la Constitución.

---

## 2. Modelado y Comportamiento del Pulso Emocional

### Decisión
Modelar `JournalMoodPulse` como un Value Object / Enum con 5 estados:
1. `agradecida`: Etiqueta "Agradecida", icono de destellos/estrellas, fondo verde/amarillo suave.
2. `enCalma`: Etiqueta "En calma", icono de flor rosa, fondo verde salvia claro (`MindColors.bienestarPill`).
3. `reflexiva`: Etiqueta "Reflexiva", icono de brote/planta, fondo lavanda suave.
4. `cansada`: Etiqueta "Cansada", icono de nube, fondo gris suave.
5. `abrumada`: Etiqueta "Abrumada", icono de ola marina, fondo coral/melocotón suave.

### Justificación
- Fidelidad visual absoluta a la tarjeta "¿Cómo late tu corazón hoy?" de Figma.
- Facilita la clasificación emocional inmediata de las huellas interiores.

---

## 3. Estimación del Tiempo de Lectura

### Decisión
Implementar un getter calculado `readingTimeMinutes`:
```dart
int get readingTimeMinutes {
  final words = content.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
  final minutes = (words / 180).ceil();
  return minutes > 0 ? minutes : 1;
}
```

### Justificación
- Refleja de forma precisa las etiquetas "2 min de lectura" y "1 min de lectura" observadas en los mockups de Figma.
- Cálculo determinista, ligero y sin dependencias de librerías externas.

---

## 4. Estrategia de Formateo de Fechas en Español

### Decisión
Reutilizar `SpanishDateFormatter` (validado y testeado en `001-core-foundation`) para formatear fechas relativas ("Hoy, 24 Octubre · 21:15", "Ayer, 23 Octubre · 08:30", "Lunes, 21 Octubre").

### Justificación
- Elimina duplicación de código y asegura consistencia lingüística en toda la app mindUC.

