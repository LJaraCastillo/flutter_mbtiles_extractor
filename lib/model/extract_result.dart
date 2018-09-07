part of mbtiles_extractor;

class ExtractResult {
  ///Extraction result code.
  ///
  ///Example:
  ///```dart
  /// if (extractResult.code == MbtilesExtractor.RESULT_OK){
  /// //Do stuff
  /// }
  ///```
  int code;

  ///Contains the text message if the extraction finished with an error or the
  ///path to the folder where the tiles are located.
  ///
  ///This value is important if the desiredPath value was not set
  ///in the ExtractRequest instance.
  String data;

  ///Contains the metadata of the readed file.
  MBTilesMetadata metadata;

  ///List of tiles returned as reference for the extracted file.
  List<Tile> tiles;

  ExtractResult(this.code, this.data, this.tiles);

  ExtractResult.fromMap(Map map) {
    this.code = map['code'];
    this.data = map['data'];
    this.metadata = map['metadata'] != null
        ? MBTilesMetadata.fromMap(map["metadata"])
        : null;
    List<Tile> tiles = [];
    List tilesMapList = map['tiles'];
    tilesMapList.forEach((tileMap) {
      tiles.add(new Tile.fromMap(tileMap));
    });
    this.tiles = tiles;
  }

  bool isSuccessful() {
    if (code == MBTilesExtractor.RESULT_OK) return true;
    return false;
  }

  Map<String, dynamic> toMap() {
    return {
      'code': this.code,
      'path': this.data,
      'metadata': this.metadata,
      'tiles': this.tiles,
    };
  }
}
