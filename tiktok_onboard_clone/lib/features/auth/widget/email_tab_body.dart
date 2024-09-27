import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:slider_captcha/slider_captcha.dart';
import 'package:styled_text/styled_text.dart';
import 'package:tiktok_onboard_clone/core/components/app_text_form_field.dart';
import 'package:tiktok_onboard_clone/core/components/empty_box.dart';
import 'package:tiktok_onboard_clone/core/components/text/app_rich_text.dart';
import 'package:tiktok_onboard_clone/core/components/text/app_text.dart';
import 'package:tiktok_onboard_clone/core/constant/asset_constants.dart';
import 'package:tiktok_onboard_clone/core/constant/color_constants.dart';
import 'package:tiktok_onboard_clone/core/enum/localization_keys.dart';
import 'package:tiktok_onboard_clone/core/navigation/app_navigation_manager.dart';
import 'package:tiktok_onboard_clone/core/util/app_sizer.dart';
import 'package:tiktok_onboard_clone/core/util/form_validators.dart';
import 'package:tiktok_onboard_clone/features/auth/managers/email_tab_body_manager.dart';
import 'package:tiktok_onboard_clone/features/auth/view/auth_onboard_view.dart';
import 'package:tiktok_onboard_clone/features/auth/widget/onboard_next_button.dart';
import 'package:tiktok_onboard_clone/locator.dart';

class EmailTabBody extends StatefulWidget {
  const EmailTabBody({super.key});

  @override
  State<EmailTabBody> createState() => _EmailTabBodyState();
}

class _EmailTabBodyState extends State<EmailTabBody> with EmailTabBodyManager, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Form(
      key: formKey,
      child: Column(
        children: [
          const EmptyBox(height: 48),
          AppTextFormField(
            hintText: LocalizationKeys.signUpEmailHintText.name.tr(context: context),
            keyboardType: TextInputType.emailAddress,
            onChanged: updateEmail,
            validator: (mail) => validateEmail(mail, context),
          ),
          const EmptyBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: checkboxValue,
                onChanged: updateCheckbox,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeColor: ColorConstants.primary,
                side: const BorderSide(
                  color: ColorConstants.textSecondary2,
                ),
                visualDensity: const VisualDensity(
                  vertical: VisualDensity.minimumDensity,
                  horizontal: VisualDensity.minimumDensity,
                ),
              ),
              const EmptyBox(width: 8),
              Expanded(
                child: AppText(
                  text: LocalizationKeys.signUpEmailNotificationText.name.tr(context: context),
                  fontSize: 14,
                  textAlign: TextAlign.start,
                  appTextWeight: AppTextWeight.regular,
                  color: ColorConstants.textSecondary2,
                ),
              ),
            ],
          ),
          const EmptyBox(height: 24),
          AppRichText(
            text: LocalizationKeys.signUpTermOfServiceText2.name.tr(context: context),
            textAlign: TextAlign.start,
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
          const EmptyBox(
            height: 24,
          ),
          OnboardNextButton(
            buttonIsActive: buttonIsActive,
            onPressed: onPressedNext,
          ),
        ],
      ),
    );
  }
}

class SliderCaptchaDialog extends StatelessWidget {
  const SliderCaptchaDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: AppSizer.pageHorizontalPadding,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: Padding(
        padding: AppSizer.padOnly(t: 16, l: 12, b: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(text: LocalizationKeys.signUpCaptchaDialogTitle.name.tr(context: context)),
                AppInkWellButton.icon(
                  size: 24,
                  iconData: Icons.close,
                  onTap: () {
                    getIt<AppNavigationManager>().goBack(context);
                  },
                ),
              ],
            ),
            Padding(
              padding: AppSizer.padOnly(r: 12),
              child: SizedBox(
                height: AppSizer.scaleHeight(300),
                child: SliderCaptcha(
                  imageToBarPadding: AppSizer.scaleHeight(8),
                  colorBar: ColorConstants.background2,
                  title: LocalizationKeys.signUpCaptchaDialogSliderText.name.tr(context: context),
                  icon: Icon(
                    Icons.double_arrow_outlined,
                    size: AppSizer.scaleWidth(24),
                  ),
                  titleStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: AppSizer.scaleWidth(15),
                        color: ColorConstants.textSecondary,
                      ),
                  image: Image.asset(
                    width: double.maxFinite,
                    AssetConstants.imSliderCaptcha,
                    fit: BoxFit.cover,
                  ),
                  onConfirm: (value) async {
                    if (value) {
                      getIt<AppNavigationManager>().goBack(context);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
