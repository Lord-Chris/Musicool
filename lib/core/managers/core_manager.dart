import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/services.dart';
import 'package:musicool/app/index.dart';
import 'package:musicool/core/enums/_enums.dart';
import 'package:musicool/core/models/_models.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/core/utils/_utils.dart';
import 'package:musicool/ui/constants/_constants.dart';
import 'package:provider/provider.dart';

class CoreManager extends StatefulWidget {
  final Widget child;
  const CoreManager({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<CoreManager> createState() => _CoreManagerState();
}

class _CoreManagerState extends State<CoreManager> with WidgetsBindingObserver {
  final _appAudioService = locator<IAppAudioService>();
  final _playerService = locator<IPlayerService>();
  final _handler = locator<AudioHandler>();
  final _log = Logger();
  late StreamSubscription<AppPlayerState> _stateSub;

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    AppUpdateUtil.updateApp();
    _setUp();
    _audioSessionSetup();

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _stateSub.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _log.i('APP STATE = $state');
    if (state == AppLifecycleState.inactive) {
      _appAudioService.pause();
      // _stateSub.pause();
    } else if (state == AppLifecycleState.resumed) {
      _appAudioService.resume();
      // _stateSub.resume();
    }
  }

  _audioSessionSetup() {
    AudioSession.instance.then((audioSession) async {
      await audioSession.configure(const AudioSessionConfiguration.music());
      BackgroundAudioSession.handleInterruptions(audioSession);
    });
  }

  _setUp() async {
    _stateSub = _appAudioService.playerStateController.stream.listen(
      (data) async {
        List<Track> list;
        list = _appAudioService.currentTrackList;

        if (data == AppPlayerState.Finished) {
          if (_playerService.repeatState == Repeat.One) {
            await _handler.play();
          } else if (_playerService.repeatState == Repeat.All) {
            await _handler.skipToNext();
          } else if (_playerService.repeatState == Repeat.Off &&
              _appAudioService.currentTrack! != list.last) {
            await _handler.skipToNext();
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<Track?>.value(
      value: _appAudioService.currentTrackController.stream,
      initialData: _appAudioService.currentTrack,
      builder: (context, _) => AnnotatedRegion(
        value: const SystemUiOverlayStyle(
          statusBarColor: AppColors.darkMain,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppColors.darkMain,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: widget.child,
      ),
    );
  }
}
