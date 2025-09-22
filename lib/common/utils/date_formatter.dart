// lib/common/utils/date_formatter.dart

import 'package:intl/intl.dart';

class DateFormatter {
  /// Formatea una fecha a un formato legible como "15 de mayo, 2024".
  static String toReadableDate(DateTime date) {
    // Asegúrate de tener la dependencia 'intl' en pubspec.yaml
    return DateFormat('dd \'de\' MMMM, yyyy', 'es_ES').format(date);
  }

  /// Formatea una fecha a un formato corto como "15/05/2024".
  static String toShortDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
}