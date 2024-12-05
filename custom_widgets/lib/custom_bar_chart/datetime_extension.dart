import 'package:intl/intl.dart';

extension DateTimeExt on DateTime? {
  String? toShortenedWeekDay() {
    if (this == null) return null;
    return DateFormat(DateFormat.ABBR_WEEKDAY).format(this!);
  }

  String? showAsRangeFormat() {
    if (this == null) return null;

    return DateFormat('d E MMMM').format(this!);
  }
}
