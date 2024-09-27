import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_onboard_clone/core/components/app_scaffold.dart';
import 'package:tiktok_onboard_clone/core/components/text/app_text.dart';
import 'package:tiktok_onboard_clone/core/constant/color_constants.dart';
import 'package:tiktok_onboard_clone/core/enum/localization_keys.dart';
import 'package:tiktok_onboard_clone/core/enum/onboard_pages.dart';
import 'package:tiktok_onboard_clone/core/util/app_sizer.dart';
import 'package:tiktok_onboard_clone/features/auth/inherited/auth_onboard_view_inherited.dart';
import 'package:tiktok_onboard_clone/features/auth/managers/auth_onboard_view_manager.dart';

class AuthOnboardView extends StatefulWidget {
  const AuthOnboardView({super.key});

  @override
  State<AuthOnboardView> createState() => _AuthOnboardViewState();
}

class _AuthOnboardViewState extends State<AuthOnboardView> with AuthOnboardViewManager {
  @override
  Widget build(BuildContext context) {
    return AuthOnboardViewInherited(
      pageController: pageController,
      child: AppScaffold(
        body: SafeArea(
          child: Column(
            children: [
              onboardAppBar(),
              Expanded(
                child: onboardPageView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PageView onboardPageView() {
    return PageView.builder(
      controller: pageController,
      onPageChanged: updatePageIndex,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => OnboardPages.values[index].toPage(),
    );
  }

  ValueListenableBuilder<int> onboardAppBar() {
    return ValueListenableBuilder<int>(
      valueListenable: pageIndexNotifier,
      builder: (context, index, _) {
        final showTrailing = index == OnboardPages.authOnboardPhoneAndEmailPage.index;

        return AppbarWithBack(
          title: LocalizationKeys.signUpAppBarTitle.name.tr(context: context),
          onBack: onBackPageView,
          trailing: Visibility(
            visible: showTrailing,
            maintainAnimation: !showTrailing,
            maintainSize: !showTrailing,
            maintainState: !showTrailing,
            child: AppInkWellButton.customChild(
              onTap: () {},
              child: Padding(
                padding: AppSizer.allPadding(8),
                child: Container(
                  padding: AppSizer.allPadding(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 2, color: ColorConstants.textSecondary),
                    color: ColorConstants.background,
                  ),
                  child: Icon(
                    Icons.question_mark,
                    color: ColorConstants.textSecondary,
                    size: AppSizer.scaleWidth(18),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AppbarWithBack extends StatelessWidget {
  const AppbarWithBack({
    required this.title,
    required this.onBack,
    super.key,
    this.trailing,
  });

  final String title;
  final Widget? trailing;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSizer.horizontalPadding(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppInkWellButton.icon(
            size: AppSizer.scaleWidth(24),
            iconData: Icons.arrow_back_ios_new,
            onTap: onBack,
          ),
          AppText(
            text: title,
            appTextWeight: AppTextWeight.bold,
            fontSize: 18,
          ),
          trailing ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class AppInkWellButton extends StatelessWidget {
  const AppInkWellButton._({
    this.size,
    this.iconData,
    this.onTap,
    this.padding,
    this.child,
  });

  factory AppInkWellButton.customChild({required Widget child, VoidCallback? onTap}) => AppInkWellButton._(
        onTap: onTap,
        child: child,
      );
  factory AppInkWellButton.icon({required double size, required IconData iconData, VoidCallback? onTap, EdgeInsets? padding}) {
    return AppInkWellButton._(size: size, iconData: iconData, onTap: onTap, padding: padding);
  }

  final double? size;
  final IconData? iconData;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: child ??
          Padding(
            padding: padding ?? AppSizer.allPadding(8),
            child: Icon(iconData, size: size),
          ),
    );
  }
}
