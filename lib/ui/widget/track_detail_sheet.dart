import 'package:audio_service/audio_service.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:musicool/app/index.dart';
import 'package:musicool/core/models/track.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/core/utils/files_utils.dart';
import 'package:musicool/ui/components/_components.dart';
import 'package:musicool/ui/constants/_constants.dart';
import 'package:musicool/ui/shared/_shared.dart';

class TrackDetailSheet extends StatefulWidget {
  final Track track;

  const TrackDetailSheet({Key? key, required this.track}) : super(key: key);

  @override
  State<TrackDetailSheet> createState() => _TrackDetailSheetState();
}

class _TrackDetailSheetState extends State<TrackDetailSheet> {
  final _music = locator<IAudioFileService>();
  final _appAudioService = locator<IAppAudioService>();
  final _navigationService = locator<INavigationService>();
  final _playerService = locator<IPlayerService>();
  final _handler = locator<AudioHandler>();

  @override
  Widget build(BuildContext context) {
    FileUtils _utils = FileUtils(widget.track);
    return Container(
      color: AppColors.main,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const YMargin(10),
          Center(
            child: Container(
              height: 5.h,
              width: 40.w,
              decoration: BoxDecoration(
                color: AppColors.grey,
                borderRadius: BorderRadius.circular(5.r),
              ),
            ),
          ),
          const YMargin(5),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Row(
              children: [
                MediaArt(
                  art: widget.track.artwork,
                  size: 37.r,
                  borderRadius: 10,
                ),
                const XMargin(20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const YMargin(2),
                      Text(
                        widget.track.title,
                        maxLines: 2,
                        style: kBodyStyle.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      const YMargin(2),
                      Text(
                        widget.track.artist,
                        style: kSubBodyStyle.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const XMargin(20),
                Text(
                  widget.track.toTime(),
                  style: kSubBodyStyle.copyWith(
                    color: AppColors.white,
                  ),
                ),
                const XMargin(10),
                IconButton(
                  onPressed: () {
                    _music.setFavorite(widget.track);
                    setState(() {});
                  },
                  icon: Icon(
                    widget.track.isFavorite
                        ? MdiIcons.heart
                        : MdiIcons.heartOutline,
                    size: 22.r,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AppColors.white),
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Icon(
                Icons.play_arrow,
                size: 17.w,
                color: AppColors.white,
              ),
            ),
            title: Text(
              'Play next',
              style: kBodyStyle.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
                height: 1.21,
              ),
            ),
            onTap: () {
              if (_appAudioService.currentTrack == null) {
                _handler.playFromMediaId(widget.track.id, widget.track.toMap());
              } else {
                _playerService.setTrackAsNext(widget.track);
                _navigationService.back();
              }
            },
          ),
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Icon(
                Icons.share,
                size: 17.w,
                color: AppColors.white,
              ),
            ),
            title: Text(
              'Share',
              style: kBodyStyle.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
                height: 1.21,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              _utils.share();
            },
          ),
          ListTile(
            leading: Padding(
              padding: const EdgeInsets.all(5.0),
              child: SvgPicture.asset(
                AppAssets.properties,
                width: 17.w,
              ),
            ),
            title: Text(
              'Properties',
              style: kBodyStyle.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
                height: 1.21,
              ),
            ),
            onTap: () {
              showModalBottomSheet(
                context: context,
                clipBehavior: Clip.hardEdge,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                builder: (__) => MyPropertiesDialog(track: widget.track),
              );
            },
          ),
          // ListTile(
          //   leading: Icon(
          //     MdiIcons.pencil,
          //     size: SizeConfig.textSize(context, 6),
          //     color: Theme.of(context).colorScheme.secondary,
          //   ),
          //   title: Text('Rename'),
          //   onTap: () {
          //     print(track.displayName);
          //     _utils.rename('stuff');
          //   },
          // ),
          // ListTile(
          //   leading: Icon(
          //     MdiIcons.trashCan,
          //     size: SizeConfig.textSize(context, 6),
          //     color: Theme.of(context).colorScheme.secondary,
          //   ),
          //   title: Text('Delete'),
          // ),
        ],
      ),
    );
  }
}

class MyPropertiesDialog extends StatelessWidget {
  const MyPropertiesDialog({
    Key? key,
    required this.track,
  }) : super(key: key);

  final Track track;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.main,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const YMargin(10),
          Center(
            child: Container(
              height: 5.h,
              width: 40.w,
              decoration: BoxDecoration(
                color: AppColors.grey,
                borderRadius: BorderRadius.circular(5.r),
              ),
            ),
          ),
          const YMargin(15),
          MediaArt(
            art: track.artwork,
            size: 51.r,
            borderRadius: 10,
          ),
          Padding(
            padding: EdgeInsets.all(15.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Artist: ',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                      TextSpan(
                        text: track.artist,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                const YMargin(10),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Duration: ',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                      TextSpan(
                        text: track.toTime(),
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                const YMargin(10),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Size: ',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                      TextSpan(
                        text: track.toSize(),
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                const YMargin(10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Location: ',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        track.filePath,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
