class TrackList {
  List<Track> tracks;

  TrackList({this.tracks});

  factory TrackList.fromJson(Map<String, dynamic> json) {
    // print(json);
    return TrackList(tracks: parseTrack(json['list']));
  }

  static List<Track> parseTrack(List list) {
    return list?.map((track) => Track.fromMap(track))?.toList();
  }

  Map<String, dynamic> toJson() => {
        'list': tracks.map((track) => track.toMap()).toList(),
      };
}

class Track {
  final String id, title, displayName, artist, album, duration, artWork, size;
  final String filePath;
  final int index;
  bool isFavorite;

  Track({
    this.index,
    this.id,
    this.title,
    this.displayName,
    this.artist,
    this.album,
    this.duration,
    this.artWork,
    this.size,
    this.filePath,
    this.isFavorite = false,
  });

  String toTime() {
    int minute =
        DateTime.fromMillisecondsSinceEpoch(int.parse(duration)).minute;
    int second =
        DateTime.fromMillisecondsSinceEpoch(int.parse(duration)).second;
    return second.toString().length == 1 ? '$minute:0$second' :'$minute:$second';
  }

  set favorite(bool val) {
    isFavorite = val;
    print('fav is $isFavorite');
  }

  bool get favorite => isFavorite;

  factory Track.fromMap(Map<String, dynamic> map) {
    return Track(
      index: map['index'],
      id: map['id'],
      title: map['title'],
      displayName: map['displayName'],
      album: map['album'],
      artist: map['artist'],
      duration: map['duration'],
      artWork: map['artWork'],
      size: map['size'],
      filePath: map['path'],
      isFavorite: map['isFavorite'],
    );
  }

  Map<String, dynamic> toMap() => {
        'index': index,
        'id': id,
        'title': title,
        'displayName': displayName,
        'album': album,
        'artist': artist,
        'duration': duration,
        'artWork': artWork,
        'size': size,
        'path': filePath,
        'isFavorite': favorite,
      };
}