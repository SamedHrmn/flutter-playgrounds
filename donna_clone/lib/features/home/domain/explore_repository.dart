import 'package:donna_clone/app/constant/asset_constants.dart';
import 'package:donna_clone/features/home/cubit/explore_state.dart';
import 'package:donna_clone/features/home/data/song_model.dart';

abstract class ExploreRepository {
  Future<List<SongModel>> getSongs({required ExploreType exploreType, required ExplorePopularTimes? timeRange});
}

class ExploreRepositoryImpl extends ExploreRepository {
  @override
  Future<List<SongModel>> getSongs({required ExploreType exploreType, required ExplorePopularTimes? timeRange}) async {
    await Future.delayed(const Duration(seconds: 2));

    final fakeResponseJson = [
      {
        "id": "1",
        "title": "Magische Nacht",
        "imageUrl": AssetConstants.imSong1,
        "author": "Bebbo",
        "count": 16300,
        "likes": 204,
      },
      {
        "id": "2",
        "title": "Break Free",
        "imageUrl": AssetConstants.imSong2,
        "author": "Cmorel",
        "count": 10900,
        "likes": 227,
      },
      {
        "id": "3",
        "title": "Hes My Dad",
        "imageUrl": AssetConstants.imSong3,
        "author": "Phillipcureton",
        "count": 7100,
        "likes": 140,
      },
      {
        "id": "4",
        "title": "Im Vandel Der Zeit",
        "imageUrl": AssetConstants.imSong4,
        "author": "Bebbo",
        "count": 6600,
        "likes": 60,
      },
      {
        "id": "5",
        "title": "Notte Magicka",
        "imageUrl": AssetConstants.imSong5,
        "author": "Bebbo",
        "count": 5600,
        "likes": 66,
      },
    ];

    List<SongModel> songs = [];

    for (var element in fakeResponseJson) {
      final model = SongModel.fromMap(element);
      songs.add(model);
    }

    if (exploreType == ExploreType.popular) {
      switch (timeRange!) {
        case ExplorePopularTimes.allTime:
          final copyList = songs.toList();
          songs.addAll(copyList);
          return songs;
        default:
          return songs;
      }
    }

    return songs;
  }
}
