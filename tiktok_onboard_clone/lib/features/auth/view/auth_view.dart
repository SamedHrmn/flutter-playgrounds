import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';
import 'package:tiktok_onboard_clone/core/components/app_scaffold.dart';
import 'package:tiktok_onboard_clone/core/components/empty_box.dart';
import 'package:tiktok_onboard_clone/core/components/text/app_rich_text.dart';
import 'package:tiktok_onboard_clone/core/components/text/app_text.dart';
import 'package:tiktok_onboard_clone/core/constant/asset_constants.dart';
import 'package:tiktok_onboard_clone/core/constant/color_constants.dart';
import 'package:tiktok_onboard_clone/core/enum/localization_keys.dart';
import 'package:tiktok_onboard_clone/core/enum/route_enum.dart';
import 'package:tiktok_onboard_clone/core/navigation/app_navigation_manager.dart';
import 'package:tiktok_onboard_clone/core/util/app_sizer.dart';
import 'package:tiktok_onboard_clone/features/auth/widget/auth_button.dart';
import 'package:tiktok_onboard_clone/locator.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  void routeToAuthOnboardView() {
    getIt<AppNavigationManager>().navigateTo(RouteEnum.authOnboard);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      canPop: false,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: Stack(
            children: [
              Padding(
                padding: AppSizer.pageHorizontalPadding,
                child: pageBody(context),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: pageBottomContainer(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column pageBody(BuildContext context) {
    return Column(
      children: [
        const Spacer(flex: 2),
        headerText(context),
        const EmptyBox(height: 12),
        headerBottomText(context),
        const EmptyBox(height: 32),
        authButtonsColumn(context),
        Expanded(
          flex: 5,
          child: privacyPolicyText(context),
        ),
        const EmptyBox(
          height: 144,
        ),
      ],
    );
  }

  Align privacyPolicyText(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: AppRichText(
        text: LocalizationKeys.signUpTermOfServiceText.name.tr(context: context),
        defaultStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: ColorConstants.textSecondary,
              fontSize: AppSizer.scaleWidth(14),
            ),
        tags: {
          'b': StyledTextTag(
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: ColorConstants.textSecondary2,
                  fontSize: AppSizer.scaleWidth(14),
                ),
          ),
        },
      ),
    );
  }

  Column authButtonsColumn(BuildContext context) {
    return Column(
      children: [
        AuthButton.icon(
          text: LocalizationKeys.signUpEmailOrPhoneButtonText.name.tr(context: context),
          iconData: Icons.person,
          onPressed: () async => routeToAuthOnboardView(),
        ),
        const EmptyBox(height: 12),
        AuthButton.image(
          text: LocalizationKeys.signUpFacebookButtonText.name.tr(context: context),
          imagePath: AssetConstants.icFacebook,
        ),
        const EmptyBox(height: 12),
        AuthButton.image(
          text: LocalizationKeys.signUpAppleButtonText.name.tr(context: context),
          imagePath: AssetConstants.icApple,
        ),
        const EmptyBox(height: 12),
        AuthButton.image(
          text: LocalizationKeys.signUpGoogleButtonText.name.tr(context: context),
          imagePath: AssetConstants.icGoogle,
        ),
        const EmptyBox(height: 12),
        AuthButton.image(
          text: LocalizationKeys.signUpXButtonText.name.tr(context: context),
          imagePath: AssetConstants.icX,
        ),
      ],
    );
  }

  Padding headerBottomText(BuildContext context) {
    return Padding(
      padding: AppSizer.horizontalPadding(16),
      child: AppText(
        text: LocalizationKeys.authTopText.name.tr(context: context),
        color: ColorConstants.textSecondary,
        fontSize: 14,
      ),
    );
  }

  AppText headerText(BuildContext context) {
    return AppText(
      text: LocalizationKeys.signUpForTiktok.name.tr(context: context),
      fontSize: 24,
      appTextWeight: AppTextWeight.bold,
    );
  }

  Container pageBottomContainer(BuildContext context) {
    return Container(
      height: AppSizer.scaleHeight(120),
      padding: AppSizer.padOnly(t: 24),
      decoration: BoxDecoration(
        color: ColorConstants.background2,
        border: Border(
          top: BorderSide(color: ColorConstants.textSecondary.withOpacity(0.2)),
        ),
      ),
      child: pageBottomContainerText(context),
    );
  }

  AppRichText pageBottomContainerText(BuildContext context) {
    return AppRichText(
      text: LocalizationKeys.signUpAlreadyHaveAnAccount.name.tr(context: context),
      defaultStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: ColorConstants.textSecondary2,
          ),
      tags: {
        'b': StyledTextTag(
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: ColorConstants.primary,
                fontWeight: FontWeight.w700,
              ),
        ),
      },
    );
  }
}
