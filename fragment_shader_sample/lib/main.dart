import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fragment_shader_sample/shader_burn_effect_controller.dart';
import 'package:fragment_shader_sample/shader_painter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: ShaderBurnEffect());
  }
}

class ShaderBurnEffect extends StatefulWidget {
  const ShaderBurnEffect({super.key});

  @override
  State<ShaderBurnEffect> createState() => _ShaderBurnEffectState();
}

class _ShaderBurnEffectState extends State<ShaderBurnEffect> with ShaderBurnEffectController {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: (image == null || !fragmentShaderHelper.isShaderReady)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                spacing: 8,
                children: [
                  shaderCanvas(),
                  controlButtons(),
                ],
              ),
      ),
    );
  }

  Widget controlButtons() {
    return AnimatedSwitcher(
      duration: Durations.medium4,
      child: isCompleted && !isRestored
          ? ElevatedButton(
              key: UniqueKey(),
              onPressed: restoreShader,
              child: Text(
                'Restore',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            )
          : ElevatedButton(
              key: UniqueKey(),
              onPressed: startAnimation,
              child: Text(
                'Burn it',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
            ),
    );
  }

  Padding shaderCanvas() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: AspectRatio(
          aspectRatio: image!.width / image!.height,
          child: CustomPaint(
            painter: ShaderPainter(
              image: image!,
              shader: fragmentShaderHelper.getShader(),
            ),
          ),
        ),
      ),
    );
  }
}
