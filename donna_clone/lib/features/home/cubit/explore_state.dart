import 'package:donna_clone/app/state/api_fetch_state.dart';
import 'package:donna_clone/features/home/data/song_model.dart';
import 'package:equatable/equatable.dart';

enum ExplorePopularTimes {
  weekly,
  monthly,
  allTime,
}

enum ExploreType {
  popular,
  news,
}

class ExploreState extends Equatable {
  final ApiFetchState<List<SongModel>> weekly;
  final ApiFetchState<List<SongModel>> monthly;
  final ApiFetchState<List<SongModel>> allTime;
  final ApiFetchState<List<SongModel>> news;

  const ExploreState({
    this.weekly = const ApiFetchInitial(),
    this.monthly = const ApiFetchInitial(),
    this.allTime = const ApiFetchInitial(),
    this.news = const ApiFetchInitial(),
  });

  ExploreState copyWith({
    ApiFetchState<List<SongModel>>? weekly,
    ApiFetchState<List<SongModel>>? monthly,
    ApiFetchState<List<SongModel>>? allTime,
    ApiFetchState<List<SongModel>>? news,
  }) {
    return ExploreState(
      weekly: weekly ?? this.weekly,
      monthly: monthly ?? this.monthly,
      allTime: allTime ?? this.allTime,
      news: news ?? this.news,
    );
  }

  @override
  List<Object?> get props => [weekly, monthly, allTime, news];
}
