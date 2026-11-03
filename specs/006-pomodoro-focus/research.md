# Research & Technical Decisions: Concentración Pomodoro & Paisajes Sonoros (006-pomodoro-focus)

**Feature Branch**: `006-pomodoro-focus`  
**Date**: 2026-11-03  
**Status**: Resolved  

---

## 1. Arquitectura de Temporizador Pomodoro y Precisión Temporal

### Decisión
Implementar un `PomodoroController` sustentado en Riverpod `StateNotifier<PomodoroState>` con `Timer.periodic(const Duration(seconds: 1))` sincronizado contra marcas de tiempo reales (`DateTime.now()`).

### Justificación
- Los temporizadores basados únicamente en `remainingSeconds--` dentro de `Timer.periodic` sufren de acumulación de retardo (clock drift) si el hilo principal de Flutter se satura o si el dispositivo entra brevemente en suspensión.
- Al almacenar la marca de finalización prevista (`expectedEndTimestamp`), cada pulso de 1 segundo recalcula `remainingSeconds = max(0, expectedEndTimestamp.difference(now).inSeconds)`. Al pausar, se almacena el remanente exacto; al reanudar, se recalcula la marca de finalización.
- Facilita pruebas unitarias deterministas inyectando duraciones controladas y controladores mock.

### Alternativas Consideradas
- **`Stopwatch`**: Mide tiempo ascendente, requiriendo lógica inversa para cuenta regresiva y dificultando la persistencia de pausas intermedias.
- **Temporizador simple decremental**: Descartado por imprecisión temporal acumulativa en sesiones largas de 25 minutos.

---

## 2. Gestión de Ciclos Pomodoro y Transición de Intervalos

### Decisión
Modelar un ciclo estructurado de 4 bloques de concentración (1 a 4):
- **Bloque de Enfoque**: 25 minutos (1500 segundos).
- **Descanso Corto**: 5 minutos (300 segundos) entre bloques 1, 2 y 3.
- **Descanso Largo**: 15 minutos (900 segundos) tras completar el bloque 4.
- Una barra segmentada de 4 cápsulas horizontales (`PomodoroCycleProgress`) refleja gráficamente:
  - Cápsulas anteriores al ciclo activo: Relleno verde completo.
  - Cápsula del ciclo activo: Relleno proporcional dinámico o verde activo.
  - Cápsulas futuras: Gris neutro tenue.

### Justificación
- Fidelidad visual absoluta al mockup `mindUC - Concentracion (Pomodoro).png` ("Ciclo 2 de 4", barra segmentada superior).
- Permite alternar manualmente el tipo de intervalo en cualquier momento a través del selector segmentado ("Enfoque", "Corto (5m)", "Largo (15m)").

---

## 3. Paisajes Sonoros (Soundscapes) y Simulación Acústica Offline-First

### Decisión
Implementar la entidad de dominio `SoundscapeTrack` y el modelo de presentación `SoundscapeState` dentro del controlador de concentración:
- Pistas de diseño:
  1. `rain`: "Lluvia campus" ("En reproducción" / "Sonido de lluvia suave en el campus San Joaquín").
  2. `cafe`: "Cafetería calma" ("Murmullo suave").
  3. `forest`: "Bosque natural" ("Natural").
- Control de reproducción conmutable (tocar para activar / tocar de nuevo para silenciar).
- Control de volumen granular reactivo mediante deslizador (0.0 a 1.0).

### Justificación
- La arquitectura preserva el principio Offline-First (Principio IV y V) sin descargas pesadas de audio de red en la fase inicial.
- Toda la capa visual, micro-interacciones de selección y respuesta de volumen quedan 100% testeadas mediante tests de widgets sin depender de códecs nativos de audio en entorno de testing de Flutter.

### Alternativas Consideradas
- **Descarga de archivos de audio desde Firebase Storage**: Descartada por latencia de red, costo y riesgo de inoperabilidad sin conexión.

---

## 4. Tratamiento del "Modo Enfoque Profundo" bajo el Principio VII de la Constitución

### Decisión
- La tarjeta de "Modo enfoque profundo" se renderiza con total fidelidad al mockup (escudo, subtítulo "3 apps silenciadas temporalmente", interruptor conmutable y chips `Instagram 🔒`, `TikTok 🔒`, `WhatsApp 🔒`).
- Conforme al **Principio VII (Diferido)** de la Constitución de mindUC (*Bloqueo Nativo de Aplicaciones a Nivel de Sistema Operativo*), el modo opera como un **Compromiso Consciente de Distracción Cero**.
- Al interactuar con el interruptor o solicitar información de la tarjeta, la interfaz proporciona retroalimentación formativa y compasiva explicando que mindUC fortalece la autorregulación voluntaria del estudiante y que el bloqueo restrictivo a nivel del SO está formalmente diferido.

### Justificación
- Respeta la máxima jerarquía técnica del proyecto (`constitution.md`), garantizando cero dependencias de APIs invasivas (`Screen Time API` o `AccessibilityService`) que comprometan la privacidad del estudiante o causen rechazos en tiendas de aplicaciones.
- Mantiene la verdad visual del diseño de Figma sin introducir deuda técnica o violaciones de permisos.

