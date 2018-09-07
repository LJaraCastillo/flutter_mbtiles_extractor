library mbtiles_extractor;

import 'dart:async';
import 'package:flutter/services.dart';
part 'package:flutter_mbtiles_extractor/model/extract_request.dart';
part 'package:flutter_mbtiles_extractor/model/extract_result.dart';
part 'package:flutter_mbtiles_extractor/model/tile.dart';
part 'package:flutter_mbtiles_extractor/model/mbtiles_metadata.dart';

class MBTilesExtractor {
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