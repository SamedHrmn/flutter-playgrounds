import 'package:flutter/material.dart';

class AppShimmerLoader extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final AlignmentGeometry startAlignment;
  final AlignmentGeometry endAlignment;

  const AppShimmerLoader({
    super.key,
    required this.child,
    this.baseColor = Colors.grey,
    this.highlightColor = Colors.white,
    this.startAlignment = Alignment.centerLeft,
    this.endAlignment = Alignment.centerRight,
  });

  @override
  State<AppShimmerLoader> createState() => _AppShimmerLoaderState();
}

class _AppShimmerLoaderState extends State<AppShimmerLoader> with SingleTickerProviderStateMixin {
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
