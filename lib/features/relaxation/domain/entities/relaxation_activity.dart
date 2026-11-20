import 'package:flutter/material.dart';
import '../../../../core/theme/mind_colors.dart';
import 'relaxation_step.dart';

/// Entidad inmutable que representa una actividad completa de relajación o pausa activa.
class RelaxationActivity {
  final String id;
  final String name;
  final String category;
  final String targetArea;
  final String benefit;
  final int totalDurationSeconds;
  final String estimatedDurationText;
  final IconData icon;
  final Color accentColor;
  final List<RelaxationStep> steps;
  final bool isCompletedToday;
  final int completionsCount;

  const RelaxationActivity({
    required this.id,
    required this.name,
    required this.category,
    required this.targetArea,
    required this.benefit,
    required this.totalDurationSeconds,
    required this.estimatedDurationText,
    required this.icon,
    required this.accentColor,
    required this.steps,
    this.isCompletedToday = false,
    this.completionsCount = 0,
  });

  RelaxationActivity copyWith({
    bool? isCompletedToday,
    int? completionsCount,
  }) {
    return RelaxationActivity(
      id: id,
      name: name,
      category: category,
      targetArea: targetArea,
      benefit: benefit,
      totalDurationSeconds: totalDurationSeconds,
      estimatedDurationText: estimatedDurationText,
      icon: icon,
      accentColor: accentColor,
      steps: steps,
      isCompletedToday: isCompletedToday ?? this.isCompletedToday,
      completionsCount: completionsCount ?? this.completionsCount,
    );
  }

  /// Catálogo oficial con las 4 rutinas guiadas de mindUC.
  static const List<RelaxationActivity> defaultActivities = [
    // 1. Estiramiento de cuello
    RelaxationActivity(
      id: 'neck_stretch',
      name: 'Estiramiento de cuello',
      category: 'Pausa Cervical',
      targetArea: 'Cuello y trapecio',
      benefit: 'Libera la rigidez acumulada en la base cervical tras horas de estudio continuo.',
      totalDurationSeconds: 120,
      estimatedDurationText: '2 minutos',
      icon: Icons.accessibility_new_rounded,
      accentColor: MindColors.primary,
      steps: [
        RelaxationStep(
          stepNumber: 1,
          title: 'Inclinación lateral derecha',
          instruction: 'Inclina suavemente la cabeza hacia el hombro derecho, sintiendo cómo se estira el lado izquierdo del cuello.',
          ergonomicTip: 'Mantén los hombros bajos y relajados; no levantes el hombro derecho hacia la oreja.',
          durationSeconds: 25,
          bodyPartFocus: 'Cuello lateral izquierdo y trapecio',
          movementDirection: 'Hacia el hombro derecho',
          visualType: RelaxationVisualType.neckRight,
        ),
        RelaxationStep(
          stepNumber: 2,
          title: 'Sostén consciente',
          instruction: 'Mantén la posición con suavidad, inhalando y exhalando profundamente para liberar tensión.',
          ergonomicTip: 'Respira de manera fluida; no apliques fuerza con la mano ni generes dolor.',
          durationSeconds: 20,
          bodyPartFocus: 'Fibras musculares del trapecio superior',
          movementDirection: 'Sostén estático sereno',
          visualType: RelaxationVisualType.neckHold,
        ),
        RelaxationStep(
          stepNumber: 3,
          title: 'Retorno al centro',
          instruction: 'Regresa lentamente la cabeza a la posición neutra central alineando tu mirada al frente.',
          ergonomicTip: 'Mueve el cuello de manera pausada y controlada, evitando tirones bruscos.',
          durationSeconds: 15,
          bodyPartFocus: 'Eje vertical de la columna cervical',
          movementDirection: 'Regreso al centro vertical',
          visualType: RelaxationVisualType.neckCenter,
        ),
        RelaxationStep(
          stepNumber: 4,
          title: 'Inclinación lateral izquierda',
          instruction: 'Inclina con delicadeza la cabeza hacia el hombro izquierdo, dejando que el peso suave abra el lateral derecho.',
          ergonomicTip: 'Asegúrate de que la espalda permanezca erguida y apoyada en el respaldo.',
          durationSeconds: 30,
          bodyPartFocus: 'Cuello lateral derecho y trapecio',
          movementDirection: 'Hacia el hombro izquierdo',
          visualType: RelaxationVisualType.neckLeft,
        ),
        RelaxationStep(
          stepNumber: 5,
          title: 'Movilidad y semicírculos suaves',
          instruction: 'Realiza movimientos circulares lentos de lado a lado por delante del pecho, sin forzar nunca el cuello hacia atrás.',
          ergonomicTip: 'Imagina que dibujas una sonrisa suave con tu mentón sobre el esternón.',
          durationSeconds: 30,
          bodyPartFocus: 'Movilidad articular cervical global',
          movementDirection: 'Semicírculos suaves de hombro a hombro',
          visualType: RelaxationVisualType.neckMobility,
        ),
      ],
    ),

    // 2. Estiramiento de espalda
    RelaxationActivity(
      id: 'back_stretch',
      name: 'Estiramiento de espalda',
      category: 'Higiene Postural',
      targetArea: 'Columna y hombros',
      benefit: 'Descomprime las vértebras lumbares y dorsales para recuperar una postura erguida y natural.',
      totalDurationSeconds: 180,
      estimatedDurationText: '3 minutos',
      icon: Icons.airline_seat_recline_normal_rounded,
      accentColor: Color(0xFF6B62A8),
      steps: [
        RelaxationStep(
          stepNumber: 1,
          title: 'Alineación de base sentada',
          instruction: 'Siéntate erguido con la espalda despegada del respaldo y apoya ambos pies planos sobre el piso.',
          ergonomicTip: 'Distribuye tu peso por igual en ambos isquiones para estabilizar la pelvis.',
          durationSeconds: 30,
          bodyPartFocus: 'Pelvis neutra y columna lumbar',
          movementDirection: 'Enraizamiento vertical hacia abajo',
          visualType: RelaxationVisualType.backSit,
        ),
        RelaxationStep(
          stepNumber: 2,
          title: 'Extensión axial hacia arriba',
          instruction: 'Entrelaza los dedos de las manos y estira suavemente los brazos hacia el cielo alargando toda la espalda.',
          ergonomicTip: 'Inhala profundamente mientras imaginas que creces un centímetro hacia el techo.',
          durationSeconds: 35,
          bodyPartFocus: 'Dorsales anchos, hombros y caja torácica',
          movementDirection: 'Extensión vertical hacia el cielo',
          visualType: RelaxationVisualType.backReach,
        ),
        RelaxationStep(
          stepNumber: 3,
          title: 'Flexión suave hacia adelante',
          instruction: 'Inclina ligeramente el tronco hacia adelante doblando desde las caderas, apoyando el abdomen en los muslos.',
          ergonomicTip: 'Suelta la cabeza y los brazos hacia el suelo; permite que la gravedad abra tus vértebras.',
          durationSeconds: 40,
          bodyPartFocus: 'Descompresión lumbar y paravertebrales',
          movementDirection: 'Inclinación suave hacia el frente',
          visualType: RelaxationVisualType.backFold,
        ),
        RelaxationStep(
          stepNumber: 4,
          title: 'Extensión y apertura torácica',
          instruction: 'Lleva las manos a la zona lumbar o al respaldo de la silla y proyecta suavemente el esternón hacia arriba.',
          ergonomicTip: 'Abre el pecho sin arquear excesivamente la zona lumbar ni colapsar el cuello.',
          durationSeconds: 45,
          bodyPartFocus: 'Pectorales y erectores dorsales',
          movementDirection: 'Apertura torácica hacia atrás',
          visualType: RelaxationVisualType.backExtend,
        ),
        RelaxationStep(
          stepNumber: 5,
          title: 'Relajación de hombros y retorno',
          instruction: 'Regresa a la postura inicial, realiza un círculo suave con los hombros hacia atrás y déjalos caer en reposo.',
          ergonomicTip: 'Siente la ligereza en tu espalda y exhala completamente el aire residual.',
          durationSeconds: 30,
          bodyPartFocus: 'Cintura escapular y trapecios',
          movementDirection: 'Descenso y relajación de hombros',
          visualType: RelaxationVisualType.backRelax,
        ),
      ],
    ),

    // 3. Automasajes de mandíbula
    RelaxationActivity(
      id: 'jaw_massage',
      name: 'Automasajes de mandíbula',
      category: 'Alivio Miofascial',
      targetArea: 'Mandíbula y rostro',
      benefit: 'Disminuye la tensión en la articulación temporomandibular (ATM) y alivia el apretamiento dental por estrés.',
      totalDurationSeconds: 120,
      estimatedDurationText: '2 minutos',
      icon: Icons.face_retouching_natural_rounded,
      accentColor: Color(0xFFC76454),
      steps: [
        RelaxationStep(
          stepNumber: 1,
          title: 'Relajación facial y boca entreabierta',
          instruction: 'Relaja los músculos de tu rostro y mantén la boca ligeramente entreabierta sin juntar los dientes.',
          ergonomicTip: 'Permite que la lengua descanse en el piso de la boca sin presionar el paladar.',
          durationSeconds: 20,
          bodyPartFocus: 'Músculos peribucales y articulación mandibular',
          movementDirection: 'Apertura y distensión pasiva',
          visualType: RelaxationVisualType.jawRelax,
        ),
        RelaxationStep(
          stepNumber: 2,
          title: 'Localización de músculos maseteros',
          instruction: 'Ubica las yemas de tus dedos índice y medio justo delante de las orejas, bajo los pómulos.',
          ergonomicTip: 'Aprieta levemente los dientes para sentir la contracción del músculo y luego relaja por completo.',
          durationSeconds: 20,
          bodyPartFocus: 'Músculo masetero superficial',
          movementDirection: 'Apoyo táctil consciente',
          visualType: RelaxationVisualType.jawLocate,
        ),
        RelaxationStep(
          stepNumber: 3,
          title: 'Masaje circular suave',
          instruction: 'Realiza movimientos circulares lentos y suaves con presión moderada hacia adelante y hacia atrás.',
          ergonomicTip: 'Si encuentras un punto sensible, quédate unos segundos respirando suavemente.',
          durationSeconds: 30,
          bodyPartFocus: 'Fibras musculares del masetero y ATM',
          movementDirection: 'Círculos suaves en ambos sentidos',
          visualType: RelaxationVisualType.jawCircles,
        ),
        RelaxationStep(
          stepNumber: 4,
          title: 'Deslizamiento por la línea mandibular',
          instruction: 'Desliza las yemas de tus dedos desde la articulación del oído hacia abajo, recorriendo el borde óseo hasta el mentón.',
          ergonomicTip: 'Mantén una presión suave que arrastre la tensión hacia el centro del mentón.',
          durationSeconds: 25,
          bodyPartFocus: 'Borde inferior de la mandíbula',
          movementDirection: 'Deslizamiento descendente hacia el mentón',
          visualType: RelaxationVisualType.jawGlide,
        ),
        RelaxationStep(
          stepNumber: 5,
          title: 'Apertura lenta y descarga profunda',
          instruction: 'Abre y cierra la boca lentamente al ritmo de una respiración profunda, soltando el aire por la boca entreabierta.',
          ergonomicTip: 'No abras de forma brusca; acompaña el movimiento con una exhalación liberadora.',
          durationSeconds: 25,
          bodyPartFocus: 'Amplitud mandibular y musculatura masticatoria',
          movementDirection: 'Apertura y cierre armónico guiado',
          visualType: RelaxationVisualType.jawRelease,
        ),
      ],
    ),

    // 4. Pausa visual inteligente
    RelaxationActivity(
      id: 'smart_visual_break',
      name: 'Pausa visual inteligente',
      category: 'Descanso Digital',
      targetArea: 'Ojos y visión',
      benefit: 'Aplica la regla 20-20-20 para descansar los músculos oculares, hidratar la córnea y prevenir la fatiga visual.',
      totalDurationSeconds: 120,
      estimatedDurationText: '2 minutos',
      icon: Icons.remove_red_eye_outlined,
      accentColor: Color(0xFF3B7A8C),
      steps: [
        RelaxationStep(
          stepNumber: 1,
          title: 'Alejar la vista de la pantalla',
          instruction: 'Aparta los ojos de tu computador, teléfono o apuntes y fija tu mirada hacia un espacio amplio.',
          ergonomicTip: 'Pestañea suavemente para comenzar a restaurar la película lagrimal.',
          durationSeconds: 20,
          bodyPartFocus: 'Acomodación de cerca y retina',
          movementDirection: 'Desconexión de luz de pantallas',
          visualType: RelaxationVisualType.eyeLookAway,
        ),
        RelaxationStep(
          stepNumber: 2,
          title: 'Enfoque al infinito (Regla 20-20-20)',
          instruction: 'Fija tu mirada en un objeto distante situado a más de 6 metros o mira a través de una ventana.',
          ergonomicTip: 'Permite que la mirada se torne suave y panorámica; no fuerces el enfoque en un solo punto.',
          durationSeconds: 25,
          bodyPartFocus: 'Músculos ciliares del cristalino',
          movementDirection: 'Enfoque profundo a más de 6 metros',
          visualType: RelaxationVisualType.eyeFocusDistance,
        ),
        RelaxationStep(
          stepNumber: 3,
          title: 'Parpadeo consciente e hidratación',
          instruction: 'Abre y cierra los ojos despacio de manera rítmica unas 10 a 12 veces, sintiendo la humedad natural en tus párpados.',
          ergonomicTip: 'Frente a las pantallas parpadeamos un 60% menos; este paso repara esa hidratación.',
          durationSeconds: 25,
          bodyPartFocus: 'Glándulas lagrimales y córnea',
          movementDirection: 'Parpadeo rítmico y consciente',
          visualType: RelaxationVisualType.eyeBlink,
        ),
        RelaxationStep(
          stepNumber: 4,
          title: 'Baño de oscuridad tibia (Palming)',
          instruction: 'Frota las palmas de tus manos para calentarlas y colócalas en forma de cuenco sobre tus ojos cerrados sin presionar.',
          ergonomicTip: 'Disfruta de la oscuridad total y el calor agradable durante varios ciclos respiratorios.',
          durationSeconds: 30,
          bodyPartFocus: 'Fotoreceptores y relajación ocular profunda',
          movementDirection: 'Cobertura con palmas tibias en cuenco',
          visualType: RelaxationVisualType.eyePalming,
        ),
        RelaxationStep(
          stepNumber: 5,
          title: 'Movilidad suave en ocho y apertura',
          instruction: 'Realiza movimientos oculares suaves en forma de ocho infinito y luego abre la mirada adaptándote a la luz.',
          ergonomicTip: 'Tus ojos están renovados y listos para continuar con foco y frescura.',
          durationSeconds: 20,
          bodyPartFocus: 'Músculos extraoculares y agudeza visual',
          movementDirection: 'Movimiento en infinito y parpadeo final',
          visualType: RelaxationVisualType.eyeInfinity,
        ),
      ],
    ),
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RelaxationActivity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
