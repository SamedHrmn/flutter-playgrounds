import 'package:flutter/material.dart';

class CustomBirthPicker extends StatefulWidget {
  const CustomBirthPicker({super.key});

  @override
  _CustomBirthPickerState createState() => _CustomBirthPickerState();
}

class _CustomBirthPickerState extends State<CustomBirthPicker> {
  late int selectedMonthIndex;
  late int selectedYearIndex;
  late int selectedDayIndex;
  List<int> days = List.generate(30, (index) => index + 1);
  List<int> years = List.generate(100, (index) => DateTime.now().year - 100 + index);
  List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
  late List<String> selectedDate;
  @override
  void initState() {
    super.initState();

    selectedDate = ['20', months[5], '1999'];
    selectedDayIndex = int.parse(selectedDate[0]) - 1;
    selectedMonthIndex = months.indexOf(selectedDate[1]);
    selectedYearIndex = years.indexOf(int.parse(selectedDate[2]));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Expanded(
          flex: 3,
          child: _BirthScrollView(
            initialIndex: int.parse(selectedDate[0]) - 1,
            onSelectedItemChanged: (p0) {
              setState(() {
                selectedDayIndex = p0;
                selectedDate[0] = days[selectedDayIndex].toString();
              });
            },
            children: days
                .map(
                  (e) => Center(
                    child: FittedBox(
                      child: Text(
                        e.toString(),
                        style: days.indexOf(e) == selectedDayIndex
                            ? Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 28, color: Colors.black.withOpacity(0.8))
                            : Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20, color: Colors.black.withOpacity(0.4)),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        _dividerContainer(),
        Expanded(
          flex: 6,
          child: _BirthScrollView(
            initialIndex: months.indexOf(selectedDate[1]),
            onSelectedItemChanged: (value) {
              setState(
                () {
                  selectedMonthIndex = value;
                  selectedDate[1] = months[selectedMonthIndex];

                  if (months.indexWhere((element) => element == months[value]).isEven) {
                    days = List.generate(31, (index) => index + 1);
                  } else {
                    days = List.generate(30, (index) => index + 1);

                    if (months.indexWhere((element) => element == months[value]) == 1) {
                      days = List.generate(29, (index) => index + 1);
                    }
                  }
                },
              );
            },
            children: months
                .map(
                  (e) => Center(
                    child: FittedBox(
                      child: Text(
                        e,
                        style: selectedMonthIndex == months.indexOf(e)
                            ? Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 28, color: Colors.black.withOpacity(0.8))
                            : Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20, color: Colors.black.withOpacity(0.4)),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        _dividerContainer(),
        Expanded(
          flex: 3,
          child: _BirthScrollView(
            initialIndex: years.indexOf(int.parse(selectedDate[2])),
            onSelectedItemChanged: (p0) {
              setState(() {
                selectedYearIndex = p0;
                selectedDate[2] = years[selectedYearIndex].toString();
              });
            },
            children: years
                .map(
                  (e) => Center(
                    child: FittedBox(
                      child: Text(
                        e.toString(),
                        style: selectedYearIndex == years.indexOf(e)
                            ? Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 28, color: Colors.black.withOpacity(0.8))
                            : Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 20, color: Colors.black.withOpacity(0.4)),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _dividerContainer() {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          color: Colors.black,
        ),
        width: 2,
      ),
    );
  }
}

class _BirthScrollView extends StatefulWidget {
  const _BirthScrollView({
    required this.children,
    this.onSelectedItemChanged,
    this.initialIndex,
  });
  final List<Widget> children;
  final void Function(int)? onSelectedItemChanged;
  final int? initialIndex;

  @override
  _BirthScrollViewState createState() => _BirthScrollViewState();
}

class _BirthScrollViewState extends State<_BirthScrollView> {
  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      controller: FixedExtentScrollController(initialItem: widget.initialIndex ?? 0),
      diameterRatio: 1.1,
      squeeze: 1.45,
      physics: const FixedExtentScrollPhysics(),
      itemExtent: 52,
      onSelectedItemChanged: widget.onSelectedItemChanged,
      childDelegate: ListWheelChildLoopingListDelegate(children: widget.children),
    );
  }
}
