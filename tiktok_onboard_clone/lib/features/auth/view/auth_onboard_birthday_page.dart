import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tiktok_onboard_clone/core/components/empty_box.dart';
import 'package:tiktok_onboard_clone/core/components/text/app_text.dart';
import 'package:tiktok_onboard_clone/core/constant/asset_constants.dart';
import 'package:tiktok_onboard_clone/core/constant/color_constants.dart';
import 'package:tiktok_onboard_clone/core/enum/localization_keys.dart';
import 'package:tiktok_onboard_clone/core/extension/datetime_extensions.dart';
import 'package:tiktok_onboard_clone/core/util/app_sizer.dart';
import 'package:tiktok_onboard_clone/features/auth/managers/auth_onboard_birthday_page_manager.dart';
import 'package:tiktok_onboard_clone/features/auth/widget/onboard_next_button.dart';

class AuthOnboardBirthdayPage extends StatefulWidget {
  const AuthOnboardBirthdayPage({super.key});

  @override
  State<AuthOnboardBirthdayPage> createState() => _AuthOnboardBirthdayPageState();
}

class _AuthOnboardBirthdayPageState extends State<AuthOnboardBirthdayPage> with AuthOnboardBirthdayPageManager, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final buttonIsActive = birthDay != null;

    return Padding(
      padding: AppSizer.pageHorizontalPadding,
      child: Column(
        children: [
          const EmptyBox(height: 32),
          birthdayHeaderRow(context),
          const EmptyBox(height: 48),
          birthdayTextColumn(context),
          const EmptyBox(
            height: 24,
          ),
          nextButton(buttonIsActive, context),
          const Spacer(),
          birthdayPicker(),
          const EmptyBox(height: 32),
        ],
      ),
    );
  }

  SizedBox birthdayPicker() {
    return SizedBox(
      height: AppSizer.scaleHeight(250),
      child: CupertinoDatePicker(
        initialDateTime: DateTime.now().subtract(const Duration(days: 365 * 18)),
        maximumDate: DateTime.now(),
        mode: CupertinoDatePickerMode.date,
        dateOrder: DatePickerDateOrder.dmy,
        onDateTimeChanged: updateBirthDay,
      ),
    );
  }

  Widget nextButton(bool buttonIsActive, BuildContext context) {
    return OnboardNextButton(
      buttonIsActive: buttonIsActive,
      onPressed: () async {},
    );
  }

  Column birthdayTextColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: birthDay == null ? LocalizationKeys.signUpBirthdayHintText.name.tr(context: context) : birthDay!.toReadableString(),
          color: ColorConstants.textSecondary,
          fontSize: 15,
        ),
        const EmptyBox(height: 8),
        const Divider(),
      ],
    );
  }

  Row birthdayHeaderRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: LocalizationKeys.signUpBirthdayTitle.name.tr(context: context),
                appTextWeight: AppTextWeight.bold,
                fontSize: 20,
              ),
              const EmptyBox(
                height: 8,
              ),
              Padding(
                padding: AppSizer.padOnly(r: 32),
                child: AppText(
                  text: LocalizationKeys.signUpBirthdayWontBeShownPublicly.name.tr(context: context),
                  appTextWeight: AppTextWeight.regular,
                  textAlign: TextAlign.start,
                  fontSize: 15,
                  color: ColorConstants.textSecondary2,
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: Align(
            alignment: Alignment.centerRight,
            child: Image.asset(
              AssetConstants.icBirthday,
              width: AppSizer.scaleWidth(60),
            ),
          ),
        ),
      ],
    );
  }
}
