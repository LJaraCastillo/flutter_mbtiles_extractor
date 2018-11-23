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

  /// Stream to receive the progress of the extraction.
  /// An event is delivered in each update, from this event
  /// you can get the progress and the total of tiles to extract.
  /// Example:
  /// 
  /// ```dart
  /// MBTilesExtractor.onProgress().listen((dynamic event) {
  ///   var percent = event["progress"] / event["total"];
  ///   //Do stuff with the progress
  /// });
  /// ```
  static Stream<dynamic> onProgress() {

    return _eventChannel.receiveBroadcastStream();
  }

  /// Make the call to extract the .mbtiles file using the [extractRequest] 
  /// parameters.
  /// * [extractRequest] This object is used to configure the extraction behavior.
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
