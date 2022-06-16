part of '../home.dart';

class _BatteryButton extends StatelessWidget {
  const _BatteryButton({Key? key, required this.getBatteryInfo}) : super(key: key);

  final Function(double? level) getBatteryInfo;

  Future<double?> _getBatteryFromPlatform() async => await const MethodChannel("batteryChannel").invokeMethod("getBatteryInfo") as double?;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () async => getBatteryInfo.call(await _getBatteryFromPlatform()), child: const Text('Channel Button'));
  }
}
