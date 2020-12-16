import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:music_player/app/locator.dart';
import 'package:music_player/core/models/track.dart';

import '../class_util.dart';
import '../music_util.dart';
import 'controls_util.dart';
import '../sharedPrefs.dart';

class NewAudioControls extends ChangeNotifier implements IAudioControls {
  static NewAudioControls _audioControls;
  SharedPrefs _prefs = locator<SharedPrefs>();
  Music _music = locator<IMusic>();
  AssetsAudioPlayer _player;
  int index;
  // Track nextSong;

  @override
  PlayerState state;

  @override
  List<String> recent;

  // @override
  List<Track> _songs;

  set songs(List<Track> value) {
    _songs = value;
    playlist = Playlist(
      audios: _songs.map((e) => ClassUtil.toAudio(e)).toList(),
      startIndex: index,
    );
  }

  List<Track> get songs => _songs;
  Playlist playlist;

  static Future<NewAudioControls> getInstance() async {
    if (_audioControls == null) {
      NewAudioControls placeHolder = NewAudioControls();
      await placeHolder.init();
      _audioControls = placeHolder;
    }
    return _audioControls;
  }

  @override
  Future<void> init() async {
    _player = AssetsAudioPlayer.withId('Music Player');
    index = _music.songs.indexWhere((song) => song.id == nowPlaying.id) ?? 0;
    songs = _music.songs;
    recent = _prefs.recentlyPlayed.toList();

    // await playinginit();
    //
  }

  Future<void> playinginit() async {
    try {
      // _player = AssetsAudioPlayer.withId('Music Player');
      await _player.open(
        playlist,
        headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
        playInBackground: PlayInBackground.disabledRestoreOnForeground,
        respectSilentMode: true,
        showNotification: true,
        audioFocusStrategy:
            AudioFocusStrategy.request(resumeAfterInterruption: true),
        notificationSettings: NotificationSettings(
          nextEnabled: true,
          prevEnabled: true,
          stopEnabled: false,
          playPauseEnabled: true,
          customNextAction: (player) => next(),
          customPrevAction: (player) => previous(),
        ),
      );
      _player.setLoopMode(LoopMode.none);
    } catch (e) {
      print('\n\nPLAYINGINIT ERROR: \n\n' + e.toString());
    }
  }

  @override
  Future<void> playAndPause() async {
    try {
      String id = _player?.current?.value?.audio?.audio?.metas?.id;
      if (id == null) {
        await playinginit();
        print('1');
      } else {
        if (id == nowPlaying?.id) {
          await _player.playOrPause();
          print('2');
        } else {
          // await _player.();
          // await playinginit().catchError((e) {
          //   print(e.toString());
          // });
          if (_player.playlist?.audios?.last != playlist?.audios?.last &&
              _player.playlist?.audios?.first != playlist?.audios?.first) {
            await playinginit().catchError((e) {
              print(e.toString());
            });
            print('3.5');
          } else {
            await _player.playlistPlayAtIndex(
                _songs.indexWhere((song) => song.id == nowPlaying.id));
            print('3');
            // print(_player.playlist.audios);
          }
        }
      }

      if (id != nowPlaying?.id) {
        _prefs.currentSong = songs.firstWhere((element) => element.id == id,
            orElse: () => nowPlaying ?? _songs[1]);
        throw Exception('the player is not playing the current song');
      }

      // if (playerindex != null && index != null && index != playerindex) {
      //   await _player.play();
      // } else {
      //   await _player.playOrPause();
      // }

    } on AssetsAudioPlayerError catch (e) {
      print('\n\n PLAYANDPAUSE ERROR 1: \n\n' + e.message);
      handleError(e);
    } catch (e) {
      print('\n\n PLAYANDPAUSE ERROR: \n\n' + e.toString());
    }
  }

  @override
  Future<void> next() async {
    // if (nowPlaying != null) {
    //   int oldIndex = songs.indexWhere((song) => song.id == nowPlaying.id);
    //   int newIndex = oldIndex == songs.length - 1 ? 0 : oldIndex += 1;
    //   setIndex(songs[newIndex].id);
    //   // await _player.stop();
    //   await playAndPause();
    // }

    try {
      await _player.next(keepLoopMode: false);
      setIndex(_player.current.value?.audio?.audio?.metas?.id);
    } catch (e) {
      print('\n\n NEXT ERROR: \n\n' + e.toString());
    }
  }

  @override
  Future<void> previous() async {
    // int oldIndex = songs.indexWhere((song) => song.id == nowPlaying.id);
    // int newIndex = oldIndex == 0 ? songs.length - 1 : oldIndex -= 1;
    // setIndex(songs[newIndex].id);
    // // await _player.dispose();
    // await playAndPause();

    try {
      await _player.previous(keepLoopMode: false);
      setIndex(_player.current.value.audio.audio.metas.id);
    } catch (e) {
      print('\n\n PREVIOUS ERROR: \n\n' + e.toString());
    }
  }

  @override
  Future<void> setIndex(String id) async {
    int songIndex = songs.indexWhere((element) => element.id == id);
    print(_songs[songIndex].title);
    _prefs.currentSong = songs[songIndex];
    await Future.delayed(Duration(milliseconds: 200));
    index = songIndex;
  }

  @override
  void toggleRepeat() {
    switch (_prefs.repeat) {
      case 'off':
        _prefs.repeat = 'all';
        break;
      case 'all':
        _prefs.repeat = 'one';
        break;
      case 'one':
        _prefs.repeat = 'off';
        break;
      default:
        _prefs.repeat = 'all';
    }
    print('repeat is ${_prefs.repeat}');
  }

  @override
  void toggleShuffle() {
    if (_prefs.shuffle == true) {
      songs = _music.songs;
      _prefs.shuffle = false;
    } else {
      songs.shuffle();
      _prefs.shuffle = true;
    }
    print('shuffle is ${_prefs.shuffle}');
  }

  @override
  void toggleFav(Track track) {
    List<Track> list = _prefs.favorites;
    List<Track> fav = list.where((element) => element.id == track.id).toList();
    bool checkFav = fav == null || fav.isEmpty ? false : true;
    if (checkFav) {
      list.removeWhere((element) => element.id == track.id);
      _prefs.favorites = list;
    } else {
      list.add(track);
      _prefs.favorites = list;
    }
  }

  @override
  Stream<Track> currentSongStream() async* {
    while (true) {
      await Future.delayed(Duration(milliseconds: 300));
      yield nowPlaying;
    }
  }

  @override
  Future<void> setSliderPosition(double val) async {
    await _player.seek(Duration(milliseconds: val.toInt()));
  }

  void handleError(AssetsAudioPlayerError e) {
    _player.onErrorDo(ErrorHandler(
        error:
            AssetsAudioPlayerError(message: e.message, errorType: e.errorType),
        player: _player,
        currentPosition: null,
        playlist: playlist,
        playlistIndex: index));
  }

  Track get nowPlaying => _prefs.currentSong;
  Stream<Playing> get playerCurrentSong => _player.current;
  Stream<PlayerState> get stateStream => _player.playerState;

  // Stream<Playing> get stateStream => _player.playlistAudioFinished;
  Stream<RealtimePlayingInfos> get currentSong => _player.realtimePlayingInfos;
  Stream<Duration> get sliderPosition => _player.currentPosition;
}

getIndex(String id) {}

// print(_player?.current?.value?.index);
// print(
//     'Player : ${_songs.indexWhere((song) => song.id == nowPlaying.id)}\n\n\n\n');
// if (_player.playlist?.audios?.last != playlist?.audios?.last &&
//     _player.playlist?.audios?.first != playlist?.audios?.first) {
//   print('HERE');
//   await _player.stop();
//   await playinginit();
// } // await _player.playlistPlayAtIndex(songIndex);
// int playerindex = _player.current.value?.index;
// if (playerindex == null) {
//   await _player.play();
// }
// if (playerindex != null && index != null && index != playerindex) {
//   print('1');
//   // await _player.play();
// }
// if (playerindex != null && index != null && index == playerindex) {
//   print('2');
//   await _player.playOrPause();
// }
// String id = _player?.current?.value?.audio?.audio?.metas?.id;
// if (id != nowPlaying?.id) {
//   _prefs.currentSong = songs.firstWhere((element) => element.id == id,
//       orElse: () => nowPlaying ?? _songs[1]);
//   await _player.stop();
//   print('3');
//   await _player.playlistPlayAtIndex(
//       _songs.indexWhere((song) => song.id == nowPlaying.id));
// }

// @override
// void setRecent(String song) {
//   if (_prefs.recentlyPlayed != null) {
//     if (_prefs.recentlyPlayed.length < 5) {
//       recent = _prefs.recentlyPlayed?.toList();
//       if (!_prefs.recentlyPlayed.contains(song)) {
//         recent.insert(0, song);
//         _prefs.recentlyPlayed = recent.toSet();
//       } else {
//         recent.removeWhere((element) => element == song);
//         recent.insert(0, song);
//         _prefs.recentlyPlayed = recent.toSet();
//       }
//     } else {
//       if (!_prefs.recentlyPlayed.contains(song)) {
//         recent.removeLast();
//         recent.insert(0, song);
//         _prefs.recentlyPlayed = recent.toSet();
//       } else {
//         recent.removeWhere((element) => element == song);
//         recent.insert(0, song);
//         _prefs.recentlyPlayed = recent.toSet();
//       }
//     }
//   } else {
//     recent = [];
//     recent.insert(0, song);
//     _prefs.recentlyPlayed = recent.toSet();
//   }
// }
// if (!isPausebutton) {
//   await playinginit();
//   await _player.play();
// } else {
//   if (state == PlayerState.stop || state == null) {
//     await playinginit();
//     await _player.play();
//   } else {
//     await _player.playOrPause();
//   }
// }
// AssetsAudioPlayerError error;
// void onError() {
//   _player.onErrorDo(new ErrorHandler(
//       error: error,
//       player: _player,
//       currentPosition: null,
//       playlist: null,
//       playlistIndex: null));
// }

//   _player.onErrorDo = (handler){
//   handler.player.open(
//       handler.playlist.copyWith(
//         startIndex: handler.playlistIndex
//       ),
//       seek: handler.currentPosition
//   );
// };

/**
 * Audio.file(
          nextSong?.filePath ?? nowPlaying.filePath,
          metas: Metas(
            id: nextSong.id ?? nowPlaying.id,
            title: nextSong.title ?? nowPlaying.title,
            artist: nextSong.artist ?? nowPlaying.artist,
            image: nextSong?.getArtWork() ?? nowPlaying?.getArtWork() != null
                ? MetasImage.file(nextSong?.artWork ?? nowPlaying?.artWork)
                : MetasImage.asset('assets/cd-player.png'),
            onImageLoadFail: MetasImage.asset('assets/cd-player.png'),
          ),
        ),
 */