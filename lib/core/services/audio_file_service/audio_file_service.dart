import 'package:musicool/app/index.dart';
import 'package:musicool/core/enums/_enums.dart';
import 'package:musicool/core/models/_models.dart';
import 'package:musicool/core/services/_services.dart';
import 'package:musicool/core/utils/_utils.dart';
import 'package:musicool/ui/constants/_constants.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioFileService implements IAudioFileService {
  final _query = OnAudioQuery();
  final _localStorage = locator<ILocalStorageService>();
  final _log = Logger();
  List<Track>? _songs;
  List<Album>? _albums;
  List<Artist>? _artists;

  @override
  Future<void> fetchAlbums() async {
    try {
      List<AlbumModel> res = await _query.queryAlbums();
      _albums = res.map((e) => ClassUtil.toAlbum(e, res.indexOf(e))).toList();

      await Future.forEach(_albums!, (Album _album) async {
        var list = await fetchMusicFrom(AudioType.Album, _album.id);
        _album.trackIds = list.map((e) => e.id).toList();
        final _items = albums?.where((_e) => _e.id == _album.id).toList();
        if (_items!.isEmpty) return;
        _album.isPlaying = _items[0].isPlaying;
      });

      await Future.forEach(_albums!, (Album e) async {
        Uint8List? art = await fetchArtWorks(int.parse(e.id), AudioType.Album);
        e.artwork = art;
      });

      await _localStorage.writeToBox(ALBUMLIST, _albums);
    } catch (e) {
      _log.e('FETCH ALBUM: $e');
      rethrow;
    }
  }

  @override
  Future<void> fetchArtists() async {
    try {
      List<ArtistModel> res = await _query.queryArtists();
      _artists = res.map((e) => ClassUtil.toArtist(e, res.indexOf(e))).toList();

      await Future.forEach(_artists!, (Artist _artist) async {
        var list = await fetchMusicFrom(AudioType.Artist, _artist.name);
        _artist.trackIds = list.map((e) => e.id).toList();
        final _items = artists?.where((_e) => _e.id == _artist.id).toList();
        if (_items!.isEmpty) return;
        _artist.isPlaying = _items[0].isPlaying;
      });

      await Future.forEach(_artists!, (Artist e) async {
        Uint8List? art =
            await fetchArtWorks(int.parse(e.id), AudioType.Artist);
        e.artwork = art;
      });

      await _localStorage.writeToBox(ARTISTLIST, _artists);
    } catch (e) {
      _log.e('FETCH ARTIST: $e');
      rethrow;
    }
  }

  @override
  Future<void> fetchMusic() async {
    try {
      List<SongModel> res = await _query.querySongs();
      _songs = res.map((e) => ClassUtil.toTrack(e, res.indexOf(e))).toList();

      _songs?.forEach((element) {
        final _tracks = songs?.where((_e) => _e.id == element.id).toList();
        if (_tracks!.isEmpty) return;
        element.isPlaying = _tracks[0].isPlaying;
        element.isFavorite = _tracks[0].isFavorite;
      });

      await Future.forEach(_songs!, (Track e) async {
        Uint8List? art = await fetchArtWorks(int.parse(e.id), AudioType.Track);
        if (art != null) {
          e.artwork = art;
          e.artworkPath = await GeneralUtils.makeArtworkCache(e, art);
        }
      });
      await _localStorage.writeToBox(MUSICLIST, _songs);
    } catch (e) {
      _log.e("FETCH MUSIC: $e");
      rethrow;
    }
  }

  @override
  Future<List<Track>> fetchMusicFrom(AudioType type, Object query) async {
    late AudiosFromType _type;

    switch (type) {
      case AudioType.Album:
        _type = AudiosFromType.ALBUM_ID;
        break;
      case AudioType.Artist:
        _type = AudiosFromType.ARTIST;
        break;
      default:
        _type = AudiosFromType.ALBUM_ID;
    }
    List<SongModel> res = await _query.queryAudiosFrom(_type, query);
    return res.map((e) => ClassUtil.toTrack(e, res.indexOf(e))).toList();
  }

  @override
  Future<Uint8List?> fetchArtWorks(int id, AudioType type) async {
    late ArtworkType _type;
    switch (type) {
      case AudioType.Track:
        _type = ArtworkType.AUDIO;
        break;
      case AudioType.Album:
        _type = ArtworkType.ALBUM;
        break;
      case AudioType.Artist:
        _type = ArtworkType.ARTIST;
        break;
      default:
        _type = ArtworkType.AUDIO;
    }

    Uint8List? art = await _query.queryArtwork(id, _type);
    return art;
  }

  @override
  Future<void> setFavorite(Track song) async {
    final _tracks = songs;

    final _trackIndex = _tracks!.indexWhere((e) => e.id == song.id);
    if (_trackIndex > -1) {
      _tracks[_trackIndex].isFavorite = !song.isFavorite;

      await _localStorage.writeToBox(MUSICLIST, _tracks);
    }
  }

  @override
  Future<void> clearFavourites() async {
    final _tracks = songs;
    _tracks?.forEach((e) => e.isFavorite = false);
    await _localStorage.writeToBox(MUSICLIST, _tracks);
  }

  // Getters
  @override
  List<Album>? get albums =>
      _localStorage.getFromBox<List>(ALBUMLIST, def: []).cast<Album>();

  @override
  List<Artist>? get artists =>
      _localStorage.getFromBox<List>(ARTISTLIST, def: []).cast<Artist>();

  @override
  List<Track>? get songs =>
      _localStorage.getFromBox<List>(MUSICLIST, def: []).cast<Track>();

  @override
  List<Track> get favourites => songs!.where((e) => e.isFavorite).toList();
}
