import 'package:flutter/material.dart';

class BaseButton extends StatefulWidget {
  const BaseButton({
    this.loader,
    super.key,
    this.buttonColor,
    this.borderSide,
    this.pressedOverlayColor,
    this.child,
    this.onPressed,
    this.isCircular = false,
    this.padding = EdgeInsets.zero,
    this.pressedState,
    this.radius = 8,
  });

  final Color? buttonColor;

  final Future<void> Function()? onPressed;
  final BorderSide? borderSide;
  final Color? pressedOverlayColor;
  final Widget? child;
  final bool isCircular;
  final Widget? loader;
  final double radius;
  final EdgeInsets padding;
  final void Function(bool pressed)? pressedState;

  @override
  State<BaseButton> createState() => _BaseButtonState();
}

class _BaseButtonState extends State<BaseButton> {
  bool _isLoading = false;

  late WidgetStatesController widgetStatesController;

  @override
  void initState() {
    super.initState();

    widgetStatesController = WidgetStatesController()
      ..addListener(() {
        widget.pressedState?.call(widgetStatesController.value.contains(WidgetState.pressed));
      });
  }

  @override
  void dispose() {
    widgetStatesController.dispose();
    super.dispose();
  }

  void _changeLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      statesController: widgetStatesController,
      style: ButtonStyle(
        elevation: const WidgetStatePropertyAll(0),
        overlayColor: WidgetStatePropertyAll(widget.pressedOverlayColor),
        backgroundColor: WidgetStatePropertyAll(widget.buttonColor ?? Theme.of(context).primaryColor),
        shape: WidgetStatePropertyAll(
          widget.isCircular
              ? const CircleBorder()
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(widget.radius),
                ),
        ),
        side: WidgetStatePropertyAll(widget.borderSide),
        minimumSize: const WidgetStatePropertyAll(Size.zero),
        padding: WidgetStatePropertyAll(widget.padding),
      ),
      onPressed: widget.onPressed ??
          () async {
            _changeLoading();
            await widget.onPressed?.call();
            _changeLoading();
          },
      child: _isLoading ? (widget.loader ?? const CircularProgressIndicator()) : widget.child,
    );
  }
}
