# Quickstart & Verification Guide: 008-agenda-calendar

## Overview
Esta guía proporciona las instrucciones para verificar y probar el funcionamiento del módulo `008-agenda-calendar` tanto en pruebas automatizadas como en ejecución local interactiva.

---

## 1. Verificación Automatizada

### Pruebas Unitarias del Controlador y Entidades
Ejecuta la suite de pruebas unitarias para `AgendaNotifier` y `AgendaActivity`:
```bash
flutter test test/unit/features/agenda/agenda_controller_test.dart
```

### Pruebas de Widgets y Componentes Visuales
Ejecuta las pruebas de componentes y tira semanal:
```bash
flutter test test/widget/features/agenda/weekly_day_strip_test.dart
flutter test test/widget/features/agenda/activity_card_test.dart
flutter test test/widget/features/agenda/activity_create_modal_test.dart
```

### Pruebas de Integración de Pantalla Completa
Ejecuta las pruebas de la pantalla completa `AgendaScreen`:
```bash
flutter test test/widget/features/agenda/agenda_screen_test.dart
```

### Verificación de Calidad y Análisis Estático
Asegura que el proyecto cumpla con los estándares de la Constitución sin advertencias:
```bash
dart analyze
flutter test
```

---

## 2. Flujo de Verificación Manual

1. **Navegación al Shell**:
   - Inicia la aplicación y pulsa la Pestaña 2 del menú inferior ("Agenda").
2. **Inspección Visual de Alta Fidelidad**:
   - Verifica la cabecera con logo `mindUC`, subtítulo `Agenda`, campana y avatar.
   - Verifica el título `Mi Agenda consciente`, la fecha y el indicador `Semana 43`.
   - Verifica la tira semanal de 7 días con el día activo destacado con borde y fondo menta suave.
   - Verifica la tarjeta `Ritmo en equilibrio` con `4 actividades · 2 completadas`.
   - Verifica los filtros `Todas`, `Autocuidado` y `Estudio / Trabajo`.
   - Verifica las 4 tarjetas de actividades iniciales con sus respectivas categorías y estados de tachado.
3. **Interacción de Estado**:
   - Toca el círculo de la actividad `Caminata al aire libre sin pantallas`: debe marcarse como completada (`✓`), su texto debe tacharse suavemente y la tarjeta debe mostrar `4 actividades · 3 completadas`.
4. **Filtrado por Categoría**:
   - Toca `Autocuidado`: solo deben aparecer las actividades de autocuidado.
   - Toca `Todas`: deben volver a mostrarse todas las actividades.
5. **Creación de Nueva Actividad**:
   - Pulsa el botón flotante `+ Nueva`.
   - Ingresa un título (ej. "Revisión de textos con té de manzanilla"), selecciona horario y categoría.
   - Pulsa "Guardar actividad": la nueva actividad debe aparecer inmediatamente en la lista y el conteo de actividades debe incrementarse.
