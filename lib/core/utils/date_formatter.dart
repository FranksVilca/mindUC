/// Utilidad pura para formateo determinista de fechas en español para mindUC.
class SpanishDateFormatter {
  static const List<String> _weekdays = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado',
    'Domingo',
  ];

  static const List<String> _months = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre',
  ];

  /// Nombres de los días de la semana en español.
  static const List<String> weekdays = _weekdays;

  /// Nombres de los meses del año en español.
  static const List<String> months = _months;

  /// Formatea la fecha en el formato sereno de Figma: "Jueves, 24 de Octubre".
  static String format(DateTime date) {
    final weekday = _weekdays[date.weekday - 1];
    final day = date.day;
    final month = _months[date.month - 1];
    return '$weekday, $day de $month';
  }

  /// Retorna la clave de fecha en formato estandarizado "YYYY-MM-DD" para persistencia.
  static String toIsoDateString(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}

