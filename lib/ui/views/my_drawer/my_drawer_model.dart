import 'package:musicool/app/locator.dart';
import 'package:musicool/core/enums/repeat.dart';
import 'package:musicool/core/models/track.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/core/utils/shared_prefs.dart';
import 'package:musicool/ui/constants/pref_keys.dart';
import 'package:musicool/ui/shared/theme_model.dart';
import 'package:musicool/ui/views/base_view/base_model.dart';

class MyDrawerModel extends BaseModel {
  final _sharedPrefs = locator<SharedPrefs>();
  final _themeChanger = locator<ThemeChanger>();
  final _player = locator<IPlayerService>();

  Future<void> toggleShuffle() async {
    await _player.toggleShuffle();
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    await _sharedPrefs.saveBool(ISDARKMODE, !isDarkMode);
    _themeChanger.isDarkMode = _sharedPrefs.readBool(ISDARKMODE);
    notifyListeners();
  }

  bool get shuffle => _player.isShuffleOn;
  bool get isDarkMode =>
      _sharedPrefs.readBool(ISDARKMODE, def: _themeChanger.isDarkMode);
  Repeat get repeat => _player.repeatState;
  Track? get nowPlaying => _player.getCurrentTrack();
}
