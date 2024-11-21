import 'package:custom_widgets/buttons_view.dart';
import 'package:custom_widgets/listwheel_view.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

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
        title: const Text('Material App Bar'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Center(
              child: ElevatedButton(
                child: const Text('ListWheel Picker'),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const ListWheelView(),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: Center(
              child: ElevatedButton(
                child: const Text('Neumorphism Button'),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const ButtonsView(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
