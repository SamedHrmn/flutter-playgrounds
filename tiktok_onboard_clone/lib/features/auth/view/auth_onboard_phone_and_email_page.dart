import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_onboard_clone/core/components/text/app_text.dart';
import 'package:tiktok_onboard_clone/core/constant/color_constants.dart';
import 'package:tiktok_onboard_clone/core/enum/localization_keys.dart';
import 'package:tiktok_onboard_clone/core/util/app_sizer.dart';
import 'package:tiktok_onboard_clone/features/auth/managers/auth_onboard_phone_and_email_page_manager.dart';

import 'package:tiktok_onboard_clone/features/auth/widget/email_tab_body.dart';
import 'package:tiktok_onboard_clone/features/auth/widget/phone_tab_body.dart';

class AuthOnboardPhoneOrEmailPage extends StatefulWidget {
  const AuthOnboardPhoneOrEmailPage({super.key});

  @override
  State<AuthOnboardPhoneOrEmailPage> createState() => _AuthOnboardPhoneOrEmailPageState();
}

class _AuthOnboardPhoneOrEmailPageState extends State<AuthOnboardPhoneOrEmailPage>
    with SingleTickerProviderStateMixin, AuthOnboardPhoneAndEmailPageManager, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        tabBar(context),
        Expanded(
          child: tabBarView(),
        ),
      ],
    );
  }

  Padding tabBarView() {
    return Padding(
      padding: AppSizer.pageHorizontalPadding,
      child: TabBarView(
        controller: tabController,
        children: const [
          PhoneTabBody(),
          EmailTabBody(),
        ],
      ),
    );
  }

  TabBar tabBar(BuildContext context) {
    return TabBar(
      controller: tabController,
      indicatorColor: ColorConstants.textBlack,
      indicatorSize: TabBarIndicatorSize.tab,
      enableFeedback: false,
      splashFactory: NoSplash.splashFactory,
      indicatorPadding: AppSizer.horizontalPadding(16),
      tabs: [
        Tab(
          child: AppText(
            text: LocalizationKeys.signUpPhoneTabText.name.tr(context: context),
            color: activeTabFirst ? null : ColorConstants.textSecondary,
          ),
        ),
        Tab(
          child: AppText(
            text: LocalizationKeys.signUpEmailTabText.name.tr(context: context),
            color: activeTabFirst ? ColorConstants.textSecondary : null,
          ),
        ),
      ],
    );
  }
}
