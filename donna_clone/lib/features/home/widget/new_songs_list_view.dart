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

class NewSongsListView extends StatelessWidget {
  const NewSongsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ExploreCubit, ExploreState>(
      builder: (context, state) {
        if (state.news is ApiFetchInitial) {
          return const SizedBox();
        }

        if (state.news is ApiFetchLoading) {
          return const Center(child: AppCircularLoader());
        }

        if (state.news is ApiFetchFailure) {
          return Center(
              child: AppText(
            LocalizationKeys.errorLoadingXSongs.name.tr(
              context: context,
              args: [
                LocalizationKeys.exploreNew.name.tr(context: context),
              ],
            ),
          ));
        }

        final currentStateForNewSongs = state.news as ApiFetchSuccess<List<SongModel>>;

        final songs = currentStateForNewSongs.data;

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
      },
    );
  }
}
