# Quickstart: 010-progress-gamification

## Objetivo
Guía rápida para verificar e interactuar con el módulo de Progreso & Florecimiento de mindUC acorde al diseño de Figma (`mindUC - Progreso y Gamificacion.png`).

---

## 1. Verificación Automatizada

### Pruebas Unitarias del Controlador
```bash
flutter test test/unit/features/progress_gamification/progress_controller_test.dart
```
Verifica:
- Carga inicial de datos mock de Figma (7 días, 4 pausas, 4 logros, 3 intenciones).
- Avance interactivo y conmutación de intenciones semanales.
- Ratios de progreso correctos y conteo de logros florecidos (`3 de 4`).

### Pruebas de Widgets y Componentes
```bash
flutter test test/widget/features/progress_gamification/progress_cards_test.dart
```
Verifica:
- Renderizado de `ActiveStreakCard` con franja `L M X J V S D`.
- Renderizado de `WeeklyPauseGrid` con las 4 tarjetas de métricas.
- Renderizado de `AchievementsGarden` con insignias `"✓ Florecida"`.
- Renderizado de `SelfCompassionCard`.

### Pruebas de Integración de Pantalla
```bash
flutter test test/widget/features/progress_gamification/progress_screen_test.dart
```
Verifica:
- Renderizado completo de `ProgressScreen`.
- Desplazamiento y layout sin desbordamientos de renderizado.
- Interacción de marcado en una intención semanal.
- Retorno con el botón de la cabecera.

---

## 2. Verificación Manual en la Aplicación

1. **Acceso desde Inicio**:
   - Abrir la aplicación en la pestaña "Inicio".
   - Tocar la tarjeta de acceso rápido `"Mi progreso"`.
   - Verificar la navegación fluida hacia `/progress`.
2. **Revisión de Racha y Momentos de Pausa**:
   - Comprobar la tarjeta de racha activa: `"7 días consecutivos"` y los brotes de la semana.
   - Constatar los 4 bloques: `145 min`, `12 sesiones`, `9 reflexiones`, `85%`.
3. **Exploración de Logros**:
   - Verificar las 3 tarjetas florecidas: *Semilla de Paz*, *Mente Serena*, *Voz Auténtica*.
   - Verificar el logro en progreso: *Foco Lúcido* (`4h de 5h (80%)`).
4. **Interacción con Intenciones**:
   - Tocar una de las metas amables (ej. `"Tomar un paseo consciente"`).
   - Observar el avance reactivo del contador y la barra.
5. **Cierre Compasivo**:
   - Leer la cita al pie: *“El progreso no es lineal; cada pausa que te das cuenta como una victoria auténtica.”*.
   - Presionar `<` para volver a la pantalla de Inicio.
