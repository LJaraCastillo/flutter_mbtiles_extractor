library flutter_mbtiles_extractor;

import 'dart:async';

import 'package:flutter/services.dart';

part 'src/extract_request.dart';

part 'src/extract_result.dart';

part 'src/mbtiles_metadata.dart';

part 'src/tile.dart';

typedef void ProgressEvent(int total, int progress);

class MBTilesExtractor {
  static const MethodChannel _methodChannel =
      const MethodChannel('flutter_mbtiles_extractor');

  static const EventChannel _eventChannel =
      const EventChannel('flutter_mbtiles_extractor_progress');

  /// Stream subscription to receive progress update events.
  static StreamSubscription _progressStreamSubscription;

  /// Make the call to extract the .mbtiles file using the [extractRequest]
  /// parameters.
  /// * [extractRequest] This object is used to configure the extraction behavior.
  static Future<ExtractResult> extractMBTilesFile(
    String pathToDB, {
    String desiredPath,
    bool requestPermissions,
    bool removeAfterExtract,
    bool stopOnError,
    bool returnReference,
    bool onlyReference,
    Schema schema,
    ProgressEvent onProgress,
  }) async {
    var request = ExtractRequest(pathToDB,
        desiredPath: desiredPath,
        requestPermissions: removeAfterExtract,
        removeAfterExtract: removeAfterExtract,
        stopOnError: stopOnError,
        returnReference: returnReference,
        onlyReference: onlyReference,
        schema: schema);
    final bool isGranted =
        await _methodChannel.invokeMethod("requestPermissions");
    if (isGranted) {
      return _launchExtraction(request, onProgress);
    }
    return ExtractResult(2, "Storage permissions not granted", []);
  }

  /// Launches the extraction of the tiles from the file.
  static Future<ExtractResult> _launchExtraction(
      ExtractRequest extractRequest, ProgressEvent onProgress) {
    Completer<ExtractResult> completer = Completer();
    if (onProgress != null) {
      _registerProgressStream(onProgress);
    }
    _methodChannel
        .invokeMethod('extractMBTilesFile', extractRequest.toMap())
        .then((result) {
      final extractResult = ExtractResult.fromMap(result);
      _progressStreamSubscription.cancel();
      completer.complete(extractResult);
    });
    return completer.future;
  }

  /// Register the progress stream subscription.
  static _registerProgressStream(ProgressEvent onProgress) {
    _progressStreamSubscription =
        _eventChannel.receiveBroadcastStream().map((data) {
      return data != null ? data as Map : Map();
    }).listen((event) {
      int total = event['total'];
      int progress = event['progress'];
      if (total != null && progress != null) onProgress(total, progress);
    });
  }
}
