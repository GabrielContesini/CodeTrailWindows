import 'package:intl/intl.dart';

class DateTimeUtils {
  const DateTimeUtils._();

  static final _dateFormat = DateFormat('dd/MM');
  static final _dateTimeFormat = DateFormat('dd/MM HH:mm');

  static String shortDate(DateTime? value) {
    if (value == null) return '-';
    return _dateFormat.format(value.toLocal());
  }

  static String shortDateTime(DateTime? value) {
    if (value == null) return '-';
    return _dateTimeFormat.format(value.toLocal());
  }

  static String minutesToReadable(int minutes) {
    if (minutes <= 0) return '0 min';
    final hours = minutes ~/ 60;
    final remaining = minutes % 60;

    if (hours == 0) return '$remaining min';
    if (remaining == 0) return '${hours}h';
    return '${hours}h ${remaining}min';
  }
}
