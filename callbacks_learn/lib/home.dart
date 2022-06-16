import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
part '../widget/custom_future_button.dart';
part '../widget/custom_animated_box.dart';
part '../widget/battery_button.dart';

enum ColorEnum {
  NONE(null),
  RED(Colors.red),
  YELLOW(Colors.yellow),
  GREEN(Colors.green);

  final Color? color;

  const ColorEnum(this.color);
}

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ColorEnum colorEnum = ColorEnum.NONE;

  Future<void> _mockFuture() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  void _changeChipsColor(bool isSelected, ColorEnum cE) {
    setState(() {
      colorEnum = isSelected ? cE : ColorEnum.NONE;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Callbacks Learn'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: _CustomFutureButton(
              onPressed: () async {
                await _mockFuture();
              },
            ),
          ),
          Center(
            child: _BatteryButton(
              getBatteryInfo: (double? level) {
                print(level);
              },
            ),
          ),
          Center(
            child: _filterChipsRow(),
          ),
          Center(
            child: _CustomAnimatedBox(
              onCompleted: () {
                return colorEnum.color;
              },
              onReset: () {
                setState(() {
                  colorEnum = ColorEnum.NONE;
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Row _filterChipsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FilterChip(
          label: Text(ColorEnum.RED.name),
          selected: colorEnum == ColorEnum.RED,
          avatar: CircleAvatar(backgroundColor: ColorEnum.RED.color),
          onSelected: (bool value) {
            _changeChipsColor(value, ColorEnum.RED);
          },
        ),
        FilterChip(
          label: Text(ColorEnum.YELLOW.name),
          selected: colorEnum == ColorEnum.YELLOW,
          avatar: CircleAvatar(
            backgroundColor: ColorEnum.YELLOW.color,
          ),
          onSelected: (bool value) {
            _changeChipsColor(value, ColorEnum.YELLOW);
          },
        ),
        FilterChip(
          label: Text(ColorEnum.GREEN.name),
          selected: colorEnum == ColorEnum.GREEN,
          avatar: CircleAvatar(
            backgroundColor: ColorEnum.GREEN.color,
          ),
          onSelected: (bool value) {
            _changeChipsColor(value, ColorEnum.GREEN);
          },
        ),
      ],
    );
  }
}
