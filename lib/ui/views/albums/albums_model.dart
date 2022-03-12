import 'package:musicool/app/index.dart';
import 'package:musicool/core/models/albums.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/ui/views/base_view/base_model.dart';

class AlbumsModel extends BaseModel {
  final _library = locator<IAudioFileService>();
  final _navigationServicce = locator<INavigationService>();

  List<Album> get albumList => _library.albums!;

  void onTap(Album album) {
    print(album.trackIds);
    final _tracks = _library.songs!
        .where((element) => album.trackIds!.contains(element.id))
        .toList();
    _navigationServicce.toNamed(
      Routes.songGroupRoute,
      arguments: [_tracks, album],
    );
  }
}
