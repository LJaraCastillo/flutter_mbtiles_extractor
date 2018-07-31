import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_mbtiles_extractor/data/tile.dart';

class MBTilesExtractor {
  static const int RESULT_OK = 0;
  static const int RESULT_FILE_CORRUPT = 1;
  static const int RESULT_FILE_DOES_NOT_EXISTS = 2;
  static const int RESULT_NO_WRITE_PERMISSIONS = 3;
  static const int RESULT_TILE_EXTRACTION_ERROR = 4;
  static const MethodChannel _channel =
      const MethodChannel('flutter_mbtiles_extractor');

  static Future<ExtractResult> extractMBTilesFile(
      ExtractRequest extractRequest) async {
    var requestMap = extractRequest.toMap();
    final bool isGranted = await _channel.invokeMethod("requestPermissions");
    ExtractResult extractResult;
    if (isGranted) {
      final Map mapResult =
          await _channel.invokeMethod('extractMBTilesFile', requestMap);
      extractResult = ExtractResult.fromMap(mapResult);
    } else {
      extractResult =
          new ExtractResult(2, "Storage permissions not granted", []);
    }
    return extractResult;
  }
}

class ExtractRequest {
  ///String path to the *.mbtiles File
  String pathToDB;

  ///Path for the destination folder where the files will be placed
  ///while extracting.
  ///If a path is not given a folder will be created next to the .mbtiles file
  ///with the same name. Consider that if the directory is not writable the
  ///extraction will fail.
  String desiredPath;

  ///Should request storage permissions in Android. Consider that if the
  ///permission are not granted for the app, it will not be possible to create
  ///the folder or files necessary for the extraction.
  ///
  ///The default value is false.
  bool requestPermissions;

  ///Remove the *.mbtiles file after extracting the tiles from it. If occurs an
  ///error the file will not be removed.
  ///
  ///The default value is false.
  bool removeAfterExtract;

  ///Determinate if the extraction is stopped when an error presents. Only
  ///continues if the error is not crucial for the extraction. eg: if false and
  ///one tile could not be extracted then continues with the next one. if true
  ///the extraction will fail even if could continue with other tile.
  ///
  ///The default value is true.
  bool stopOnError;

  ///If true, the file will be read and will return the list of tiles,
  ///but will not extract the files from the db. Also, if true is not
  ///necessary to set returnReference to true.
  ///
  /// The default value is false.
  bool onlyReference;

  ///If true, the extraction will also return the list of tiles.
  ///Consider that an .mbtiles file could have thousand of tiles. Be aware of
  ///memory and performance. If onlyReference the reference will be returned
  ///even if this attribute is false.
  ///
  ///The default value is false.
  bool returnReference;

  ExtractRequest(
    this.pathToDB, {
    this.desiredPath = "",
    this.requestPermissions = false,
    this.removeAfterExtract = false,
    this.stopOnError = true,
    this.onlyReference = false,
    this.returnReference = false,
  });

  ExtractRequest.fromMap(Map<String, dynamic> map) {
    this.pathToDB = map['pathToDB'];
    this.desiredPath = map['desiredPath'];
    this.requestPermissions = map['requestPermissions'];
    this.removeAfterExtract = map['removeAfterExtract'];
    this.stopOnError = map['stopOnError'];
    this.onlyReference = map['onlyReference'];
    this.returnReference = map['returnReference'];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExtractRequest &&
          runtimeType == other.runtimeType &&
          pathToDB == other.pathToDB &&
          desiredPath == other.desiredPath &&
          requestPermissions == other.requestPermissions &&
          removeAfterExtract == other.removeAfterExtract &&
          stopOnError == other.stopOnError &&
          onlyReference == other.onlyReference &&
          returnReference == other.returnReference;

  @override
  int get hashCode =>
      pathToDB.hashCode ^
      desiredPath.hashCode ^
      requestPermissions.hashCode ^
      removeAfterExtract.hashCode ^
      stopOnError.hashCode ^
      onlyReference.hashCode ^
      returnReference.hashCode;

  @override
  String toString() {
    return 'ExtractRequest{pathToDB: $pathToDB, desiredPath: $desiredPath, requestPermissions: $requestPermissions, removeAfterExtract: $removeAfterExtract, stopOnError: $stopOnError, onlyReference: $onlyReference, returnReference: $returnReference}';
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'pathToDB': this.pathToDB != null ? this.pathToDB : "",
      'desiredPath': this.desiredPath != null ? this.desiredPath : "",
      'requestPermissions': this.requestPermissions,
      'removeAfterExtract': this.removeAfterExtract,
      'stopOnError': this.stopOnError,
      'onlyReference': this.onlyReference,
      'returnReference': this.returnReference,
    };
    return map;
  }
}

class ExtractResult {
  ///Extraction result code.
  ///
  ///Example:
  ///```dart
  /// if (extractResult.code == MbtilesExtractor.RESULT_OK) {
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

  ///List of tiles returned as reference for the extracted file.
  List<Tile> tiles;

  ExtractResult(this.code, this.data, this.tiles);

  ExtractResult.fromMap(Map map) {
    this.code = map['code'];
    this.data = map['data'];
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExtractResult &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          data == other.data &&
          tiles == other.tiles;

  @override
  int get hashCode => code.hashCode ^ data.hashCode ^ tiles.hashCode;

  @override
  String toString() {
    return 'ExtractResult{code: $code, path: $data, tiles:$tiles}';
  }

  Map<String, dynamic> toMap() {
    return {
      'code': this.code,
      'path': this.data,
      'tiles': this.tiles,
    };
  }
}
