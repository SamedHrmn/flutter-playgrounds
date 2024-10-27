import 'package:donna_clone/app/components/text/base_text.dart';
import 'package:donna_clone/app/constant/color_constants.dart';
import 'package:donna_clone/app/enum/localization_keys.dart';
import 'package:donna_clone/app/util/app_sizer.dart';
import 'package:donna_clone/features/home/managers/create_page_manager.dart';
import 'package:donna_clone/features/home/widget/advanced_options_card.dart';
import 'package:donna_clone/features/home/widget/create_with_description_card.dart';
import 'package:donna_clone/features/home/widget/select_genre_list.dart';
import 'package:donna_clone/features/home/widget/select_mood_list.dart';
import 'package:donna_clone/shared/widget/app_scroll_view.dart';
import 'package:donna_clone/shared/widget/button/app_button.dart';
import 'package:donna_clone/shared/widget/empty_box.dart';
import 'package:donna_clone/shared/widget/text/app_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CreatePage extends StatelessWidget with CreatePageManager {
  const CreatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CreatePageInterited(
      createWithDescriptionCardActiveTabIndex: ValueNotifier(0),
      child: AppScrollView(
        builder: (scrollController) {
          return Column(
            children: [
              const EmptyBox(height: 40),
              const CreateWithDescriptionCard(),
              const EmptyBox(height: 32),
              const SelectMoodList(),
              const EmptyBox(height: 32),
              const SelectGenreList(),
              const EmptyBox(height: 32),
              AdvancedOptionsCard(
                onExpand: (expand) => updateHasExpand(expand, scrollController),
              ),
              const EmptyBox(height: 32),
              const _CreateWithButton(),
              const EmptyBox(height: 32),
              const EmptyBox(
                height: AppSizer.bottomNavbarHeight,
              )
            ],
          );
        },
      ),
    );
  }
}

class _CreateWithButton extends StatelessWidget {
  const _CreateWithButton();

  @override
  Widget build(BuildContext context) {
    final activeTabIndexNotifier = CreatePageInterited.of(context).createWithDescriptionCardActiveTabIndex;

    return Padding(
      padding: AppSizer.pageHorizontalPadding,
      child: SizedBox(
        width: double.maxFinite,
        child: ValueListenableBuilder<int>(
            valueListenable: activeTabIndexNotifier,
            builder: (context, index, _) {
              return AppButton(
                padding: AppSizer.padOnly(t: 20, b: 20),
                buttonColor: index == 0 ? null : ColorConstants.primary2,
                gradient: index == 0
                    ? const LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: ColorConstants.gradientColors,
                      )
                    : null,
                radius: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      index == 0 ? LocalizationKeys.createWithDescription.name.tr(context: context) : LocalizationKeys.createWithLyrics.name.tr(context: context),
                      fontSize: 18,
                      appTextWeight: AppTextWeight.semibold,
                    ),
                    const EmptyBox(width: 8),
                    const Icon(
                      Icons.music_note,
                      color: Colors.white,
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
