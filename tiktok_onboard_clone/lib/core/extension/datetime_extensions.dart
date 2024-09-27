import 'package:easy_localization/easy_localization.dart';

extension DatetimeExtensions on DateTime {
  String toReadableString() {
    return '$day ${DateFormat.MMMM().format(this)} $year';
  }
}
