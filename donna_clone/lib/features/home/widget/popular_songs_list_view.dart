import 'package:donna_clone/app/enum/localization_keys.dart';
import 'package:donna_clone/app/state/api_fetch_state.dart';
import 'package:donna_clone/features/home/cubit/explore_cubit.dart';
import 'package:donna_clone/features/home/cubit/explore_state.dart';
import 'package:donna_clone/features/home/data/song_model.dart';
import 'package:donna_clone/features/home/widget/song_card.dart';
import 'package:donna_clone/shared/widget/app_animated_list_view.dart';
import 'package:donna_clone/shared/widget/app_circular_loader.dart';
import 'package:donna_clone/shared/widget/text/app_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularSongsListView extends StatelessWidget {
  const PopularSongsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExploreCubit, ExploreState>(
      builder: (context, state) {
        final activeTab = context.watch<ExploreCubit>().activeTab;

        switch (activeTab) {
          case ExplorePopularTimes.weekly:
            return _handleWeeklyState(state, context);
          case ExplorePopularTimes.monthly:
            return _handleMonthlyState(state, context);
          case ExplorePopularTimes.allTime:
            return _handleAllTimeState(state, context);
        }
      },
    );
  }

  Widget _handleWeeklyState(ExploreState state, BuildContext context) {
    if (state.weekly is ApiFetchInitial) return const SizedBox();

    if (state.weekly is ApiFetchLoading) return const Center(child: AppCircularLoader());

    if (state.weekly is ApiFetchFailure) {
      return Center(
        child: AppText(
          LocalizationKeys.errorLoadingXSongs.name.tr(
            context: context,
            args: [LocalizationKeys.explorePopularWeekly.name.tr(context: context)],
          ),
        ),
      );
    }

    final songs = (state.weekly as ApiFetchSuccess<List<SongModel>>).data;

    return AppAnimatedListView<SongModel>(
      items: songs,
      itemBuilder: (context, song, index, animation) => FadeTransition(
        opacity: animation,
        child: SongCard(
          item: song,
          index: index,
        ),
      ),
    );
  }

  Widget _handleMonthlyState(ExploreState state, BuildContext context) {
    if (state.monthly is ApiFetchInitial) return const SizedBox();

    if (state.monthly is ApiFetchLoading) return const Center(child: AppCircularLoader());

    if (state.monthly is ApiFetchFailure) {
      return Center(
        child: AppText(
          LocalizationKeys.errorLoadingXSongs.name.tr(
            context: context,
            args: [LocalizationKeys.explorePopularMonthly.name.tr(context: context)],
          ),
        ),
      );
    }

    final songs = (state.monthly as ApiFetchSuccess<List<SongModel>>).data;

    return AppAnimatedListView<SongModel>(
      items: songs,
      itemBuilder: (context, song, index, animation) => FadeTransition(
        opacity: animation,
        child: SongCard(
          item: song,
          index: index,
        ),
      ),
    );
  }

  Widget _handleAllTimeState(ExploreState state, BuildContext context) {
    if (state.allTime is ApiFetchInitial) return const SizedBox();

    if (state.allTime is ApiFetchLoading) return const Center(child: AppCircularLoader());

    if (state.allTime is ApiFetchFailure) {
      return Center(
        child: AppText(
          LocalizationKeys.errorLoadingXSongs.name.tr(
            context: context,
            args: [LocalizationKeys.explorePopularAllTime.name.tr(context: context)],
          ),
        ),
      );
    }

    final songs = (state.allTime as ApiFetchSuccess<List<SongModel>>).data;

    return AppAnimatedListView<SongModel>(
      items: songs,
      itemBuilder: (context, song, index, animation) => FadeTransition(
        opacity: animation,
        child: SongCard(
          item: song,
          index: index,
        ),
      ),
    );
  }
}
