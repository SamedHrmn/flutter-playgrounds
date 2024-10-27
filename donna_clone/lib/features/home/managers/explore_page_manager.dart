import 'package:donna_clone/features/home/cubit/explore_cubit.dart';
import 'package:donna_clone/features/home/cubit/explore_state.dart';
import 'package:donna_clone/features/home/pages/explore_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin ExplorePageManager on State<ExplorePage> {
  ExploreType selectedExplore = ExploreType.popular;

  Future<void> updateExploreType(ExploreType type) async {
    setState(() {
      selectedExplore = type;
    });

    if (type == ExploreType.news) {
      await context.read<ExploreCubit>().getExploreNewsSongs();
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<ExploreCubit>().getExplorePopularSongs(timeRange: ExplorePopularTimes.weekly);
    });
  }
}
