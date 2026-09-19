import 'dart:math' as math;

import 'package:custom_widgets/wallet_cards/wallet_brand_marks.dart';
import 'package:custom_widgets/wallet_cards/wallet_card_data.dart';
import 'package:custom_widgets/wallet_cards/wallet_metrics.dart';
import 'package:custom_widgets/wallet_cards/wallet_painters.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Cards settle with a spring: easeOutBack overshoots near the end of the
/// travel, so the bounce lands where the card stops rather than where it starts.
const _cardEase = Curves.easeOutBack;

/// Slice of the reveal each card occupies, indexed back to front. The front
/// card leads on the way out so the ones behind appear to be pulled from under
/// it; running the controller backwards mirrors that for free, which is why the
/// back card is the first one tucked away again.
const _dealBegin = <double>[0.36, 0.18, 0];
const _dealEnd = <double>[1, 0.76, 0.55];

/// A flick faster than this many reveals per second commits to the direction it
/// was thrown, rather than snapping to whichever end is nearer.
const _flingThreshold = 1.2;

/// Breathing room left either side of the wallet, in screen pixels.
const _sideMargin = 24.0;

/// How far a picked card slides out of the stack, in stage units.
const _liftDistance = 100.0;

/// Tilt of a picked card, in radians. Paired with [_perspective] it throws the
/// exposed end towards the viewer instead of just shearing it.
const _bendAngle = 0.13;
const _perspective = 0.0011;

const _pickDuration = Duration(milliseconds: 380);

double _segment(double t, double begin, double end, Curve curve) =>
    curve.transform(((t - begin) / (end - begin)).clamp(0.0, 1.0));

/// A wallet whose cards are dealt out by the user: tap it to toggle the stack,
/// or drag vertically to pull the cards out and push them back by hand.
/// Everything on screen is drawn with Flutter primitives - no image assets.
class WalletCards extends StatefulWidget {
  const WalletCards({super.key});

  @override
  State<WalletCards> createState() => _WalletCardsState();
}

class _WalletCardsState extends State<WalletCards>
    with SingleTickerProviderStateMixin {
  final _money = NumberFormat('#,##0', 'en_US');

  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 950),
    reverseDuration: const Duration(milliseconds: 700),
  );

  /// Index of the card currently pulled out of the stack, if any.
  int? _selected;

  /// Cards can only be picked once the stack is actually fanned out.
  bool get _isOpen => _controller.value > 0.9;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleCard(int index) {
    setState(() => _selected = _selected == index ? null : index);
  }

  void _clearSelection() {
    if (_selected != null) setState(() => _selected = null);
  }

  /// A tap that misses every card either puts the picked one back, or opens and
  /// closes the wallet when nothing is picked.
  void _onBackgroundTap() {
    if (_selected != null) {
      _clearSelection();
    } else {
      _toggle();
    }
  }

  void _toggle() {
    if (_controller.value > 0.5) {
      _controller.reverse();
      _clearSelection();
    } else {
      _controller.forward();
    }
  }

  /// Drags the stack directly: pulling up feeds the reveal and pushing down
  /// returns it, so the cards track the finger one to one.
  void _onDragUpdate(DragUpdateDetails details, double extent) {
    if (extent <= 0) return;
    _clearSelection();
    _controller.value -= (details.primaryDelta ?? 0) / extent;
  }

  void _onDragEnd(DragEndDetails details, double extent) {
    if (extent <= 0) return;

    final velocity = -details.velocity.pixelsPerSecond.dy / extent;
    if (velocity.abs() >= _flingThreshold) {
      _controller.fling(velocity: velocity);
    } else if (_controller.value > 0.5) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // The stage is scaled to fit, so a drag measured in screen pixels has
        // to be converted before it can move cards in stage space.
        final scale = math.min(
          (constraints.maxWidth - _sideMargin * 2) /
              WalletMetrics.content.width,
          constraints.maxHeight / WalletMetrics.content.height,
        );
        final extent = scale.isFinite && scale > 0
            ? WalletMetrics.tuckedOffset(0) * scale
            : 0.0;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _onBackgroundTap,
          onVerticalDragUpdate: (details) => _onDragUpdate(details, extent),
          onVerticalDragEnd: (details) => _onDragEnd(details, extent),
          child: RepaintBoundary(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final t = _controller.value;

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    // Every decorative CustomPaint is wrapped in an
                    // IgnorePointer: a CustomPaint carrying a painter reports
                    // hitTestSelf as `painter.hitTest(position) ?? true`, so
                    // left alone it would swallow taps meant for the cards.
                    IgnorePointer(
                      child: CustomPaint(
                        painter: WalletBackdropPainter(glow: 0.72 + 0.28 * t),
                      ),
                    ),
                    // Positioned.fill so the stage is handed tight constraints
                    // and actually scales up; a loose parent leaves it at 1:1.
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: _sideMargin,
                        ),
                        child: FittedBox(
                          // Only the content rect is sized to the screen, but
                          // the whole stage still paints: Clip.none lets the
                          // shadows spill past the margin instead of being cut.
                          child: SizedBox.fromSize(
                            size: WalletMetrics.content.size,
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  left: -WalletMetrics.content.left,
                                  top: -WalletMetrics.content.top,
                                  width: WalletMetrics.stage,
                                  height: WalletMetrics.stage,
                                  child: _buildWallet(t),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildWallet(double t) {
    return Stack(
      // The balance sits above the stage origin so it stays clear of the top
      // card at full lift; without this the stage would clip it away.
      clipBehavior: Clip.none,
      children: [
        const Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(painter: WalletBackPanelPainter()),
          ),
        ),
        Positioned.fill(
          child: ClipPath(
            clipper: const _PocketClipper(),
            child: Stack(
              children: [
                for (var i = 0; i < walletCardStack.length; i++)
                  _buildCard(i, t),
              ],
            ),
          ),
        ),
        // The leather sits over the cards visually, but must not intercept
        // their taps - the wallet-level gesture handles hits on it instead.
        const Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(painter: WalletPocketPainter()),
          ),
        ),
        _buildTotal(t),
        _buildHint(t),
      ],
    );
  }

  /// Total balance readout, keyed to the same reveal that deals the cards: it
  /// rises and fades in as the wallet opens and retreats as it closes. The
  /// figure is the running sum of what the cards themselves are showing, so it
  /// counts up in step with them rather than on a timer of its own.
  Widget _buildTotal(double t) {
    final appear = _segment(t, 0.30, 0.90, Curves.easeOutCubic);

    var total = 0.0;
    for (var i = 0; i < walletCardStack.length; i++) {
      total += _amountOf(i, t);
    }

    return Positioned(
      left: WalletMetrics.content.left,
      width: WalletMetrics.content.width,
      top: WalletMetrics.totalTop,
      child: IgnorePointer(
        child: Opacity(
          opacity: appear,
          child: Transform.translate(
            offset: Offset(0, 24 * (1 - appear)),
            child: Column(
              children: [
                Text(
                  'TOTAL BALANCE',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.62),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 3.4,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '\$${_money.format(total)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.4,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Affordance for the gesture, gone by the time the stack is half open.
  Widget _buildHint(double t) {
    return Positioned(
      left: 0,
      right: 0,
      top: 676,
      child: IgnorePointer(
        child: Opacity(
          opacity: (1 - t * 3.5).clamp(0.0, 1.0),
          child: Text(
            'Tap or drag the wallet',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.55),
              fontSize: 22,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.4,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }

  /// How far card [index] has left the pocket. Rises a little above 1 at the
  /// top of the spring, so callers that need a ratio have to clamp it.
  double _revealOf(int index, double t) =>
      _segment(t, _dealBegin[index], _dealEnd[index], _cardEase);

  /// The balance shown on card [index] as it deals out. Settled by the time the
  /// card is most of the way open, so closing the wallet does not spin the
  /// digits back down in front of the user.
  double _amountOf(int index, double t) =>
      walletCardStack[index].amount *
      Curves.easeOutCubic
          .transform((_revealOf(index, t) / 0.85).clamp(0.0, 1.0));

  Widget _buildCard(int index, double t) {
    final data = walletCardStack[index];
    final reveal = _revealOf(index, t);
    final amount = _amountOf(index, t);

    return Positioned(
      key: ValueKey(data.brand),
      left: WalletMetrics.cardLeft,
      top: WalletMetrics.cardTops[index] +
          WalletMetrics.tuckedOffset(index) * (1 - reveal),
      width: WalletMetrics.cardWidth,
      height: WalletMetrics.cardHeight,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(end: _selected == index ? 1 : 0),
        duration: _pickDuration,
        curve: Curves.easeOutBack,
        builder: (context, pick, _) =>
            _buildCardBody(index, data, amount, reveal, pick),
      ),
    );
  }

  /// The card face itself. [pick] is 0 flat in the stack and 1 pulled out, and
  /// may stray slightly outside that range at the ends of the spring. Only the
  /// chosen card moves: it rises towards the cards it is layered under, so it
  /// covers part of the one above it, the way pulling a card up in a real
  /// wallet does.
  Widget _buildCardBody(
    int index,
    WalletCardData data,
    double amount,
    double reveal,
    double pick,
  ) {
    return Transform(
      // Pivots where the card is still gripped by the pocket, so the exposed
      // end is what swings towards the viewer.
      alignment: Alignment.bottomCenter,
      transform: Matrix4.identity()
        ..setEntry(3, 2, _perspective)
        ..translateByDouble(0, -_liftDistance * pick, 0, 1)
        ..rotateX(-_bendAngle * pick),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(WalletMetrics.cardRadius),
          gradient: data.gradient,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF08061F)
                  .withValues(alpha: (0.55 + 0.22 * pick).clamp(0.0, 1.0)),
              blurRadius: 26 + 20 * pick,
              offset: Offset(0, 12 + 12 * pick),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(WalletMetrics.cardRadius),
          child: CustomPaint(
            painter: WalletCardFacePainter(
              color: data.sheenColor,
              sheen: data.sheen,
            ),
            // The gloss rides the card's own travel, so it tracks the finger.
            foregroundPainter: WalletCardSweepPainter(
              color: data.sheenColor,
              progress: reveal.clamp(0.0, 1.0),
              bend: pick,
            ),
            child: Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                // Opaque, not the default deferToChild: the gap between the
                // logo and the balance has nothing to hit, and taps landing
                // there would otherwise fall through to the wallet.
                behavior: HitTestBehavior.opaque,
                // Only the sliver on show is tappable, so the buried part of a
                // card cannot be hit through the leather in front of it.
                onTap: _isOpen ? () => _toggleCard(index) : null,
                child: SizedBox(
                  width: WalletMetrics.cardWidth,
                  height: WalletMetrics.stripHeight(index),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 34),
                    child: Row(
                      children: [
                        WalletBrandMark(brand: data.brand),
                        const Spacer(),
                        Text(
                          '\$${_money.format(amount)}',
                          style: TextStyle(
                            color: data.foreground,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Keeps the cards inside the pocket silhouette below its mouth, so a parked
/// card cannot peek out through the rounded bottom corners.
class _PocketClipper extends CustomClipper<Path> {
  const _PocketClipper();

  @override
  Path getClip(Size size) {
    final aboveTheMouth = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, WalletMetrics.pocket.top + 2));

    final insidePocket = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          WalletMetrics.pocket.deflate(WalletMetrics.pocketClipInset),
          const Radius.circular(WalletMetrics.pocketClipRadius),
        ),
      );

    return Path.combine(PathOperation.union, aboveTheMouth, insidePocket);
  }

  @override
  bool shouldReclip(_PocketClipper oldClipper) => false;
}
