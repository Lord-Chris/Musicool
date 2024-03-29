import 'package:musicool/core/models/albums.dart';
import 'package:musicool/core/models/artists.dart';
import 'package:musicool/core/models/track.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ClassUtil {
  static Track toTrack(SongModel song, int index) {
    return Track(
      id: song.id.toString(),
      title: song.title,
      album: song.album,
      artist: song.artist ?? "<unknown>",
      displayName: song.displayName,
      duration: song.duration,
      size: song.size,
      filePath: song.data,
      index: index,
    );
  }

  static Album toAlbum(AlbumModel album, int index) {
    return Album(
      id: album.id.toString(),
      title: album.album,
      numberOfSongs: album.numOfSongs,
      index: index,
    );
  }

  static Artist toArtist(ArtistModel artist, int index) {
    return Artist(
      id: artist.id.toString(),
      name: artist.artist,
      numberOfSongs: artist.numberOfTracks,
      numberOfAlbums: artist.numberOfAlbums,
      index: index,
    );
  }
}
