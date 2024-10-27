import 'package:flutter/material.dart';

class BaseAnimatedListView<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index, Animation<double> animation) itemBuilder;
  final Duration animationDuration;
  final EdgeInsets padding;

  const BaseAnimatedListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.animationDuration = const Duration(milliseconds: 500),
    this.padding = const EdgeInsets.all(16),
  });

  @override
  _BaseAnimatedListViewState<T> createState() => _BaseAnimatedListViewState<T>();
}

class _BaseAnimatedListViewState<T> extends State<BaseAnimatedListView<T>> with TickerProviderStateMixin {
  List<AnimationController> _controllers = [];
  List<Animation<double>> _animations = [];
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _initControllersAndAnimations(widget.items.length);
  }

  void _initControllersAndAnimations(int itemCount) {
    for (var controller in _controllers) {
      controller.dispose();
    }

    _controllers.clear();
    _animations.clear();

    _controllers = List.generate(
      itemCount,
      (index) => AnimationController(
        vsync: this,
        duration: widget.animationDuration,
      ),
    );

    _animations = _controllers.map((controller) {
      return CurvedAnimation(parent: controller, curve: Curves.easeIn);
    }).toList();

    _startStaggeredAnimations();
  }

  void _startStaggeredAnimations() async {
    if (_isAnimating) return;
    _isAnimating = true;

    for (var i = 0; i < _controllers.length; i++) {
      if (!mounted || i >= _controllers.length) break;

      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted || i >= _controllers.length) return;
      _controllers[i].forward();
    }

    _isAnimating = false;
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: widget.padding,
      itemBuilder: (context, index) {
        final item = widget.items[index];
        return FadeTransition(
          opacity: _animations[index],
          child: widget.itemBuilder(context, item, index, _animations[index]),
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 24),
      itemCount: widget.items.length,
    );
  }
}
