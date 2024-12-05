import 'dart:math';

import 'package:flutter/widgets.dart';

@immutable
class CustomBarChartData {
  const CustomBarChartData({required this.date, required this.data});

  final DateTime date;
  final double? data;

  double getMaxValue(List<CustomBarChartData> datas) {
    return datas.map((element) => element.data ?? 0).reduce((a, b) => a > b ? a : b);
  }

  static List<CustomBarChartData> generateDummyList({DateTime? start, DateTime? end}) {
    final _start = start ?? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final _end = end ?? _start.add(const Duration(days: 7));

    return List.generate(_end.difference(_start).inDays + 1, (index) {
      final _date = _start.add(Duration(days: index + 1));
      final _value = Random().nextDouble() * 10;
      return CustomBarChartData(date: _date, data: _value);
    });
  }

  @override
  bool operator ==(covariant CustomBarChartData other) {
    if (identical(this, other)) return true;

    return other.date.day == date.day && other.date.hour == date.hour && other.date.year == date.year && other.data == data;
  }

  @override
  int get hashCode => date.hashCode ^ data.hashCode;
}

class BarChartPageData {
  BarChartPageData({required this.barChartData, required this.page}) {
    if (barChartData != null) {
      startDay = barChartData!.first.date;
      endDay = barChartData!.last.date;
    }
  }

  final List<CustomBarChartData>? barChartData;
  final int page;
  DateTime? startDay;
  DateTime? endDay;
}
