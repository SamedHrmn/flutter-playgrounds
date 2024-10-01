import 'package:alltrails_onboard_clone/core/components/app_scaffold.dart';
import 'package:alltrails_onboard_clone/core/constants/color_constants.dart';
import 'package:alltrails_onboard_clone/core/components/empty_box.dart';
import 'package:alltrails_onboard_clone/core/components/text/app_text.dart';
import 'package:alltrails_onboard_clone/core/enum/sign_up_pages_enum.dart';
import 'package:alltrails_onboard_clone/core/enum/string_constant_enum.dart';
import 'package:alltrails_onboard_clone/core/util/app_sizer.dart';
import 'package:alltrails_onboard_clone/features/auth/inherited/sign_up_view_inhterited.dart';
import 'package:alltrails_onboard_clone/features/auth/manager/sign_up_view_manager.dart';
import 'package:flutter/material.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> with SignUpViewManager {
  @override
  Widget build(BuildContext context) {
    return SignUpViewInhterited(
      pageController: pageController,
      child: AppScaffold(
        body: SafeArea(
          child: Column(
            children: [
              signUpAppBar(),
              pageIndicator(),
              Expanded(
                child: PageView(
                  onPageChanged: updatePageIndex,
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: SignUpPagesEnum.values
                      .map(
                        (e) => e.toWidget(),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Align pageIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        height: AppSizer.scaleHeight(4),
        color: ColorConstants.primary1,
        child: _PageIndicator(
          currentIndex: pageIndex,
          totalLength: SignUpPagesEnum.values.length,
        ),
      ),
    );
  }

  Row signUpAppBar() {
    return Row(
      children: [
        InkWell(
          onTap: onBack,
          child: Padding(
            padding: AppSizer.allPadding(8),
            child: Icon(
              Icons.arrow_back,
              size: AppSizer.scaleWidth(24),
            ),
          ),
        ),
        const Spacer(),
        AppText(
          text: StringConstantEnum.signUpPagesAppBarText.name.replaceFirst("*", "${pageIndex + 1}"),
          color: ColorConstants.textBlack,
        ),
        const Spacer(),
        const EmptyBox(width: 32),
      ],
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({
    required this.currentIndex,
    required this.totalLength,
  });

  final int currentIndex;
  final int totalLength;

  double calculateWidth() {
    double widthFactor = 0;

    if (currentIndex == totalLength - 1) {
      widthFactor = 1.0;
    } else if (currentIndex < totalLength) {
      if (currentIndex == 0) {
        widthFactor = 0.25;
        return widthFactor;
      }
      widthFactor = currentIndex / (totalLength - 1);
    }
    return widthFactor;
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: calculateWidth().clamp(0, 1),
    );
  }
}
