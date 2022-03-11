import 'dart:typed_data';

import 'package:musicool/core/models/_models.dart';

class HomeMediainfo {
  final Uint8List? art;
  final String? title;
  final String? subTitle;
  final String? duration;
  HomeMediainfo({
    required this.art,
    required this.title,
    required this.subTitle,
    this.duration,
  });

  factory HomeMediainfo.toMediaInfo(dynamic media) {
    if (media is Track) {
      return HomeMediainfo(
        art: media.artwork,
        title: media.displayName ?? media.title,
        subTitle: media.artist,
        duration: media.toTime(),
      );
    } else if (media is Album) {
      return HomeMediainfo(
        art: media.artwork,
        title: media.title,
        subTitle: "${media.numberOfSongs} songs",
      );
    } else {
      media as Artist;
      return HomeMediainfo(
        art: media.artwork,
        title: media.name,
        subTitle: "${media.numberOfSongs} songs",
      );
    }
  }
}
