import 'package:carousel_slider/carousel_controller.dart';
import 'package:musicool/app/locator.dart';
import 'package:musicool/core/enums/_enums.dart';
import 'package:musicool/core/models/_models.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/core/utils/_utils.dart';
import 'package:musicool/ui/views/base_view/base_model.dart';

class PlayingModel extends BaseModel {
  late List<Track> songsList;
  final _playerService = locator<IPlayerService>();
  final _music = locator<IAudioFileService>();
  final _appAudioService = locator<IAppAudioService>();
  // final _aud = locator<AudioHandler>();
  final controller = CarouselController();

  void onModelReady(Track song, bool play) async {
    // init values
    songsList = _playerService.getCurrentListOfSongs();

    // play song
    if (play) await _playerService.play(song.filePath);
    controller.jumpToPage(songsList.indexOf(current!));
  }

  void toggleFav() {
    _music.setFavorite(current!);
    notifyListeners();
  }

  void onPlayButtonTap() async {
    if (_playerService.isPlaying) {
      await _playerService.pause();
    } else {
      await _playerService.play();
    }
    notifyListeners();
  }

  Future<void> next() async {
    await _playerService.playNext();
    controller.nextPage();
    notifyListeners();
  }

  Future<void> previous() async {
    await _playerService.playPrevious();
    controller.previousPage();
    notifyListeners();
  }

  String getDuration(Duration duration) {
    String time = duration.toString();
    return GeneralUtils.formatDuration(time);
  }

  Future<void> setSliderPosition(double val) async {
    await _playerService
        .updateSongPosition(Duration(milliseconds: val.toInt()));
    notifyListeners();
  }

  void toggleShuffle() {
    _playerService.toggleShuffle();
    notifyListeners();
  }

  void toggleRepeat() {
    _playerService.toggleRepeat();
    notifyListeners();
  }

  Stream<Duration> get sliderPosition => _playerService.currentDuration;
  bool get isPlaying => _playerService.isPlaying;
  Stream<AppPlayerState> get playerStateStream =>
      _appAudioService.playerStateController.stream;
  double get songDuration => current?.duration?.toDouble() ?? 0;
  Track? get current => _appAudioService.currentTrack;
  bool get shuffle => _playerService.isShuffleOn;
  Repeat get repeat => _playerService.repeatState;
}
