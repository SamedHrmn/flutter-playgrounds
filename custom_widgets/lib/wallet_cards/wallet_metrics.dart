import 'package:flutter/painting.dart';

/// Every coordinate of the wallet composition lives in a fixed [stage] square
/// that is scaled to the available space, so the artwork keeps its proportions
/// on any screen.
class WalletMetrics {
  const WalletMetrics._();

  static const double stage = 760;

  static const double cardLeft = 159;
  static const double cardWidth = 452;
  static const double cardHeight = 240;
  static const double cardRadius = 28;

  /// Resting tops, ordered back to front.
  static const List<double> cardTops = [211, 272, 330];

  static const Rect pocket = Rect.fromLTWH(134, 415, 500, 229);
  static const double pocketRadius = 56;

  /// How far the stitch line sits inside the pocket edge.
  static const double stitchInset = 17;
  static const double stitchRadius = pocketRadius - stitchInset;

  /// The cards are clipped to this deflated pocket so nothing escapes through
  /// the rounded bottom corners while they are parked inside.
  static const double pocketClipInset = 4;
  static const double pocketClipRadius = pocketRadius - pocketClipInset;

  static const Rect backPanel = Rect.fromLTWH(138, 299, 492, 340);
  static const double backRadius = 54;

  static const double embossRadius = 63;
  static const Offset embossCenter = Offset(384, 530);

  /// The slice of the stage worth sizing to the screen. The rest of the square
  /// is empty backdrop, so fitting the whole thing leaves the wallet marooned
  /// in the middle. The top edge clears the balance readout, which in turn
  /// leaves room for the highest card at full lift.
  static const Rect content = Rect.fromLTRB(134, -24, 634, 712);

  /// Where the total balance readout sits, above the fanned cards.
  static const double totalTop = -8;

  /// Height of the sliver of card [index] that stays visible once the stack is
  /// fanned out. The front card shows more because the pocket starts below it.
  static double stripHeight(int index) {
    final bottom = index == cardTops.length - 1 ? pocket.top : cardTops[index + 1];
    return bottom - cardTops[index];
  }

  /// Vertical offset that parks card [index] out of sight inside the pocket.
  static double tuckedOffset(int index) => pocket.top + 6 - cardTops[index];
}
