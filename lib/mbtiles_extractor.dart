library mbtiles_extractor;

import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_mbtiles_extractor/model/extract_request.dart';
import 'package:flutter_mbtiles_extractor/model/extract_result.dart';

export 'model/tile.dart';
export 'model/extract_request.dart';
export 'model/extract_result.dart';
export 'model/mbtiles_metadata.dart';

class MBTilesExtractor {

  static const MethodChannel _methodChannel =
      const MethodChannel('flutter_mbtiles_extractor');

  static const EventChannel _eventChannel =
    const EventChannel('flutter_mbtiles_extractor_progress');


  static Stream<dynamic> onProgress() {

    return _eventChannel.receiveBroadcastStream();
  }

  static Future<ExtractResult> extractMBTilesFile(
      ExtractRequest extractRequest) async {

    var requestMap = extractRequest.toMap();
    final bool isGranted = await _methodChannel.invokeMethod("requestPermissions");
    ExtractResult extractResult;
    if (isGranted) {
      final Map mapResult =
          await _methodChannel.invokeMethod('extractMBTilesFile', requestMap);
      extractResult = ExtractResult.fromMap(mapResult);
    } else {
      extractResult =
          new ExtractResult(2, "Storage permissions not granted", []);
    }
    return extractResult;
  }
}
