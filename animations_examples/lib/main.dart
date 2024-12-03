import 'package:animations_examples/custom_animated_container/animated_container_view.dart';
import 'package:animations_examples/elastic_line/elastic_line_view.dart';
import 'package:animations_examples/parallax_multi_list/parallax_scrolling_view.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Animation Samples'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const AnimatedContainersView(),
                ),
              ),
              child: const Text('Animated Containers'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const ElasticLineView(),
                ),
              ),
              child: const Text('Elastic Line'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const ParallaxScrollingView(),
                ),
              ),
              child: const Text('Parallax Scrolling'),
            ),
          ],
        ),
      ),
    );
  }
}
