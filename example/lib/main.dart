import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mbtiles_extractor/mbtiles_extractor.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String extractionResult = 'Unknown';

  @override
  void initState() {
    super.initState();
    _extractMBTilesFile();
  }

  Future<void> _extractMBTilesFile() async {
    ExtractResult extractResult;
    try {
      extractResult = await MbtilesExtractor.extractMBTilesFile(
        new ExtractRequest(
          "/storage/emulated/0/Download/volcan_villarica.mbtiles",
          desiredPath: "/storage/emulated/0/Download/tiles/",
          requestPermissions: true,
          removeAfterExtract: false,
          stopOnError: true,
          returnReference: true,
        ),
      );
    } catch (ex, st) {
      print(ex);
      print(st);
    }
    print(extractResult);
    setState(() {
      extractionResult = extractResult.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('MBTilesExtractor example app'),
        ),
        body: new Center(
          child: new Text(
            'Extraction Result:\n $extractionResult\n',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
