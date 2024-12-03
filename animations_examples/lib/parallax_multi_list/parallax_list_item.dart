import 'package:animations_examples/parallax_multi_list/parallax_data.dart';
import 'package:flutter/material.dart';

class ParallaxListItem extends StatelessWidget {
  const ParallaxListItem({
    required this.parallaxData,
    required this.headImage,
    super.key,
  });

  final ParallaxData parallaxData;
  final String headImage;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: parallaxData.subImages.length,
      scrollDirection: Axis.horizontal,
      separatorBuilder: (context, index) => const SizedBox(width: 48),
      itemBuilder: (listContext, index) {
        return InnerListItem(
          listContext: listContext,
          childContext: context,
          imagePath: index == 0 ? headImage : parallaxData.subImages[index],
          itemIndex: index,
        );
      },
    );
  }
}

class InnerListItem extends StatelessWidget {
  const InnerListItem({
    required this.listContext,
    required this.childContext,
    required this.imagePath,
    required this.itemIndex,
    super.key,
  });

  final BuildContext listContext;
  final BuildContext childContext;
  final String imagePath;
  final int itemIndex;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width * 0.75,
        child: Stack(
          children: [
            parallaxImage(
              verticalScrollableState: Scrollable.of(childContext),
              horizontalScrollableState: Scrollable.of(listContext),
              childContext: childContext,
              innerContext: context,
              imagePath: imagePath,
              itemIndex: itemIndex,
            ),
            Positioned.fill(
              child: _gradientBackground(),
            ),
            Positioned(
              left: 16,
              bottom: 16,
              child: textSection(),
            ),
          ],
        ),
      ),
    );
  }

  Widget parallaxImage({
    required ScrollableState verticalScrollableState,
    required ScrollableState horizontalScrollableState,
    required BuildContext childContext,
    required BuildContext innerContext,
    required String imagePath,
    required int itemIndex,
  }) {
    final _key = GlobalObjectKey(imagePath + itemIndex.toString());

    return Flow(
      delegate: ParallaxFlowDelegate(
        childContext: childContext,
        verticalScrollableState: verticalScrollableState,
        horizontalScrollableState: horizontalScrollableState,
        innerContext: innerContext,
        imageChildKey: _key,
      ),
      children: [
        Image.asset(
          key: _key,
          imagePath,
          fit: BoxFit.cover,
        ),
      ],
    );
  }

  Widget textSection() {
    return const Column(
      children: [
        Text(
          'Header',
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  Container _gradientBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.6),
          ],
          stops: const [0.4, 0.9],
        ),
      ),
    );
  }
}

class ParallaxFlowDelegate extends FlowDelegate {
  ParallaxFlowDelegate({
    required this.verticalScrollableState,
    required this.horizontalScrollableState,
    required this.childContext,
    required this.innerContext,
    required this.imageChildKey,
  }) : super(
          repaint: Listenable.merge([
            verticalScrollableState.position,
            horizontalScrollableState.position,
          ]),
        );

  final ScrollableState verticalScrollableState;
  final ScrollableState horizontalScrollableState;

  final BuildContext childContext;
  final BuildContext innerContext;
  final GlobalKey imageChildKey;

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return const BoxConstraints();
  }

  double scaleFactor = 1;

  @override
  void paintChildren(FlowPaintingContext context) {
    final verticalScrollableBox = verticalScrollableState.context.findRenderObject() as RenderBox?;
    final horizontalScrollableBox = horizontalScrollableState.context.findRenderObject() as RenderBox?;
    final childBox = childContext.findRenderObject() as RenderBox?;
    final innerBox = innerContext.findRenderObject() as RenderBox?;
    final imageBox = imageChildKey.currentContext!.findRenderObject() as RenderBox?;

    if (verticalScrollableBox == null || childBox == null || horizontalScrollableBox == null || imageBox == null || innerBox == null) return;

    final childOffsetV = _calculateOffset(renderBox: childBox, scrollableRenderBox: verticalScrollableBox);
    final childOffsetH = _calculateOffset(renderBox: innerBox, scrollableRenderBox: horizontalScrollableBox);

    final verticalScrollFraction = _calculateScrollFraction(direction: childOffsetV.dy, scrollableState: verticalScrollableState);
    final horizontalScrollFraction = _calculateScrollFraction(direction: childOffsetH.dx, scrollableState: horizontalScrollableState);

    final verticalAlignment = Alignment(0, verticalScrollFraction * 2 - 1);
    final horizontalAlignment = Alignment(horizontalScrollFraction * 2 - 1, 0);

    final verticalChildRect = _inscribe(verticalAlignment, imageBox, context);
    final horizontalChildRect = _inscribe(horizontalAlignment, imageBox, context);

    if (imageBox.size.width > childBox.size.width) {
      scaleFactor = imageBox.size.width / childBox.size.width;
    } else if (imageBox.size.height > childBox.size.height) {
      scaleFactor = imageBox.size.height / childBox.size.height;
    }

    context.paintChild(
      0,
      transform: Matrix4.identity()
        ..scale(scaleFactor, scaleFactor)
        ..translate(
          horizontalChildRect.left,
          verticalChildRect.top,
        ),
    );
  }

  Offset _calculateOffset({
    required RenderBox renderBox,
    required RenderBox scrollableRenderBox,
  }) =>
      renderBox.localToGlobal(
        renderBox.size.centerLeft(Offset.zero),
        ancestor: scrollableRenderBox,
      );

  double _calculateScrollFraction({
    required double direction,
    required ScrollableState scrollableState,
  }) =>
      (direction / scrollableState.position.viewportDimension).clamp(0, 1).toDouble();

  Rect _inscribe(
    Alignment alignment,
    RenderBox renderBox,
    FlowPaintingContext context,
  ) =>
      alignment.inscribe(renderBox.size, Offset.zero & context.size);

  @override
  bool shouldRepaint(covariant ParallaxFlowDelegate oldDelegate) {
    return oldDelegate.verticalScrollableState != verticalScrollableState ||
        oldDelegate.childContext != childContext ||
        oldDelegate.horizontalScrollableState != horizontalScrollableState;
  }
}
