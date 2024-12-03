import 'dart:math';

import 'package:flutter/material.dart';

class ElasticLineView extends StatefulWidget {
  const ElasticLineView({super.key});

  @override
  State<ElasticLineView> createState() => _ElasticLineViewState();
}

class _ElasticLineViewState extends State<ElasticLineView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  final Offset _pointA = Offset.zero;
  late final Offset _pointB;
  Offset _grabPoint = Offset.zero;
  Offset _currentGrabPoint = Offset.zero;
  Offset _initialGrabPoint = Offset.zero;
  bool _isDragging = false;
  bool _isInitializePoints = false;
  final double _lineTapOffset = 50;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = _controller.drive(
      Tween<double>(begin: 0, end: 1).chain(
        CurveTween(curve: Curves.easeOut),
      ),
    );

    _controller.addListener(() {
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _pointB = MediaQuery.sizeOf(context).bottomRight(_pointA);
        _isInitializePoints = true;
      });
    });
  }

  void _startSpringAnimation() {
    _initialGrabPoint = _currentGrabPoint;
    _controller
      ..reset()
      ..forward();
  }

  bool _isTapNearLine(Offset tapPoint) {
    final closestPoint = _getClosestPointOnLine(tapPoint);
    return (closestPoint - tapPoint).distance < _lineTapOffset;
  }

  Offset _getClosestPointOnLine(Offset tapPoint) {
    final lineVector = _pointB - _pointA;
    final tapVector = tapPoint - _pointA;

    final projectionFactor = (tapVector.dx * lineVector.dx + tapVector.dy * lineVector.dy) / (lineVector.dx * lineVector.dx + lineVector.dy * lineVector.dy);

    return Offset(
      _pointA.dx + lineVector.dx * projectionFactor,
      _pointA.dy + lineVector.dy * projectionFactor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !_isInitializePoints
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GestureDetector(
              onPanStart: (details) {
                if (_isTapNearLine(details.localPosition)) {
                  _controller.reset();
                  _isDragging = true;
                  _grabPoint = _getClosestPointOnLine(details.localPosition);
                  _currentGrabPoint = _grabPoint;
                }
              },
              onPanUpdate: (details) {
                if (_isDragging) {
                  setState(() {
                    _currentGrabPoint += details.localPosition - _currentGrabPoint;
                  });
                }
              },
              onPanEnd: (_) {
                if (_isDragging) {
                  _isDragging = false;
                  _startSpringAnimation();
                }
              },
              child: CustomPaint(
                painter: ElasticLinePainter(
                  pointA: _pointA,
                  pointB: _pointB,
                  grabPoint: _grabPoint,
                  currentGrabPoint: _currentGrabPoint,
                  initialGrabPoint: _initialGrabPoint,
                  animationValue: _animation.value,
                  isDragging: _isDragging,
                ),
                child: Container(),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ElasticLinePainter extends CustomPainter {
  final Offset pointA;
  final Offset pointB;
  final Offset grabPoint;
  final Offset currentGrabPoint;
  final Offset initialGrabPoint;
  final double animationValue;
  final bool isDragging;
  final double oscillationFactor;
  final double dampingFactor;

  ElasticLinePainter({
    required this.pointA,
    required this.pointB,
    required this.grabPoint,
    required this.currentGrabPoint,
    required this.initialGrabPoint,
    required this.animationValue,
    required this.isDragging,
    this.oscillationFactor = 10,
    this.dampingFactor = -4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    final damping = exp(dampingFactor * animationValue);
    final oscillation = sin(animationValue * oscillationFactor * pi);

    final animatedGrabPoint = isDragging
        ? currentGrabPoint
        : Offset.lerp(
              initialGrabPoint,
              grabPoint,
              animationValue,
            )! +
            Offset(
              oscillation * damping * (grabPoint.dx - initialGrabPoint.dx),
              oscillation * damping * (grabPoint.dy - initialGrabPoint.dy),
            );

    final path = Path()
      ..moveTo(pointA.dx, pointA.dy)
      ..quadraticBezierTo(
        animatedGrabPoint.dx,
        animatedGrabPoint.dy,
        pointB.dx,
        pointB.dy,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
