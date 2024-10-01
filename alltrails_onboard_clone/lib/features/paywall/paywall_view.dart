import 'package:alltrails_onboard_clone/core/components/app_scaffold.dart';
import 'package:alltrails_onboard_clone/core/components/empty_box.dart';
import 'package:alltrails_onboard_clone/core/components/text/app_rich_text.dart';
import 'package:alltrails_onboard_clone/core/components/text/app_text.dart';
import 'package:alltrails_onboard_clone/core/constants/asset_constants.dart';
import 'package:alltrails_onboard_clone/core/constants/color_constants.dart';
import 'package:alltrails_onboard_clone/core/enum/string_constant_enum.dart';
import 'package:alltrails_onboard_clone/core/util/app_sizer.dart';
import 'package:alltrails_onboard_clone/features/auth/widget/welcome_auth_button.dart';
import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';

class PaywallView extends StatefulWidget {
  const PaywallView({super.key});

  @override
  State<PaywallView> createState() => _PaywallViewState();
}

class _PaywallViewState extends State<PaywallView> {
  @override
  Widget build(BuildContext context) {
    const double kBackgroundImageHeight = 180;
    const double kBottomButtonContainerHeight = 140;

    return AppScaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: backgroundImage(kBackgroundImageHeight),
          ),
          Positioned(
            top: AppSizer.scaleHeight(kBottomButtonContainerHeight / 2),
            left: AppSizer.scaleWidth(4),
            child: closeButton(),
          ),
          Positioned(
            left: AppSizer.pageHorizontalPadding.left,
            right: AppSizer.pageHorizontalPadding.right,
            top: AppSizer.scaleHeight(kBackgroundImageHeight + 24),
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  allTrailsHeader(),
                  const EmptyBox(height: 16),
                  pageTitle(),
                  const EmptyBox(height: 12),
                  promotionText(context, AppSizer.scaleWidth(17)),
                  const EmptyBox(height: 32),
                  Row(
                    children: [
                      featuresIconsColumn(),
                      const EmptyBox(width: 16),
                      featuresTextColumn(),
                    ],
                  ),
                  const EmptyBox(height: 32),
                  whatsIncludedTextColumn(),
                  whatsIncludedRow(),
                  const EmptyBox(height: kBottomButtonContainerHeight + 24)
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: bottomButtonContainer(kBottomButtonContainerHeight),
          ),
        ],
      ),
    );
  }

  Row whatsIncludedRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        whatsIncludedFeaturesTextColumn(),
        Row(
          children: [
            whatsIncludedFreeItemBuilder(),
            const EmptyBox(width: 12),
            whatsIncludedPremiumItemBuilder(),
          ],
        ),
      ],
    );
  }

  _IncludedFeaturesItemBuilder whatsIncludedPremiumItemBuilder() {
    return _IncludedFeaturesItemBuilder(
      itemCount: 3,
      header: const Icon(Icons.star_border_rounded),
      itemBuilder: (index) {
        final hasCheckList = [true, true, true];

        return _IncludedCheckContainer(
          child: hasCheckList[index] ? null : const SizedBox(),
        );
      },
    );
  }

  _IncludedFeaturesItemBuilder whatsIncludedFreeItemBuilder() {
    return _IncludedFeaturesItemBuilder(
      itemCount: 3,
      headerBackgroundColor: ColorConstants.background,
      header: AppText(
        text: StringConstantEnum.paywallIncludedFree.name,
        appTextWeight: AppTextWeight.regular,
        color: ColorConstants.textBlack,
      ),
      itemBuilder: (index) {
        final hasCheckList = [true, true, true];

        return _IncludedCheckContainer(
          backgroundColor: ColorConstants.background,
          child: hasCheckList[index] ? null : const SizedBox(),
        );
      },
    );
  }

  Column whatsIncludedFeaturesTextColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const EmptyBox(height: 68),
        AppText(
          text: StringConstantEnum.paywallIncluded1.name,
          color: ColorConstants.textBlack,
          appTextWeight: AppTextWeight.regular,
          fontSize: 17,
        ),
        const EmptyBox(height: 24),
        AppText(
          text: StringConstantEnum.paywallIncluded2.name,
          color: ColorConstants.textBlack,
          appTextWeight: AppTextWeight.regular,
          fontSize: 17,
        ),
        const EmptyBox(height: 24),
        AppText(
          text: StringConstantEnum.paywallIncluded3.name,
          color: ColorConstants.textBlack,
          appTextWeight: AppTextWeight.regular,
          fontSize: 17,
        ),
      ],
    );
  }

  Center whatsIncludedTextColumn() {
    return Center(
      child: Column(
        children: [
          AppText(
            text: StringConstantEnum.paywallWhatsIncluded.name,
            color: ColorConstants.textBlack,
          ),
          Icon(
            Icons.keyboard_arrow_down,
            color: ColorConstants.secondary1,
            size: AppSizer.scaleWidth(32),
          ),
        ],
      ),
    );
  }

  AppText allTrailsHeader() {
    return const AppText(
      text: "AllTrails",
      color: ColorConstants.textBlack,
    );
  }

  IconButton closeButton() {
    return IconButton.filled(
      style: const ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(ColorConstants.background),
      ),
      padding: AppSizer.allPadding(4),
      constraints: const BoxConstraints(),
      onPressed: () {},
      icon: Icon(
        Icons.close,
        color: ColorConstants.primary1,
        size: AppSizer.scaleWidth(24),
      ),
    );
  }

  Image backgroundImage(double h) {
    return Image.asset(
      AssetConstants.paywallHeader,
      fit: BoxFit.cover,
      height: AppSizer.scaleHeight(h),
    );
  }

  Container bottomButtonContainer(double h) {
    return Container(
      padding: AppSizer.pageHorizontalPadding,
      height: AppSizer.scaleHeight(h),
      decoration: BoxDecoration(
        boxShadow: kElevationToShadow[6],
        color: ColorConstants.background,
      ),
      child: Column(
        children: [
          Padding(
            padding: AppSizer.padOnly(t: 16, b: 16),
            child: promotionText(
              context,
              AppSizer.scaleWidth(14),
            ),
          ),
          WelcomeAuthButton.text(
            text: StringConstantEnum.paywallButtonText.name,
            buttonColor: ColorConstants.primary2,
          ),
          const EmptyBox(height: 24),
        ],
      ),
    );
  }

  Column featuresTextColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FeaturesRichText(
          text: StringConstantEnum.paywallFeature1.name,
        ),
        const EmptyBox(
          height: 24,
        ),
        _FeaturesRichText(
          text: StringConstantEnum.paywallFeature2.name,
        ),
        const EmptyBox(
          height: 24,
        ),
        _FeaturesRichText(
          text: StringConstantEnum.paywallFeature3.name,
        ),
      ],
    );
  }

  Container featuresIconsColumn() {
    return Container(
      padding: AppSizer.padOnly(t: 5, b: 5, l: 2, r: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: ColorConstants.paywallFeatures,
      ),
      child: const Column(
        children: [
          _FeaturesIcon(
            iconData: Icons.lock_open,
          ),
          EmptyBox(height: 28),
          _FeaturesIcon(
            iconData: Icons.notifications,
          ),
          EmptyBox(height: 28),
          _FeaturesIcon(
            iconData: Icons.star,
          ),
        ],
      ),
    );
  }

  AppText pageTitle() {
    return AppText(
      text: StringConstantEnum.paywallTitle.name,
      color: ColorConstants.primary1,
      fontSize: 32,
    );
  }

  AppRichText promotionText(BuildContext context, double fontSize) {
    return AppRichText(
      text: StringConstantEnum.paywallPromotion.name,
      defaultStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: ColorConstants.textBlack,
            fontWeight: FontWeight.w400,
            fontSize: fontSize,
          ),
      tags: {
        'b': StyledTextTag(
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ColorConstants.textBlack,
                fontSize: fontSize,
              ),
        ),
      },
    );
  }
}

class _IncludedFeaturesItemBuilder extends StatelessWidget {
  const _IncludedFeaturesItemBuilder({
    required this.itemCount,
    required this.header,
    this.headerBackgroundColor,
    required this.itemBuilder,
  });

  final Widget header;
  final Color? headerBackgroundColor;
  final Widget Function(int index) itemBuilder;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: AppSizer.scaleWidth(56),
          height: AppSizer.scaleHeight(56),
          alignment: Alignment.center,
          decoration: ShapeDecoration(
            color: headerBackgroundColor ?? const Color(0xFFa8affd),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
          ),
          child: header,
        ),
        for (int i = 0; i < itemCount; i++) ...{
          itemBuilder.call(i),
        },
      ],
    );
  }
}

class _IncludedCheckContainer extends StatelessWidget {
  const _IncludedCheckContainer({
    this.backgroundColor,
    this.child,
  });

  final Widget? child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizer.scaleWidth(56),
      height: AppSizer.scaleHeight(52),
      color: backgroundColor ?? const Color(0xFFa8affd).withOpacity(0.2),
      child: child ??
          Icon(
            Icons.check,
            size: AppSizer.scaleWidth(24),
            color: const Color(0xFF7582e8),
          ),
    );
  }
}

class _FeaturesIcon extends StatelessWidget {
  const _FeaturesIcon({
    required this.iconData,
  });

  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Icon(
      iconData,
      size: AppSizer.scaleWidth(22),
      color: ColorConstants.background,
    );
  }
}

class _FeaturesRichText extends StatelessWidget {
  const _FeaturesRichText({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return AppRichText(
      text: text,
      defaultStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: ColorConstants.textBlack,
            fontWeight: FontWeight.w400,
            fontSize: AppSizer.scaleWidth(17),
          ),
      tags: {
        'b': StyledTextTag(
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ColorConstants.textBlack,
                fontWeight: FontWeight.w500,
                fontSize: AppSizer.scaleWidth(17),
              ),
        ),
      },
    );
  }
}
