import 'package:donna_clone/app/components/text/base_text.dart';
import 'package:donna_clone/app/constant/color_constants.dart';
import 'package:donna_clone/app/enum/localization_keys.dart';
import 'package:donna_clone/app/navigation/app_navigator.dart';
import 'package:donna_clone/app/util/app_sizer.dart';
import 'package:donna_clone/locator.dart';
import 'package:donna_clone/shared/widget/button/app_button.dart';
import 'package:donna_clone/shared/widget/button/app_inkwell_button.dart';
import 'package:donna_clone/shared/widget/text/app_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SelectGenreBottomSheet extends StatefulWidget {
  const SelectGenreBottomSheet({super.key});

  @override
  State<SelectGenreBottomSheet> createState() => _SelectGenreBottomSheetState();
}

class _SelectGenreBottomSheetState extends State<SelectGenreBottomSheet> {
  final genreMore = [
    "16-bit",
    "16-bit celtic",
    "2-step",
    "2-step country",
    "2-step surf",
    "accordion drill",
    "accordion rap",
  ];

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderRadius: AppSizer.borderRadius,
      borderSide: BorderSide.none,
    );

    return SizedBox(
      height: AppSizer.screenHeight * 0.66,
      child: Column(
        children: [
          _header(context),
          searchField(inputBorder),
          Expanded(
            child: genreMoreList(),
          ),
          doneButton(context),
        ],
      ),
    );
  }

  Padding doneButton(BuildContext context) {
    return Padding(
      padding: AppSizer.pageHorizontalPadding + AppSizer.verticallPadding(12),
      child: SizedBox(
        width: double.maxFinite,
        child: AppButton(
          onPressed: () async {
            getIt<AppNavigator>().goBack(context);
          },
          padding: AppSizer.verticallPadding(20),
          radius: 12,
          buttonColor: ColorConstants.primary1,
          child: const AppText(
            "Done",
            appTextWeight: AppTextWeight.semibold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  ListView genreMoreList() {
    return ListView.separated(
      padding: AppSizer.horizontalPadding(36) + AppSizer.verticallPadding(32),
      itemBuilder: (context, index) {
        return AppText(
          genreMore[index],
          fontSize: 18,
          textAlign: TextAlign.start,
        );
      },
      separatorBuilder: (context, index) => Divider(
        color: Colors.white.withOpacity(0.2),
        height: AppSizer.scaleHeight(32),
      ),
      itemCount: genreMore.length,
    );
  }

  Padding searchField(OutlineInputBorder inputBorder) {
    return Padding(
      padding: AppSizer.pageHorizontalPadding,
      child: TextFormField(
        decoration: InputDecoration(
          hintText: 'Search',
          isDense: true,
          hintStyle: const AppText('').textStyle.copyWith(
                color: Colors.white.withOpacity(0.4),
              ),
          prefixIcon: Padding(
            padding: AppSizer.padOnly(l: 24, r: 8),
            child: Icon(
              Icons.search_rounded,
              size: AppSizer.scaleWidth(36),
              color: Colors.white.withOpacity(0.4),
            ),
          ),
          border: inputBorder,
          filled: true,
          fillColor: ColorConstants.background3,
        ),
      ),
    );
  }

  Padding _header(BuildContext context) {
    return Padding(
      padding: AppSizer.padOnly(l: 24, t: 12),
      child: Row(
        children: [
          AppText(
            LocalizationKeys.selectGenre.name.tr(context: context),
            fontSize: 20,
          ),
          AppText(
            " (${LocalizationKeys.optional.name.tr(context: context)})",
            color: ColorConstants.textWhite.withOpacity(0.6),
          ),
          const Spacer(),
          AppInkwellButton(
            onTap: () {
              getIt<AppNavigator>().goBack(context);
            },
            color: Colors.transparent,
            padding: AppSizer.allPadding(12),
            child: Icon(
              Icons.close_rounded,
              size: AppSizer.scaleWidth(32),
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
