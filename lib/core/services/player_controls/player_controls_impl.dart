import 'dart:math';

// import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:music_player/app/locator.dart';
import 'package:music_player/core/enums/app_player_state.dart';
import 'package:music_player/core/enums/repeat.dart';
import 'package:music_player/core/models/track.dart';
import 'package:music_player/core/services/audio_files/audio_files.dart';
import 'package:music_player/core/services/local_storage_service/i_local_storage_service.dart';
import 'package:music_player/core/utils/general_utils.dart';
import 'package:music_player/core/utils/sharedPrefs.dart';
import 'package:music_player/ui/constants/pref_keys.dart';

import 'player_controls.dart';
import 'testing controls.dart';

class PlayerControlImpl extends IPlayerControls {
  static late PlayerControlImpl _playerImpl;
  AudioPlayer _player = AudioPlayer(playerId: '_player');
  SharedPrefs _prefs = locator<SharedPrefs>();
  IAudioFiles _music = locator<IAudioFiles>();
  ILocalStorageService _localStorage = locator<ILocalStorageService>();
  // TestingControls _controls = TestingControls();

  @override
  Future<IPlayerControls> initPlayer([bool load = false]) async {
    _playerImpl = PlayerControlImpl();
    return _playerImpl;
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> play([String? path]) async {
    try {
      if (path == null) {
        await _player.resume();
        return;
      }
      List<Track> list = _music.songs!;
      list.forEach((element) {
        element.isPlaying = false;
      });
      int index = list.indexWhere((e) => e.filePath == path);
      list[index].isPlaying = true;
      await _localStorage.writeToBox(MUSICLIST, list);
      _player.play(path, isLocal: true);
      assert(
          list.where((e) => e.isPlaying).length == 1, "Playing is more than 1");

      // _playerState = AppPlayerState.Playing;
    } on Exception catch (e) {
      print('PLAY ERROR: $e');
    }
  }

  @override
  Future<Track> playNext(int index, List<Track> _list) async {
    List<Track> list = getCurrentListOfSongs();
    late Track nextSong;
    if (isShuffleOn) {
      nextSong = list.elementAt(Random().nextInt(list.length - 1));
    } else {
      nextSong = index == list.length - 1
          ? list.elementAt(0)
          : list.elementAt(index + 1);
    }
    await play(nextSong.filePath!);
    return nextSong;
  }

  @override
  Future<Track> playPrevious(int index, List<Track> list) async {
    late Track songBefore;
    if (isShuffleOn) {
      songBefore = list.elementAt(Random().nextInt(list.length - 1));
    } else {
      songBefore = index == 0
          ? list.elementAt(list.length - 1)
          : list.elementAt(index - 1);
    }
    await play(songBefore.filePath!);
    return songBefore;
  }

  @override
  Future<void> toggleRepeat(Repeat val) async {
    try {
      // int curVal = Repeat.values.indexOf(val);
      // curVal == Repeat.values.length - 1
      //     ? await _prefs.saveInt(REPEAT, 0)
      //     : await _prefs.saveInt(REPEAT, curVal + 1);
    } catch (e) {
      print('TOGGLE REPEAT: $e');
    }
  }

  @override
  Future<void> toggleShuffle() async {
    // await _prefs.saveBool(SHUFFLE, !isShuffleOn);
  }

  @override
  Track? getCurrentTrack() {
    try {
      List<Track> list = getCurrentListOfSongs();
      return list.firstWhere((e) => e.isPlaying);
    } catch (e) {
      return null;
    }
  }

  @override
  List<Track> getCurrentListOfSongs() {
    final _albums = _music.albums;
    final _artists = _music.artists;
    final _tracks = _music.songs!;

    final _artistIndex = _music.artists?.indexWhere((e) => e.isPlaying);
    final _albumIndex = _music.albums?.indexWhere((e) => e.isPlaying);
    // print(_albumIndex);
    // print(_artistIndex);

    if (_artistIndex! > -1) {
      final _artist = _artists![_artistIndex];
      return _tracks
          .where((element) => _artist.trackIds!.contains(element.id))
          .toList();
    }
    if (_albumIndex! > -1) {
      final _album = _albums![_albumIndex];
      return _tracks
          .where((element) => _album.trackIds!.contains(element.id))
          .toList();
    }
    return _tracks;
  }

  @override
  Future<void> changeCurrentListOfSongs([String? listId]) async {
    // create instances
    final _albums = _music.albums;
    final _artists = _music.artists;

    // set all albums and artist isPlaying value to false
    _albums?.forEach((e) => e.isPlaying = false);
    _artists?.forEach((e) => e.isPlaying = false);

    // check which album or artist to set
    if (listId != null) {
      assert(listId.isNotEmpty, "List Id cannot be empty");
      final _artistIndex = _artists?.indexWhere((e) => e.name == listId);
      final _albumIndex = _albums?.indexWhere((e) => e.id == listId);
      if (_albumIndex! > -1) {
        _albums![_albumIndex].isPlaying = true;
      } else if (_artistIndex! > -1) {
        _artists![_artistIndex].isPlaying = true;
      }
    }

    // upload the new values to local database
    await _localStorage.writeToBox(ALBUMLIST, _albums);
    await _localStorage.writeToBox(ARTISTLIST, _artists);
  }

  @override
  Future<void> updateSongPosition(Duration val) async {
    await _player.seek(val);
  }

  @override
  Future<void> disposePlayer() async {
    // await _player.closeAudioSession();
  }

  @override
  bool get isPlaying => _player.state == PlayerState.PLAYING;

  @override
  Stream<Duration> get currentDuration => _player.onAudioPositionChanged;

  @override
  bool get isShuffleOn => _prefs.readBool(SHUFFLE, def: false);

  @override
  Repeat get repeatState =>
      Repeat.values.elementAt(_prefs.readInt(REPEAT, def: 2));

  @override
  AppPlayerState get playerState =>
      GeneralUtils.formatPlayerState(_player.state);
}
