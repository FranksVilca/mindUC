# Quickstart & Verification Guide: Diario Personal Íntimo (007-personal-journal)

**Feature Branch**: `007-personal-journal`  
**Date**: 2026-11-03  
**Status**: Ready  

---

## 1. Prerrequisitos

- Flutter SDK 3.44.x o superior con Dart 3.12.x.
- Dependencias base instaladas (`flutter pub get`).
- Rama activa: `007-personal-journal`.

---

## 2. Ejecución y Validación Automatizada

### 2.1 Análisis Estático
Asegurar ausencia total de advertencias o errores:

```bash
dart analyze
```

*Resultado Esperado*: `No issues found!`

### 2.2 Pruebas Unitarias (Controlador y Dominio)
Validar creación, edición, borrado local, sintonía de pulso emocional y cálculo de lectura:

```bash
flutter test test/unit/features/personal_journal/journal_controller_test.dart
```

*Resultado Esperado*: 100% de pruebas aprobadas (`All tests passed!`).

### 2.3 Pruebas de Widgets (Componentes y Pantalla Principal)
Validar renderizado exacto de Figma, tarjetas de huellas interiores y modales de escritura:

```bash
flutter test test/widget/features/personal_journal/emotional_pulse_selector_test.dart
flutter test test/widget/features/personal_journal/journal_entry_card_test.dart
flutter test test/widget/features/personal_journal/journal_screen_test.dart
```

*Resultado Esperado*: 100% de pruebas aprobadas sin desbordamientos de layout.

### 2.4 Suite Completa de Pruebas
Verificar la ausencia de regresiones en funcionalidades previas (001 a 006):

```bash
flutter test
```

---

## 3. Guía de Verificación Manual (Flujo de Usuario)

1. **Acceso desde el Hub de Bienestar**:
   - Abrir la app y pulsar en la pestaña "Bienestar".
   - En la cuadrícula 2x2, pulsar la tarjeta "Diario personal".
   - *Verificación*: Transición inmediata a "Mi Diario Personal".
2. **Inspección Visual de la Pantalla**:
   - Comprobar cabecera "mindUC" con subtítulo "Minduc — Diario Personal".
   - Comprobar la insignia "ESPACIO SAGRADO", título "Mi Diario Personal", y banner de privacidad con icono de candado.
3. **Sintonización Emocional**:
   - En la tarjeta "¿Cómo late tu corazón hoy?", pulsar sobre "Agradecida" o "Reflexiva".
   - *Verificación*: La emoción seleccionada se destaca con acento botánico de forma reactiva.
4. **Lectura de Huellas Interiores**:
   - Revisar la sección "Tus huellas interiores" (contador "3 entradas").
   - Comprobar las 3 tarjetas de muestra de Figma: "Aprender a soltar lo que no puedo controlar", "Caminata bajo el sol matutino" y "Mi primer paso diciendo que no", cada una con su fecha, extracto, badge y "🔒 Solo visible en este teléfono".
5. **Creación de Nueva Reflexión**:
   - Tocar el botón lavanda "+ Nueva entrada reflexiva".
   - Completar título (ej. "Tarde de estudio serena") y texto reflexivo.
   - Presionar "Guardar reflexión".
   - *Verificación*: La nueva entrada aparece de inmediato al inicio de la lista y el contador sube a "4 entradas".
6. **Edición y Eliminación**:
   - Tocar el lápiz de edición en una tarjeta: permite modificar el texto y persistir los cambios.
   - Tocar el menú `⋮` y seleccionar eliminar: borra la tarjeta tras confirmación compasiva.
