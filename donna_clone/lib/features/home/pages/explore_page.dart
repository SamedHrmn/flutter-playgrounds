import 'package:donna_clone/app/constant/color_constants.dart';
import 'package:donna_clone/app/enum/localization_keys.dart';
import 'package:donna_clone/app/util/app_sizer.dart';
import 'package:donna_clone/features/home/cubit/explore_cubit.dart';
import 'package:donna_clone/features/home/cubit/explore_state.dart';
import 'package:donna_clone/features/home/managers/explore_page_manager.dart';
import 'package:donna_clone/features/home/widget/new_songs_list_view.dart';
import 'package:donna_clone/features/home/widget/popular_songs_list_view.dart';
import 'package:donna_clone/shared/widget/button/app_button.dart';
import 'package:donna_clone/shared/widget/empty_box.dart';
import 'package:donna_clone/shared/widget/text/app_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> with ExplorePageManager, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        _ExploreSongTypeSelection(
          onSelected: updateExploreType,
          selectedType: selectedExplore,
        ),
        const EmptyBox(height: 18),
        Expanded(
          child: switch (selectedExplore) {
            ExploreType.popular => const _ExplorePopularTabbar(),
            ExploreType.news => const NewSongsListView(),
          },
        ),
      ],
    );
  }
}

class _ExplorePopularTabbar extends StatefulWidget {
  const _ExplorePopularTabbar();

  @override
  State<_ExplorePopularTabbar> createState() => _ExplorePopularTabbarState();
}

class _ExplorePopularTabbarState extends State<_ExplorePopularTabbar> {
  final List<LocalizationKeys> explorePopularNames = [
    LocalizationKeys.explorePopularWeekly,
    LocalizationKeys.explorePopularMonthly,
    LocalizationKeys.explorePopularAllTime,
  ];

  ExplorePopularTimes selectedTime = ExplorePopularTimes.weekly;

  Future<void> updateSelectedTime(int index) async {
    setState(() {
      selectedTime = ExplorePopularTimes.values[index];
    });

    await context.read<ExploreCubit>().getExplorePopularSongs(timeRange: selectedTime);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: ExplorePopularTimes.values.length,
      child: Column(
        children: [
          TabBar(
            dividerHeight: 0,
            indicatorColor: Colors.transparent,
            onTap: updateSelectedTime,
            physics: const NeverScrollableScrollPhysics(),
            isScrollable: false,
            indicatorPadding: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            labelPadding: AppSizer.pageHorizontalPadding,
            tabs: ExplorePopularTimes.values.indexed
                .map(
                  (e) => Tab(
                    height: AppSizer.scaleHeight(32),
                    child: Column(
                      children: [
                        Expanded(
                          child: AppText(
                            explorePopularNames[e.$1].name.tr(context: context),
                            color: selectedTime == e.$2 ? ColorConstants.gradientColors[1] : Colors.white.withOpacity(0.6),
                          ),
                        ),
                        AnimatedContainer(
                          duration: Durations.medium1,
                          margin: EdgeInsets.zero,
                          height: 1,
                          color: selectedTime == e.$2 ? ColorConstants.gradientColors[1] : Colors.white.withOpacity(0.6),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: ExplorePopularTimes.values
                  .map(
                    (e) => const PopularSongsListView(),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExploreSongTypeSelection extends StatefulWidget {
  const _ExploreSongTypeSelection({
    required this.onSelected,
    required this.selectedType,
  });

  final void Function(ExploreType type) onSelected;
  final ExploreType selectedType;

  @override
  State<_ExploreSongTypeSelection> createState() => __ExploreSongTypeSelectionState();
}

class __ExploreSongTypeSelectionState extends State<_ExploreSongTypeSelection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSizer.pageHorizontalPadding,
      child: Row(
        children: [
          AppButton(
            onPressed: () async => widget.onSelected(ExploreType.popular),
            gradient: widget.selectedType == ExploreType.popular ? const LinearGradient(colors: ColorConstants.gradientColors) : null,
            padding: AppSizer.padOnly(l: 24, r: 24, t: 8, b: 8),
            radius: 16,
            buttonColor: widget.selectedType == ExploreType.popular ? null : ColorConstants.background3,
            child: AppText(
              LocalizationKeys.explorePopular.name.tr(context: context),
            ),
          ),
          const EmptyBox(width: 8),
          AppButton(
            onPressed: () async => widget.onSelected(ExploreType.news),
            radius: 16,
            padding: AppSizer.padOnly(l: 24, r: 24, t: 8, b: 8),
            buttonColor: widget.selectedType == ExploreType.news ? null : ColorConstants.background3,
            gradient: widget.selectedType == ExploreType.news ? const LinearGradient(colors: ColorConstants.gradientColors) : null,
            child: AppText(
              LocalizationKeys.exploreNew.name.tr(context: context),
            ),
          ),
        ],
      ),
    );
  }
}
