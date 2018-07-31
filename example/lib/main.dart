import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mbtiles_extractor/mbtiles_extractor.dart';
import 'package:path_provider/path_provider.dart';

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
      Directory dir = await getApplicationDocumentsDirectory();
      print(dir.path);
      extractResult = await MBTilesExtractor.extractMBTilesFile(
        new ExtractRequest(
          "${dir.path}/volcan_villarica.mbtiles",
          desiredPath: "${dir.path}/tiles/araucania/",
          requestPermissions: true,
          removeAfterExtract: true,
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
