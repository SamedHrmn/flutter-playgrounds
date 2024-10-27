import 'package:donna_clone/app/constant/color_constants.dart';
import 'package:donna_clone/app/enum/localization_keys.dart';
import 'package:donna_clone/app/util/app_sizer.dart';
import 'package:donna_clone/shared/widget/button/app_inkwell_button.dart';
import 'package:donna_clone/shared/widget/empty_box.dart';
import 'package:donna_clone/shared/widget/text/app_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AdvancedOptionsCard extends StatefulWidget {
  const AdvancedOptionsCard({super.key, required this.onExpand});

  final void Function(bool expand) onExpand;

  @override
  State<AdvancedOptionsCard> createState() => _AdvancedOptionsCardState();
}

class _AdvancedOptionsCardState extends State<AdvancedOptionsCard> {
  bool hasExpand = false;

  void updateExpand() {
    setState(() {
      hasExpand = !hasExpand;
    });
    widget.onExpand(hasExpand);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppSizer.pageHorizontalPadding,
      decoration: BoxDecoration(
        color: ColorConstants.background3,
        borderRadius: AppSizer.borderRadius,
      ),
      child: Column(
        children: [
          InkWell(
            onTap: updateExpand,
            child: Padding(
              padding: AppSizer.allPadding(16),
              child: Row(
                children: [
                  AppText(LocalizationKeys.advancedOptionsTitle.name.tr(context: context)),
                  const Spacer(),
                  AppInkwellButton(
                    color: Colors.white.withOpacity(0.4),
                    onTap: updateExpand,
                    child: Icon(
                      hasExpand ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedSize(
            duration: Durations.medium1,
            child: hasExpand ? const _AdvancedOptionsContent() : const SizedBox(),
          ),
        ],
      ),
    );
  }
}

class _AdvancedOptionsContentHeader extends StatelessWidget {
  const _AdvancedOptionsContentHeader({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppText(
          text,
          fontSize: 18,
        ),
        AppText(
          " (${LocalizationKeys.optional.name.tr(context: context)})",
          color: ColorConstants.textWhite.withOpacity(0.6),
        ),
      ],
    );
  }
}

class _AdvancedOptionsContent extends StatelessWidget {
  const _AdvancedOptionsContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSizer.padOnly(l: 24, r: 24, t: 16, b: 16),
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: ColorConstants.background1,
        borderRadius: AppSizer.borderRadius,
      ),
      child: Column(
        children: [
          _AdvancedOptionsContentHeader(
            text: LocalizationKeys.advancedOptionsSongName.name.tr(context: context),
          ),
          songNameField(context),
          const EmptyBox(height: 24),
          const _AdvancedOptionsVocalSwitch(),
          const EmptyBox(height: 24),
          _AdvancedOptionsContentHeader(
            text: LocalizationKeys.advancedOptionsVocalGender.name.tr(context: context),
          ),
          const _VocalGenderSelection(),
          const EmptyBox(height: 24),
          _AdvancedOptionsContentHeader(
            text: LocalizationKeys.advancedOptionsRecording.name.tr(context: context),
          ),
          const _AdvancedOptionsRecordingSwitch(),
        ],
      ),
    );
  }

  Padding songNameField(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderRadius: AppSizer.borderRadius,
      borderSide: const BorderSide(color: ColorConstants.primary1),
    );

    return Padding(
      padding: AppSizer.verticallPadding(12),
      child: SizedBox(
        height: AppSizer.scaleHeight(65),
        child: TextFormField(
          decoration: InputDecoration(
            hintText: LocalizationKeys.advancedOptionsSongNameHint.name.tr(context: context),
            hintStyle: const AppText('').textStyle.copyWith(
                  color: Colors.white.withOpacity(0.4),
                  fontWeight: FontWeight.w400,
                ),
            filled: true,
            fillColor: ColorConstants.background3,
            border: inputBorder,
            disabledBorder: inputBorder,
            enabledBorder: inputBorder,
          ),
        ),
      ),
    );
  }
}

class _AdvancedOptionsVocalSwitch extends StatefulWidget {
  const _AdvancedOptionsVocalSwitch();

  @override
  State<_AdvancedOptionsVocalSwitch> createState() => _AdvancedOptionsVocalSwitchState();
}

class _AdvancedOptionsVocalSwitchState extends State<_AdvancedOptionsVocalSwitch> {
  bool hasVocal = false;

  void updateVocal(bool value) {
    setState(() {
      hasVocal = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizer.scaleHeight(65),
      decoration: BoxDecoration(
        color: ColorConstants.background3,
        borderRadius: AppSizer.borderRadius,
      ),
      child: Row(
        children: [
          const EmptyBox(width: 8),
          Switch(
            value: hasVocal,
            activeTrackColor: ColorConstants.primary1,
            trackOutlineWidth: const WidgetStatePropertyAll(0),
            thumbColor: const WidgetStatePropertyAll(Colors.white),
            inactiveTrackColor: Colors.white.withOpacity(0.5),
            thumbIcon: const WidgetStatePropertyAll(
              Icon(
                Icons.circle,
                color: Colors.white,
              ),
            ),
            onChanged: updateVocal,
          ),
          const EmptyBox(width: 8),
          AppText(LocalizationKeys.advancedOptionsVocal.name.tr(context: context)),
        ],
      ),
    );
  }
}

class _VocalGenderSelection extends StatefulWidget {
  const _VocalGenderSelection();

  @override
  State<_VocalGenderSelection> createState() => __VocalGenderSelectionState();
}

class __VocalGenderSelectionState extends State<_VocalGenderSelection> {
  final genders = ["Male", "Female", "Random"];

  String? selectedGender;

  void updateVocalGender(int itemIndex) {
    setState(() {
      selectedGender = genders[itemIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSizer.padOnly(t: 16),
      child: Row(
        children: genders
            .map(
              (e) => _vocalGenderContainer(
                e,
                genders.indexOf(e),
                onItemSelected: updateVocalGender,
              ),
            )
            .toList(),
      ),
    );
  }

  Padding _vocalGenderContainer(
    String text,
    int itemIndex, {
    required void Function(int index) onItemSelected,
  }) {
    return Padding(
      padding: AppSizer.padOnly(r: 16),
      child: AppInkwellButton(
        onTap: () => onItemSelected(itemIndex),
        borderRadius: BorderRadius.circular(16),
        padding: AppSizer.padOnly(l: 16, r: 16, t: 8, b: 8),
        color: text == selectedGender ? ColorConstants.primary1 : ColorConstants.background3,
        child: AppText(text),
      ),
    );
  }
}

class _AdvancedOptionsRecordingSwitch extends StatefulWidget {
  const _AdvancedOptionsRecordingSwitch();

  @override
  State<_AdvancedOptionsRecordingSwitch> createState() => __AdvancedOptionsRecordingSwitchState();
}

class __AdvancedOptionsRecordingSwitchState extends State<_AdvancedOptionsRecordingSwitch> {
  int selectedRecordingIndex = 0;

  void updateRecording(int i) {
    setState(() {
      selectedRecordingIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSizer.padOnly(t: 16),
      child: Row(
        children: [
          Expanded(child: _recordingContainer("Studio", 0)),
          const EmptyBox(width: 32),
          Expanded(child: _recordingContainer("Live (Concert)", 1)),
        ],
      ),
    );
  }

  Widget _recordingContainer(String text, int itemIndex) {
    return AppInkwellButton(
      onTap: () => updateRecording(itemIndex),
      color: Colors.transparent,
      child: Container(
        height: AppSizer.scaleHeight(65),
        padding: AppSizer.pageHorizontalPadding,
        decoration: BoxDecoration(
          color: ColorConstants.background3,
          borderRadius: AppSizer.borderRadius,
        ),
        child: Row(
          children: [
            Expanded(
              child: AppText(
                text,
                textAlign: TextAlign.start,
              ),
            ),
            Container(
              width: AppSizer.scaleWidth(32),
              height: AppSizer.scaleWidth(32),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: AnimatedContainer(
                  duration: Durations.short4,
                  color: itemIndex == selectedRecordingIndex ? ColorConstants.primary1 : Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
