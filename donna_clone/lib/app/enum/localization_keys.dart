import 'package:donna_clone/app/constant/asset_constants.dart';

enum LocalizationKeys {
  pro("pro"),
  songDescription("songDescription"),
  lyrics("lyrics"),
  navbarCreate("navbar.create"),
  navbarExplore("navbar.explore"),
  navbarLibrary("navbar.library"),
  describeSong("describeSong"),
  describeSongBottom("describeSongBottom"),
  getInspired("getInspired"),
  enterLyrics("enterLyrics"),
  selectMood("selectMood"),
  optional("optional"),
  moodHappy("mood.happy"),
  moodConfident("mood.confident"),
  moodMotivational("mood.motivational"),
  selectGenre("selectGenre"),
  genreRandom("genre.random", assetPath: AssetConstants.imGenreRandom),
  genreBlues("genre.blues", assetPath: AssetConstants.imGenreBlues),
  genreFunk("genre.funk", assetPath: AssetConstants.imGenreFunk),
  genreRap("genre.rap", assetPath: AssetConstants.imGenreRap),
  genrePop("genre.pop", assetPath: AssetConstants.imGenrePop),
  genreClassical("genre.classical", assetPath: AssetConstants.imGenreClassical),
  genreJazz("genre.jazz", assetPath: AssetConstants.imGenreJazz),
  genreMore("genre.more"),
  createWithDescription("createWithDescription"),
  createWithLyrics("createWithLyrics"),
  advancedOptionsTitle("advancedOptions.title"),
  advancedOptionsSongName("advancedOptions.songName"),
  advancedOptionsSongNameHint("advancedOptions.songNameHint"),
  advancedOptionsVocal("advancedOptions.vocal"),
  advancedOptionsVocalGender("advancedOptions.vocalGender"),
  advancedOptionsRecording("advancedOptions.recording"),
  explorePopular("explorePopular"),
  exploreNew("exploreNew"),
  explorePopularWeekly("explorePopularWeekly"),
  explorePopularMonthly("explorePopularMonthly"),
  explorePopularAllTime("explorePopularAllTime"),
  libraryTitle1("libraryTitle1"),
  libraryTitle2("libraryTitle2"),
  libraryButtonText("libraryButtonText"),
  errorLoadingXSongs("errorLoadingXSongs");

  final String name;
  final String? assetPath;
  const LocalizationKeys(this.name, {this.assetPath});
}
