import 'dart:async';
import 'dart:developer';
import 'package:donna_clone/app/state/api_fetch_state.dart';
import 'package:donna_clone/features/home/cubit/explore_state.dart';
import 'package:donna_clone/features/home/data/song_model.dart';
import 'package:donna_clone/features/home/domain/explore_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExploreCubit extends Cubit<ExploreState> {
  final ExploreRepository exploreRepository;

  ExploreCubit({required this.exploreRepository}) : super(const ExploreState());

  ExplorePopularTimes activeTab = ExplorePopularTimes.weekly;
  ExploreType activeExploreType = ExploreType.popular;

  void _emitStateForTimeRange(ApiFetchState<List<SongModel>> newState, ExplorePopularTimes timeRange) {
    if (timeRange != activeTab) return;

    switch (timeRange) {
      case ExplorePopularTimes.weekly:
        emit(state.copyWith(weekly: newState));
        break;
      case ExplorePopularTimes.monthly:
        emit(state.copyWith(monthly: newState));
        break;
      case ExplorePopularTimes.allTime:
        emit(state.copyWith(allTime: newState));
        break;
    }
  }

  void _emitNewSongState(ExploreState state) {
    if (activeExploreType != ExploreType.news) return;
    emit(state);
  }

  Future<void> getExplorePopularSongs({required ExplorePopularTimes timeRange, bool forceRefresh = false}) async {
    activeTab = timeRange;
    activeExploreType = ExploreType.popular;

    ApiFetchState<List<SongModel>> currentState;

    switch (timeRange) {
      case ExplorePopularTimes.weekly:
        currentState = state.weekly;
        break;
      case ExplorePopularTimes.monthly:
        currentState = state.monthly;
        break;
      case ExplorePopularTimes.allTime:
        currentState = state.allTime;
        break;
    }

    if (currentState is ApiFetchSuccess<List<SongModel>> && !forceRefresh) {
      _emitStateForTimeRange(currentState, timeRange);
      log("getExplorePopularSongs() data fetch from cached state ${currentState.data.length} item");
      return;
    }

    _emitStateForTimeRange(ApiFetchLoading(), timeRange);

    try {
      final response = await exploreRepository.getSongs(exploreType: ExploreType.popular, timeRange: timeRange);

      if (response.isNotEmpty) {
        _emitStateForTimeRange(ApiFetchSuccess(response), timeRange);
        log("getExplorePopularSongs() data fetch from respository ${response.length} item with forceRefresh:$forceRefresh");
      } else {
        _emitStateForTimeRange(const ApiFetchFailure(error: "No data available"), timeRange);
      }
    } catch (e) {
      _emitStateForTimeRange(ApiFetchFailure(error: e.toString()), timeRange);
    }
  }

  Future<void> getExploreNewsSongs({bool forceRefresh = false}) async {
    activeExploreType = ExploreType.news;

    if (state.news is ApiFetchSuccess<List<SongModel>> && !forceRefresh) {
      final cachedState = state.news as ApiFetchSuccess<List<SongModel>>;
      _emitNewSongState(state);
      log("getExploreNewsSongs() data fetch from cached state ${cachedState.data.length} item with forceRefresh$forceRefresh");
      return;
    }

    _emitNewSongState(state.copyWith(news: ApiFetchLoading()));

    try {
      final response = await exploreRepository.getSongs(exploreType: ExploreType.news, timeRange: null);

      if (response.isNotEmpty) {
        _emitNewSongState(state.copyWith(news: ApiFetchSuccess(response)));
        log("getExploreNewsSongs() data fetch from repository ${response.length} item");
      } else {
        _emitNewSongState(state.copyWith(news: const ApiFetchFailure(error: "No news data available")));
      }
    } catch (e) {
      _emitNewSongState(state.copyWith(news: ApiFetchFailure(error: e.toString())));
    }
  }
}
