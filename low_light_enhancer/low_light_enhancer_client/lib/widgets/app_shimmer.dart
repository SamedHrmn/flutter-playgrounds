import 'package:flutter/material.dart';

class AppShimmer extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final AlignmentGeometry startAlignment;
  final AlignmentGeometry endAlignment;

  const AppShimmer({
    super.key,
    required this.child,
    this.baseColor = Colors.grey,
    this.highlightColor = Colors.white,
    this.startAlignment = Alignment.centerLeft,
    this.endAlignment = Alignment.centerRight,
  });

  @override
  _AppShimmerState createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: widget.startAlignment,
              end: widget.endAlignment,
              colors: [widget.baseColor.withOpacity(0.2), widget.highlightColor, widget.baseColor.withOpacity(0.2)],
              stops: [_controller.value - 0.3, _controller.value, _controller.value + 0.3],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: widget.child,
        );
      },
    );
  }
}
