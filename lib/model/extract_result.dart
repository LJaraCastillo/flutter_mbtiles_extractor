import 'tile.dart';
import 'mbtiles_metadata.dart';

class ExtractResult {
  ///The extraction was completed successfully.
  static const int RESULT_OK = 0;

  ///The *.mbtiles file is corrupt and could not be read.
  static const int RESULT_FILE_CORRUPT = 1;

  ///The given *.mbtiles file does not exists.
  static const int RESULT_FILE_DOES_NOT_EXISTS = 2;

  ///The app was not granted writing permissions, so was impossible to
  ///
  ///Consider using requestPermissions = true in the ExtractionRequest.
  static const int RESULT_NO_WRITE_PERMISSIONS = 3;

  ///Some tile was impossible to read or write in its respective file.
  static const int RESULT_TILE_EXTRACTION_ERROR = 4;

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
    if (code == RESULT_OK) return true;
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
