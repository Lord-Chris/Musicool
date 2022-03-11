import 'package:musicool/app/index.dart';
import 'package:musicool/core/models/artists.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/ui/views/base_view/base_model.dart';

class ArtistsModel extends BaseModel {
  final _library = locator<IAudioFileService>();
  final _navigationServicce = locator<INavigationService>();

  List<Artist> get artistList => _library.artists!;

  void onTap(Artist artist) {
    final _tracks = _library.songs!
        .where((element) => artist.trackIds!.contains(element.id))
        .toList();
    _navigationServicce.toNamed(
      Routes.songGroupRoute,
      arguments: [_tracks, artist.name, artist.id],
    );
  }
}
