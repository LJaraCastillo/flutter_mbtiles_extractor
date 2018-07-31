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
      //Get directory of the application. This way works best for iOS.
      //The main point here is that the origin of the file is not relevant,
      //as long as you have access to the file.
      Directory dir = await getApplicationDocumentsDirectory();
      print(dir.path);
      extractResult = await MBTilesExtractor.extractMBTilesFile(
        new ExtractRequest(
          "${dir.path}/volcan_villarica.mbtiles", //This is the name of the file i was testing.
          desiredPath: "${dir.path}/tiles/araucania/", //Example of final folder
          requestPermissions: true, //Vital in android
          removeAfterExtract: true, //Deletes the +.mbtiles file after the extraction is completed
          stopOnError: true, //Stops is one tile could not be extracted
          returnReference: true, //Returns the list of tiles once the extraction is completed
          onlyReference: false, //If true the reference of tiles is returned but the extraction is not performed
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
