import 'package:flutter/material.dart';
import 'package:tiktok_onboard_clone/core/components/text/app_text.dart';
import 'package:tiktok_onboard_clone/core/constant/color_constants.dart';
import 'package:tiktok_onboard_clone/core/constant/country_dialing_codes.dart';
import 'package:tiktok_onboard_clone/core/extension/collection_extensions.dart';
import 'package:tiktok_onboard_clone/core/navigation/app_navigation_manager.dart';
import 'package:tiktok_onboard_clone/core/util/app_sizer.dart';
import 'package:tiktok_onboard_clone/locator.dart';

class PhoneCountryPickerDialog extends StatefulWidget {
  const PhoneCountryPickerDialog({required this.onItemSelected, super.key});

  final void Function(String countryCode, String dialCode) onItemSelected;

  @override
  State<PhoneCountryPickerDialog> createState() => _PhoneCountryPickerDialogState();
}

class _PhoneCountryPickerDialogState extends State<PhoneCountryPickerDialog> {
  late List<Map<String, String>> _sortedCountryData;

  @override
  void initState() {
    super.initState();
    _sortedCountryData = countryDataList;
  }

  void updateSortedCountryByFiltering(String selectedChar) {
    final tempList = <Map<String, String>>[];

    _sortedCountryData = countryDataList;

    for (var i = 0; i < _sortedCountryData.length; i++) {
      if (_sortedCountryData[i]['name']!.contains(selectedChar)) {
        tempList.add(_sortedCountryData[i]);
      }
    }

    setState(() {
      _sortedCountryData = tempList.toSet().toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: AppSizer.pageHorizontalPadding + AppSizer.padOnly(t: 24, b: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: AnimatedSwitcher(
              duration: Durations.long1,
              child: ListView.builder(
                key: UniqueKey(),
                itemCount: _sortedCountryData.length,
                padding: AppSizer.padOnly(l: 8, r: 8, t: 24),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final country = _sortedCountryData[index];
                  return PhoneCountryPickerDialogListItem(
                    countryName: country['name']!,
                    dialCode: country['dial_code']!,
                    onTap: () {
                      widget.onItemSelected(country['code']!, country['dial_code']!);
                      getIt<AppNavigationManager>().goBack(context);
                    },
                  );
                },
              ),
            ),
          ),
          Center(
            child: SizedBox(
              width: AppSizer.scaleWidth(50),
              child: _FilterAlphabeticallyListWheelScrollView(
                onSelectedItemChange: updateSortedCountryByFiltering,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterAlphabeticallyListWheelScrollView extends StatefulWidget {
  const _FilterAlphabeticallyListWheelScrollView({required this.onSelectedItemChange});

  final void Function(String selectedChar) onSelectedItemChange;

  @override
  State<_FilterAlphabeticallyListWheelScrollView> createState() => __FilterAlphabeticallyListWheelScrollViewState();
}

class __FilterAlphabeticallyListWheelScrollViewState extends State<_FilterAlphabeticallyListWheelScrollView> {
  final _alphabet = List.generate(26, (index) => String.fromCharCode(index + 65));
  late FixedExtentScrollController _scrollController;
  double _lastScrollOffset = 0;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController();
    _scrollController.addListener(() {
      if ((_scrollController.offset - _lastScrollOffset).abs() > 20) {
        _scrollController.jumpTo(_lastScrollOffset);
      }
      _lastScrollOffset = _scrollController.offset;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> onSelectedItemChange(int value) async {
    setState(() {
      _selectedIndex = value;
    });
    await Future<void>.delayed(Durations.short2);
    widget.onSelectedItemChange(_alphabet[value]);
  }

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView(
      controller: _scrollController,
      physics: const FixedExtentScrollPhysics(),
      itemExtent: AppSizer.scaleHeight(20),
      useMagnifier: true,
      diameterRatio: 1.2,
      magnification: 1.2,
      overAndUnderCenterOpacity: 0.8,
      squeeze: 0.8,
      onSelectedItemChanged: onSelectedItemChange,
      children: _alphabet
          .mapIndexed(
            (i, e) => AppText(
              text: e,
              color: i == _selectedIndex ? null : ColorConstants.textSecondary,
              isOverflow: true,
              maxLines: 1,
            ),
          )
          .toList(),
    );
  }
}

class PhoneCountryPickerDialogListItem extends StatelessWidget {
  const PhoneCountryPickerDialogListItem({
    required this.countryName,
    required this.dialCode,
    super.key,
    this.onTap,
  });

  final VoidCallback? onTap;
  final String countryName;
  final String dialCode;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Flexible(
              child: AppText(
                text: countryName,
                isOverflow: true,
                textAlign: TextAlign.start,
                maxLines: 1,
              ),
            ),
            AppText(
              text: dialCode,
              isOverflow: true,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
