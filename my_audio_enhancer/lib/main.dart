import 'package:flutter/material.dart';
import 'inherited/audio_processor_inherited.dart';
import 'util/sizer_util.dart';
import 'view/home_view.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return VideoPlayerViewProvider(
      child: Builder(builder: (context) {
        return MaterialApp(
          scaffoldMessengerKey: AudioProcessorInherited.of(context).scaffoldKey,
          debugShowCheckedModeBanner: false,
          home: Builder(builder: (context) {
            SizerUtil.init(context, figmaWidth: 428, figmaHeight: 926);

            return const HomeView();
          }),
        );
      }),
    );
  }
}
