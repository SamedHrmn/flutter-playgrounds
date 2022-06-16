part of '../home.dart';

class _CustomFutureButton extends StatefulWidget {
  const _CustomFutureButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final Future<void> Function() onPressed;

  @override
  State<_CustomFutureButton> createState() => _CustomFutureButtonState();
}

class _CustomFutureButtonState extends State<_CustomFutureButton> {
  bool _isLoading = false;
  final Color _progressColor = Colors.white;
  final Size _buttonSize = const Size(120, 50);
  final String _buttonText = 'Callback Button';

  void _changeLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(minimumSize: _buttonSize, padding: EdgeInsets.zero),
      onPressed: () async {
        _changeLoading();
        await widget.onPressed.call();
        _changeLoading();
      },
      child: _isLoading ? CircularProgressIndicator(color: _progressColor) : Text(_buttonText),
    );
  }
}
