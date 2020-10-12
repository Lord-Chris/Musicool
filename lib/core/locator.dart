import 'package:get_it/get_it.dart';
import 'package:music_player/core/models/music.dart';
import 'package:music_player/core/utils/controls.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:music_player/core/view_models/albums_model.dart';
import 'package:music_player/core/view_models/artists_model.dart';
import 'package:music_player/core/view_models/playingmodel.dart';
import 'package:music_player/core/view_models/songs_model.dart';

GetIt locator = GetIt.instance;

void setUpLocator() {
  locator.registerFactory(() => PlayingProvider());
  locator.registerFactory(() => AlbumsModel());
  locator.registerFactory(() => ArtistsModel());
  locator.registerFactory(() => SongsModel());
  locator.registerLazySingleton(() => SharedPrefs());
  locator.registerLazySingleton(() => Music());
  locator.registerLazySingleton(() => AudioControls());
}
