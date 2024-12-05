import 'package:custom_widgets/custom_bar_chart/custom_bar_chart_view.dart';
import 'package:custom_widgets/custom_birth_picker/custom_birth_picker_view.dart';
import 'package:custom_widgets/inset_button/inset_button_view.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Widgets'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            child: const Text('Custom Birth Picker'),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const CustomBirthPickerView(),
              ),
            ),
          ),
          ElevatedButton(
            child: const Text('Neumorphism Button'),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const InsetButtonView(),
              ),
            ),
          ),
          ElevatedButton(
            child: const Text('Weight Tracker Chart'),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const WeightTrackerView(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
