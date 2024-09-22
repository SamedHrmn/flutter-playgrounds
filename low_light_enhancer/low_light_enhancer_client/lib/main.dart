import 'package:flutter/material.dart';
import 'package:low_light_enhancer_client/image_select_view.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ImageSelectView(),
    );
  }
}
