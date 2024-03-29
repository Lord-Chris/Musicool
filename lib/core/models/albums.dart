import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:hive_flutter/adapters.dart';

part 'albums.g.dart';

@HiveType(typeId: 2)
class AlbumList {
  @HiveField(0)
  int numberOfAlbums;
  @HiveField(1)
  List<Album> albums;
  AlbumList({required this.numberOfAlbums, required this.albums});
}

@HiveType(typeId: 5)
class Album {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  Uint8List? artwork;
  @HiveField(4)
  int index;
  @HiveField(5)
  int numberOfSongs;
  @HiveField(6, defaultValue: false)
  bool isPlaying;
  @HiveField(7)
  List<String?>? trackIds;

  Album({
    required this.id,
    required this.title,
    this.artwork,
    required this.numberOfSongs,
    required this.index,
    this.isPlaying = false,
    this.trackIds,
  });

  Uint8List? getArtWork() {
    try {
      if (artwork != null) {
        RandomAccessFile file = File.fromRawPath(artwork!).openSync();
        file.closeSync();
        return artwork;
      }
      return null;
    } catch (e) {
      // print(e.toString());
      return null;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artwork': artwork?.toList(),
      'index': index,
      'numberOfSongs': numberOfSongs,
      'isPlaying': isPlaying,
      'trackIds': trackIds,
    };
  }

  factory Album.fromMap(Map<String, dynamic> map) {
    return Album(
      id: map['id'],
      title: map['title'],
      artwork:
          map['artwork'] != null ? Uint8List.fromList(map['artwork']) : null,
      index: map['index']?.toInt(),
      numberOfSongs: map['numberOfSongs']?.toInt(),
      isPlaying: map['isPlaying'] ?? false,
      trackIds: map['trackIds'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Album.fromJson(String source) => Album.fromMap(json.decode(source));
}
