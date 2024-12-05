import 'package:collection/collection.dart';
import 'package:custom_widgets/custom_bar_chart/custom_bar_chart_data.dart';
import 'package:custom_widgets/custom_bar_chart/datetime_extension.dart';

import 'package:flutter/material.dart';

class CustomBarChart extends StatefulWidget {
  const CustomBarChart({
    required this.datas,
    required this.barGradient,
    super.key,
    this.barSpacing = 8,
    this.height = 300,
    this.lineColor = Colors.red,
    this.nodeColor = Colors.green,
  });
  final List<CustomBarChartData> datas;

  final Color lineColor;
  final Color nodeColor;
  final double barSpacing;
  final double height;
  final LinearGradient barGradient;

  @override
  State<CustomBarChart> createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart> with TickerProviderStateMixin {
  CustomBarChartData? selectedBar;
  late final AnimationController nodeScaleAnimationController;
  late final AnimationController staggeredOpacityAnimationController;

  final nodeScaleAnimLowerBound = 1.0;
  final nodeScaleAnimUpperBound = 2.0;
  final nodeScaleAnimDuration = const Duration(seconds: 1);
  final staggeredOpacityAnimDuration = const Duration(seconds: 3);
  late final ScrollController scrollController;
  late List<Animation<double>> staggeredOpacityAnimations;
  final customPainterKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    nodeScaleAnimationController = AnimationController(
      vsync: this,
      duration: nodeScaleAnimDuration,
      lowerBound: nodeScaleAnimLowerBound,
      upperBound: nodeScaleAnimUpperBound,
    )..addListener(() {
        setState(() {});
      });

    staggeredOpacityAnimationController = AnimationController(
      vsync: this,
      duration: staggeredOpacityAnimDuration,
    )
      ..addListener(() {
        setState(() {});
      })
      ..forward();

    scrollController = ScrollController()
      ..addListener(() {
        setState(() {});
      });

    staggeredOpacityAnimations = generateStaggeredAnimations(widget.datas.length);
  }

  @override
  void dispose() {
    nodeScaleAnimationController.dispose();
    staggeredOpacityAnimationController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  void handleOnBarSelected(CustomBarChartData selected) {
    nodeScaleAnimationController
      ..reset()
      ..forward().then((_) {
        nodeScaleAnimationController.reverse().then((_) {
          setState(() {
            updateSelectedBar(null);
          });
        });
      });

    updateSelectedBar(selected);
  }

  void updateSelectedBar(CustomBarChartData? data) {
    setState(() {
      selectedBar = data;
    });
  }

  List<GlobalKey> generateBarKeys() => List.generate(
        widget.datas.length,
        (index) => GlobalKey(),
      );

  List<Animation<double>> generateStaggeredAnimations(int count) {
    return List.generate(
      count,
      (index) {
        final lineDelay = (index * 0.1).clamp(0, 1.0).toDouble();
        return Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: staggeredOpacityAnimationController,
            curve: Interval(
              lineDelay,
              1,
              curve: Curves.easeInOut,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final barKeys = generateBarKeys();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: scrollController,
      clipBehavior: Clip.none,
      child: CustomPaint(
        key: customPainterKey,
        size: Size(double.maxFinite, widget.height),
        foregroundPainter: _LinePainter(
          datas: widget.datas,
          nodeRadius: 3,
          customPainterKey: customPainterKey,
          barKeys: barKeys,
          lineColor: widget.lineColor,
          nodeColor: widget.nodeColor,
          selectedBar: selectedBar,
          nodeScaleAnimation: nodeScaleAnimationController,
          staggeredOpacityAnimations: staggeredOpacityAnimations,
        ),
        child: Row(
          children: widget.datas.mapIndexed((index, data) {
            return Padding(
              padding: EdgeInsets.only(right: index >= 0 && index < widget.datas.length ? widget.barSpacing : 0),
              child: Opacity(
                opacity: staggeredOpacityAnimations[index].value,
                child: _BarWithLine(
                  globalKey: barKeys[index],
                  datas: widget.datas,
                  barData: data,
                  barGradient: widget.barGradient,
                  isSelected: selectedBar == data,
                  onSelected: handleOnBarSelected,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _BarWithLine extends StatefulWidget {
  const _BarWithLine({
    required this.globalKey,
    required this.barData,
    required this.datas,
    required this.barGradient,
    required this.isSelected,
    this.onSelected,
  });
  final CustomBarChartData barData;

  final List<CustomBarChartData> datas;
  final LinearGradient barGradient;
  final GlobalKey globalKey;
  final bool isSelected;

  final void Function(CustomBarChartData selectedData)? onSelected;

  @override
  State<_BarWithLine> createState() => _BarWithLineState();
}

class _BarWithLineState extends State<_BarWithLine> with SingleTickerProviderStateMixin {
  late final AnimationController barOverlayAnimationController;

  @override
  void initState() {
    super.initState();
    barOverlayAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void didUpdateWidget(covariant _BarWithLine oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isSelected == oldWidget.isSelected) return;

    if (widget.isSelected) {
      barOverlayAnimationController.forward().then(
        (_) {
          barOverlayAnimationController.reverse();
        },
      );
    } else {
      barOverlayAnimationController.reset();
    }
  }

  @override
  void dispose() {
    barOverlayAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final barValue = widget.barData.data ?? 0.0;
    final maxValue = widget.barData.getMaxValue(widget.datas);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            widget.onSelected?.call(widget.barData);
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              barContainer(barValue, maxValue),
              Positioned(
                top: -32,
                left: 0,
                right: 0,
                child: barOverlayBuilder(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        labelText(),
      ],
    );
  }

  Text labelText() {
    return Text(
      widget.barData.date.toShortenedWeekDay() ?? '-',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 16,
        color: widget.isSelected ? Colors.black : const Color(0xFF9F9F9F),
      ),
    );
  }

  AnimatedBuilder barOverlayBuilder() {
    return AnimatedBuilder(
      animation: barOverlayAnimationController,
      builder: (context, _) {
        return Opacity(
          opacity: widget.isSelected ? barOverlayAnimationController.value : 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.barData.data?.toStringAsFixed(2) ?? '-',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 11),
            ),
          ),
        );
      },
    );
  }

  Container barContainer(double barValue, double maxValue) {
    return Container(
      key: widget.globalKey,
      width: 40,
      height: (barValue / maxValue) * 250,
      decoration: BoxDecoration(
        gradient: widget.barGradient,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  const _LinePainter({
    required this.datas,
    required this.lineColor,
    required this.nodeColor,
    required this.barKeys,
    required this.nodeScaleAnimation,
    required this.selectedBar,
    required this.staggeredOpacityAnimations,
    required this.customPainterKey,
    this.nodeRadius = 4.0,
  });
  final List<CustomBarChartData> datas;
  final Color lineColor;
  final Color nodeColor;
  final List<GlobalKey> barKeys;
  final double nodeRadius;
  final Animation<double> nodeScaleAnimation;
  final CustomBarChartData? selectedBar;

  final List<Animation<double>> staggeredOpacityAnimations;
  final GlobalKey customPainterKey;

  @override
  void paint(Canvas canvas, Size size) {
    final nodePaint = Paint()
      ..color = nodeColor
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    var totalWidth = 0.0;

    for (final element in barKeys) {
      final renderBox = element.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        totalWidth += renderBox.size.width;
      }
    }

    final barSpaceOffset = totalWidth / datas.length;

    final positions = <Offset>[];
    for (var i = 0; i < datas.length; i++) {
      final renderBox = barKeys[i].currentContext?.findRenderObject() as RenderBox?;
      final parentBox = customPainterKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final barPosition = renderBox.localToGlobal(Offset.zero, ancestor: parentBox);
        final x = barPosition.dx + (barSpaceOffset / 2);

        final y = barPosition.dy;
        positions.add(Offset(x, y));
      }
    }

    /*---------------------------------------------------------------------------
    
    ///? Single path drawing for if each line has same property,
    ///? prof: each line and each paint object customizable, (staggered animation for example)
    ///? cons: path and paint object creation for each segment.
    
    final path = Path()..moveTo(positions.first.dx, positions.first.dy);
    for (var i = 0; i < positions.length - 1; i++) {
      final controlPointX = (positions[i].dx + positions[i + 1].dx) / 2;
      path.cubicTo(
        controlPointX,
        positions[i].dy,
        controlPointX,
        positions[i + 1].dy,
        positions[i + 1].dx,
        positions[i + 1].dy,
      );
    }

    canvas.drawPath(path, paint); */

    ///--------------------------------------------------------------------------

    for (var i = 0; i < positions.length - 1; i++) {
      final path = Path()..moveTo(positions[i].dx, positions[i].dy);

      final controlPointX = (positions[i].dx + positions[i + 1].dx) / 2;
      path.cubicTo(
        controlPointX,
        positions[i].dy,
        controlPointX,
        positions[i + 1].dy,
        positions[i + 1].dx,
        positions[i + 1].dy,
      );

      final paint = Paint()
        ..strokeWidth = 2
        ..color = lineColor.withOpacity(staggeredOpacityAnimations[i].value)
        ..style = PaintingStyle.stroke;

      canvas.drawPath(path, paint);
    }

    for (var i = 0; i < positions.length; i++) {
      if (datas[i] == selectedBar) {
        canvas
          ..drawCircle(positions[i], nodeRadius * nodeScaleAnimation.value, nodePaint)
          ..drawCircle(positions[i], nodeRadius * nodeScaleAnimation.value, borderPaint);
      } else {
        nodePaint.color = nodeColor.withOpacity(staggeredOpacityAnimations[i].value);
        borderPaint.color = Colors.black.withOpacity(staggeredOpacityAnimations[i].value);
        canvas
          ..drawCircle(positions[i], nodeRadius, nodePaint)
          ..drawCircle(positions[i], nodeRadius, borderPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _LinePainter oldDelegate) {
    return datas != oldDelegate.datas || lineColor != oldDelegate.lineColor || nodeColor != oldDelegate.nodeColor || nodeScaleAnimation != oldDelegate.nodeScaleAnimation;
  }
}
