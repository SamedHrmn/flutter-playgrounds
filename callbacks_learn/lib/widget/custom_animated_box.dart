part of '../home.dart';

class _CustomAnimatedBox extends StatefulWidget {
  const _CustomAnimatedBox({Key? key, required this.onCompleted, required this.onReset}) : super(key: key);

  @override
  State<_CustomAnimatedBox> createState() => __CustomAnimatedBoxState();

  final Color? Function() onCompleted;
  final VoidCallback onReset;
}

class __CustomAnimatedBoxState extends State<_CustomAnimatedBox> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Color? _boxColor;
  bool _isAnimationCompleted = false;
  final String _clickMeText = 'Click Me !';
  final String _againText = 'Again';
  final Color _boxColorInitial = Colors.grey;
  final Duration _animDuration = const Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _animDuration);
    _controller.addListener(() {
      if (_controller.isCompleted) {
        setState(() {
          _boxColor = widget.onCompleted.call();
          _isAnimationCompleted = !_isAnimationCompleted;
        });
      }
    });
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
      builder: (_, child) {
        return Column(
          children: [
            _clickableContainer(),
            child ?? const SizedBox(),
          ],
        );
      },
      child: _isAnimationCompleted ? _resetButton() : const SizedBox(),
    );
  }

  ElevatedButton _resetButton() {
    return ElevatedButton(
      onPressed: () {
        _controller.reset();
        widget.onReset.call();
        setState(() {
          _boxColor = null;
          _isAnimationCompleted = false;
        });
      },
      child: Text(
        _againText,
      ),
    );
  }

  GestureDetector _clickableContainer() {
    return GestureDetector(
      onTap: () {
        _controller.forward();
      },
      child: Container(
        width: 100 * (_controller.value + 1),
        height: 100,
        color: _boxColor ?? _boxColorInitial,
        alignment: Alignment.center,
        child: Text(
          _isAnimationCompleted ? "" : _clickMeText,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
