import 'package:donna_clone/app/components/text/base_text.dart';
import 'package:donna_clone/app/constant/color_constants.dart';
import 'package:donna_clone/app/enum/localization_keys.dart';
import 'package:donna_clone/app/util/app_sizer.dart';
import 'package:donna_clone/shared/widget/button/app_inkwell_button.dart';
import 'package:donna_clone/shared/widget/empty_box.dart';
import 'package:donna_clone/shared/widget/text/app_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../managers/create_with_description_card_manager.dart';

class CreateWithDescriptionCard extends StatefulWidget {
  const CreateWithDescriptionCard({
    super.key,
  });

  @override
  State<CreateWithDescriptionCard> createState() => _CreateWithDescriptionCardState();
}

class _CreateWithDescriptionCardState extends State<CreateWithDescriptionCard> with SingleTickerProviderStateMixin, CreateWithDescriptionCardManager {
  @override
  Widget build(BuildContext context) {
    final songDescButtonSize = Size(AppSizer.scaleWidth(160), AppSizer.scaleHeight(84));
    final lyricsButtonSize = Size(AppSizer.scaleWidth(80), AppSizer.scaleHeight(84));

    return SizedBox(
      width: double.maxFinite,
      child: Stack(
        children: [
          SizedBox(
            height: AppSizer.scaleHeight(84),
            child: Flow(
              clipBehavior: Clip.none,
              delegate: _TabFlowDelegate(
                activeTabIndex,
                controller,
              ),
              children: [
                SizedBox(
                  width: songDescButtonSize.width,
                  height: songDescButtonSize.height,
                  child: _songDescriptionButton(context),
                ),
                SizedBox(
                  width: lyricsButtonSize.width,
                  height: lyricsButtonSize.height,
                  child: _lyricsButton(context),
                ),
              ],
            ),
          ),
          AnimatedSize(
            duration: Durations.medium4,
            alignment: Alignment.topCenter,
            curve: Curves.bounceOut,
            child: Padding(
              padding: AppSizer.padOnly(t: songDescButtonSize.height / 2 + 4),
              child: SizedBox(
                width: double.maxFinite,
                child: _cardContent(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardContent(BuildContext context) {
    return Container(
      margin: AppSizer.pageHorizontalPadding,
      padding: AppSizer.allPadding(16),
      decoration: BoxDecoration(
        color: ColorConstants.background1,
        border: Border.all(
          color: activeTabIndex == 0 ? ColorConstants.primary1 : ColorConstants.primary2,
        ),
        borderRadius: AppSizer.borderRadius,
      ),
      child: activeTabIndex == 0 ? _cardContentSongDescription(context) : _cardContentLyrics(context),
    );
  }

  Widget _cardContentLyrics(BuildContext context) {
    const lyricSample = [
      "[Verse 1]",
      "In the world of flavor, a bowl so bright.",
      "Greens and colors shining in the light.",
      "Tomatoes, cucumbers, all so fresh.",
      "Lettuce and spinach, come join to fest.",
      "\n[Bridge]",
      "That's all I want, a bowl of salad.",
      "\n[Chorus]",
      "My lunch salad, you're my midday delight.",
      "Crunchy veggies, so vibrant and light.",
      "Dressing drizzled with a tangy zest.",
    ];

    return Column(
      key: const ValueKey(1),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          LocalizationKeys.enterLyrics.name.tr(context: context),
        ),
        ...lyricSample.map(
          (e) => AppText(
            e,
            color: ColorConstants.textWhite.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _cardContentSongDescription(BuildContext context) {
    return Column(
      key: const ValueKey(0),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: AppText(
                  LocalizationKeys.describeSong.name.tr(context: context),
                  appTextWeight: AppTextWeight.regular,
                ),
              ),
            ),
            AppInkwellButton(
              onTap: () {},
              color: Colors.white.withOpacity(0.1),
              padding: AppSizer.allPadding(8),
              child: AppText(
                LocalizationKeys.getInspired.name.tr(context: context),
                color: ColorConstants.primary1,
              ),
            )
          ],
        ),
        const EmptyBox(height: 8),
        AppText(
          LocalizationKeys.describeSongBottom.name.tr(context: context),
          appTextWeight: AppTextWeight.regular,
          textAlign: TextAlign.start,
          color: ColorConstants.textWhite.withOpacity(0.6),
        ),
        const EmptyBox(height: 140)
      ],
    );
  }

  Widget _songDescriptionButton(BuildContext context) {
    return _CreateSongDescriptionCardTabButton(
      color: ColorConstants.primary1,
      text: LocalizationKeys.songDescription.name.tr(context: context),
      onTap: () => updateActiveTab(0),
    );
  }

  Widget _lyricsButton(BuildContext context) {
    return _CreateSongDescriptionCardTabButton(
      color: ColorConstants.primary2,
      text: LocalizationKeys.lyrics.name.tr(context: context),
      onTap: () => updateActiveTab(1),
    );
  }
}

class _TabFlowDelegate extends FlowDelegate {
  final int activeTabIndex;
  final Animation<double> animation;

  _TabFlowDelegate(this.activeTabIndex, this.animation) : super(repaint: animation);

  @override
  void paintChildren(FlowPaintingContext context) {
    const double scaleFactor = 3;
    final double scaleY = 1.0 + (scaleFactor - 1.0) * animation.value;

    if (activeTabIndex == 0) {
      context.paintChild(
        1,
        transform: Matrix4.translationValues(context.getChildSize(0)!.width + AppSizer.scaleWidth(8), scaleY, 0),
      );
      context.paintChild(
        0,
        transform: Matrix4.translationValues(AppSizer.pageHorizontalPadding.left, -scaleY, 0),
      );
    } else {
      context.paintChild(0, transform: Matrix4.translationValues(AppSizer.pageHorizontalPadding.left, scaleY, 0));
      context.paintChild(
        1,
        transform: Matrix4.translationValues(context.getChildSize(0)!.width + AppSizer.scaleWidth(8), -scaleY, 0),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TabFlowDelegate oldDelegate) => oldDelegate.activeTabIndex != activeTabIndex;

  @override
  Size getSize(BoxConstraints constraints) {
    return Size(AppSizer.scaleWidth(240), AppSizer.scaleHeight(80));
  }
}

class _CreateSongDescriptionCardTabButton extends StatelessWidget {
  const _CreateSongDescriptionCardTabButton({
    required this.color,
    required this.text,
    required this.onTap,
  });

  final Color color;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppSizer.borderRadius,
      child: AnimatedContainer(
        duration: Durations.medium1,
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          borderRadius: AppSizer.borderRadius,
          color: color,
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              blurRadius: 4,
            ),
          ],
        ),
        child: Padding(
          padding: AppSizer.padOnly(t: 10, b: 10, l: 12, r: 12),
          child: AppText(
            text,
            isOverflow: true,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
