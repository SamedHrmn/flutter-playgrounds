import 'package:donna_clone/app/constant/color_constants.dart';
import 'package:donna_clone/app/enum/localization_keys.dart';
import 'package:donna_clone/app/util/app_sizer.dart';
import 'package:donna_clone/shared/widget/button/app_inkwell_button.dart';
import 'package:donna_clone/shared/widget/empty_box.dart';
import 'package:donna_clone/shared/widget/text/app_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SelectMoodList extends StatefulWidget {
  const SelectMoodList({super.key});

  @override
  State<SelectMoodList> createState() => _SelectMoodListState();
}

class _SelectMoodListState extends State<SelectMoodList> {
  final moods = [
    LocalizationKeys.moodHappy,
    LocalizationKeys.moodConfident,
    LocalizationKeys.moodMotivational,
  ];

  LocalizationKeys? selectedMood;

  void updateMood(int index) {
    setState(() {
      selectedMood = moods[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: AppSizer.pageHorizontalPadding,
          child: Row(
            children: [
              AppText(
                LocalizationKeys.selectMood.name.tr(context: context),
              ),
              AppText(
                " (${LocalizationKeys.optional.name.tr(context: context)})",
              ),
            ],
          ),
        ),
        SizedBox(
          height: AppSizer.scaleHeight(85),
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: AppSizer.allPadding(16),
            itemBuilder: (context, index) {
              return moodButton(
                moods[index],
                index,
                context,
                onItemSelected: updateMood,
              );
            },
            separatorBuilder: (context, index) => const EmptyBox(width: 16),
            itemCount: moods.length,
          ),
        ),
      ],
    );
  }

  AppInkwellButton moodButton(
    LocalizationKeys mood,
    int index,
    BuildContext context, {
    required void Function(int index) onItemSelected,
  }) {
    return AppInkwellButton(
      onTap: () => onItemSelected(index),
      borderRadius: BorderRadius.circular(16),
      color: mood == selectedMood ? ColorConstants.primary1 : Colors.white.withOpacity(0.2),
      padding: AppSizer.horizontalPadding(16),
      child: Center(
        child: AppText(
          mood.name.tr(context: context),
        ),
      ),
    );
  }
}
