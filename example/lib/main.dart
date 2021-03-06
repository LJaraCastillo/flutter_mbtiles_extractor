import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:flutter_mbtiles_extractor/flutter_mbtiles_extractor.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _extractionStatus = 'Select a file to extract';
  bool _isBusy = false;
  File _selectedFile;
  Set<String> inProgress = HashSet<String>();
  ValueNotifier progress = ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    widgets.addAll([
      Text(
        'Extraction Status:\n $_extractionStatus\n',
        textAlign: TextAlign.center,
      ),
      _isBusy
          ? Padding(
              padding: EdgeInsets.all(16.0),
              child: AnimatedBuilder(
                animation: progress,
                builder: (context, _) {
                  return Container(
                    child: LinearProgressIndicator(
                      value: progress.value,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.redAccent),
                    ),
                  );
                },
              ),
            )
          : MaterialButton(
              onPressed: () {
                if (_selectedFile == null || !_selectedFile.existsSync()) {
                  _launchFilePicker();
                } else {
                  _extractMBTilesFile();
                }
              },
              child: Text(_selectedFile != null ? "Extract" : "Select File"),
              color: Colors.blue,
            ),
    ]);
    if (_selectedFile != null && !_isBusy) {
      widgets.add(MaterialButton(
        onPressed: () {
          _clearSelectedFile();
        },
        child: Text("Deselect File"),
        color: Colors.red,
      ));
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('MBTilesExtractor example app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: widgets,
          ),
        ),
      ),
    );
  }

  void _startProgress() {
    _isBusy = true;
    progress.value = null;
  }

  void _stopProgress() {
    _isBusy = false;
    progress.value = null;
  }

  Future<void> _extractMBTilesFile() async {
    String result;
    StreamSubscription<dynamic> subscription;
    try {
      //Get directory of the application. This way works best for iOS.
      //The main point here is that the origin of the file is not relevant,
      //as long as you have access to the file.
      //Add path_provider dependency in example/pubspec.yaml to use the next function
      setState(() {
        _extractionStatus = "Extracting... Please wait!";
        _startProgress();
      });

      Directory appDirectory = await getApplicationDocumentsDirectory();
      print(_selectedFile.path);
      ExtractResult extractResult = await MBTilesExtractor.extractMBTilesFile(
        //Path of the selected file.
      _selectedFile.path,
        //Path of the extraction folder.
        desiredPath: appDirectory.path,
        //Vital in android.
        requestPermissions: true,
        //Deletes the *.mbtiles file after the extraction is completed.
        removeAfterExtract: false,
        //Stops is one tile could not be extracted.
        stopOnError: true,
        //Returns the list of tiles once the extraction is completed.
        returnReference: true,
        //If true the reference of tiles is returned but the extraction is not performed.
        onlyReference: false,
        //The schema of the mbtiles file.
        schema: Schema.XYZ,
        //Progress update callback
        onProgress: (total, progress) {
          var percent = progress / total;
          if (percent == 1.0) {
            _stopProgress();
          } else {
            this.progress.value = percent;
          }
          print("Extraction progress: ${(percent * 100).toStringAsFixed(2)}");
        },
      );
      result = """
      Result Code = ${extractResult.code}
      Extraction Message = ${extractResult.data}
      Tile Count = ${extractResult.tiles.length}
      Metadata = ${extractResult.metadata.toMap()}
      *Tile count only is displayed if reference is being returned
      """;
    } catch (ex, st) {
      print(ex);
      print(st);
    }
    setState(() {
      _extractionStatus = "$result";
      _stopProgress();
    });

    subscription?.cancel();
  }

  void _launchFilePicker() async {
    File file;
    String message = "Selection Cancelled";
    setState(() {
      _startProgress();
    });
    try {
      FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
        allowedFileExtensions: ['mbtiles'],
        allowedUtiTypes: ['cl.ceisufro.fluttermbtilesextractor.mbtiles'],
      );
      final filePath = await FlutterDocumentPicker.openDocument(params: params);
      if (filePath != null && filePath.isNotEmpty) {
        String extension = path.extension(filePath);
        if (extension == ".mbtiles") {
          file = File(filePath);
          message = "Ready to extract";
        } else {
          message = "Selected file is not mbtiles";
        }
      }
    } catch (ex) {
      message = "Selected file is not mbtiles";
    } finally {
      setState(() {
        this._extractionStatus = message;
        this._selectedFile = file;
        this._stopProgress();
      });
    }
  }

  void _clearSelectedFile() {
    setState(() {
      this._selectedFile = null;
      this._extractionStatus = "File de-selected. Select a file to extract";
    });
  }
}
