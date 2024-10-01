import 'package:alltrails_onboard_clone/core/components/app_scaffold.dart';
import 'package:alltrails_onboard_clone/core/constants/asset_constants.dart';
import 'package:alltrails_onboard_clone/core/constants/color_constants.dart';
import 'package:alltrails_onboard_clone/core/components/empty_box.dart';
import 'package:alltrails_onboard_clone/core/components/text/app_rich_text.dart';
import 'package:alltrails_onboard_clone/core/components/text/app_text.dart';
import 'package:alltrails_onboard_clone/core/enum/route_enum.dart';
import 'package:alltrails_onboard_clone/core/enum/string_constant_enum.dart';
import 'package:alltrails_onboard_clone/core/navigation/app_navigation_manager.dart';
import 'package:alltrails_onboard_clone/core/util/app_sizer.dart';
import 'package:alltrails_onboard_clone/features/auth/widget/typing_text.dart';
import 'package:alltrails_onboard_clone/features/auth/widget/welcome_auth_button.dart';
import 'package:alltrails_onboard_clone/locator.dart';
import 'package:flutter/material.dart';
import 'package:styled_text/styled_text.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      canPop: false,
      body: SafeArea(
        top: false,
        child: Stack(
          fit: StackFit.expand,
          children: [
            backgroundImage(),
            backgroundElevation(),
            Positioned.fill(
              left: AppSizer.pageHorizontalPadding.left,
              right: AppSizer.pageHorizontalPadding.right,
              top: AppSizer.scaleHeight(180),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  animatedTitle(context),
                  titleBottom(),
                  const EmptyBox(height: 24),
                  socialAuthButtonsColumn(),
                  orDividerRow(),
                  createAccountButton(),
                  const EmptyBox(height: 24),
                  alreadyHaveAnAccountRow(),
                  const EmptyBox(height: 24),
                  Expanded(
                    child: privacyPolicyText(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppRichText privacyPolicyText(BuildContext context) {
    return AppRichText(
      text: StringConstantEnum.welcomePrivacyPolicyText.name,
      textAlign: TextAlign.start,
      defaultStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w400,
            color: ColorConstants.secondary1.withOpacity(0.8),
            fontSize: AppSizer.scaleWidth(14),
          ),
      tags: {
        'b': StyledTextTag(
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w400,
                decoration: TextDecoration.underline,
                color: ColorConstants.secondary1.withOpacity(0.8),
                fontSize: AppSizer.scaleWidth(14),
              ),
        ),
      },
    );
  }

  Row alreadyHaveAnAccountRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppText(
          text: StringConstantEnum.welcomeAlreadyHaveAnAccountText.name,
          appTextWeight: AppTextWeight.regular,
        ),
        InkWell(
          onTap: () {},
          child: AppText(
            text: ' ${StringConstantEnum.welcomeLogInText.name}',
            decorationColor: ColorConstants.background,
            textDecoration: TextDecoration.underline,
            appTextWeight: AppTextWeight.regular,
          ),
        ),
      ],
    );
  }

  WelcomeAuthButton createAccountButton() {
    return WelcomeAuthButton.text(
      text: StringConstantEnum.welcomeCreateAccountButtonText.name,
      buttonColor: ColorConstants.primary3,
      textColor: ColorConstants.textBlack,
      onPressed: () async => getIt<AppNavigationManager>().navigateTo(RouteEnum.signUpViewPath),
    );
  }

  Image backgroundImage() {
    return Image.asset(
      AssetConstants.welcomeBackground,
      fit: BoxFit.cover,
    );
  }

  Container backgroundElevation() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: kElevationToShadow[16],
      ),
    );
  }

  AppText titleBottom() {
    return AppText(
      text: StringConstantEnum.welcomeTitleBottomText.name,
      fontSize: 48,
    );
  }

  Widget animatedTitle(BuildContext context) {
    return SizedBox(
      height: AppSizer.scaleHeight(72),
      child: RepaintBoundary(
        child: TypingText(
          letterSpeed: Durations.short2,
          wordSpeed: Durations.extralong1,
          words: [
            StringConstantEnum.welcomeTitleDiscover.name,
            StringConstantEnum.welcomeTitleSave.name,
            StringConstantEnum.welcomeTitleNavigate.name,
          ],
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: AppSizer.scaleWidth(48),
              ),
        ),
      ),
    );
  }

  Column socialAuthButtonsColumn() {
    return Column(
      children: [
        WelcomeAuthButton.icon(
          text: StringConstantEnum.welcomeGoogleButtonText.name,
          iconPath: AssetConstants.icGoogle,
          buttonColor: const Color(0xFF6b9bf1),
        ),
        const EmptyBox(height: 16),
        WelcomeAuthButton.icon(
          text: StringConstantEnum.welcomeFacebookButtonText.name,
          iconPath: AssetConstants.icFacebook,
          buttonColor: const Color(0xFF3f5793),
        ),
        const EmptyBox(height: 16),
        WelcomeAuthButton.icon(
          text: StringConstantEnum.welcomeAppleButtonText.name,
          iconPath: AssetConstants.icApple,
          buttonColor: const Color(0xFFfbfcfd),
          textColor: ColorConstants.textBlack,
        ),
      ],
    );
  }

  Padding orDividerRow() {
    return Padding(
      padding: AppSizer.padOnly(t: 32, b: 32, l: 16, r: 16),
      child: Row(
        children: [
          const Expanded(
            child: Divider(thickness: 1.5),
          ),
          Padding(
            padding: AppSizer.horizontalPadding(8),
            child: AppText(
              text: StringConstantEnum.welcomeDividerOrText.name,
              appTextWeight: AppTextWeight.regular,
            ),
          ),
          const Expanded(
            child: Divider(thickness: 1.5),
          ),
        ],
      ),
    );
  }
}
