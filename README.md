# flutter_mbtiles_extractor

Basic plugin to extract the data (png tiles) from an .mbtiles file and
automatically create the folder structure (../folder_name/{z}/{x}/{y}.png).

![example_gif](https://raw.githubusercontent.com/LJaraCastillo/flutter_mbtiles_extractor/master/pictures/example.gif "Example GIF")

## Installation

Import the dependency in the dart file you will use it.

```dart
   import 'package:flutter_mbtiles_extractor/mbtiles_extractor.dart';
```

In Android you need to add permissions to read and write in the storage
of the device. In your project add the following lines to your
**AndroidManifest.xml** file in your project's Android folder.

```xml
       <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
       <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

Remember that on API 23 and later you need to ask to the user to grant
access for this permissions.

## How to use

In the following example you can see how to realize a extraction of
one file.

```dart
ExtractResult extractResult = await MBTilesExtractor.extractMBTilesFile(
        new ExtractRequest(
          "${dir.path}/volcan_villarica.mbtiles", //This is the name of the file i was testing.
          desiredPath: "${dir.path}/tiles/", //Example of final folder
          requestPermissions: true, //This is for Android 6.0+
          removeAfterExtract: true, //Deletes the +.mbtiles file after the extraction is completed
          stopOnError: true, //Stops is one tile could not be extracted
          returnReference: true, //Returns the list of tiles once the extraction is completed
          onlyReference: false, //If true the reference of tiles is returned but the extraction is not performed
        ),
      );
```

The extraction will return an instance of **ExtractResult** that
contains a **code** and **data**. The code determinate the extraction
result and could be checked using the **isSuccessful()** function in
**ExtractResult** class or could be done manually.

```dart
    if (extractResult.code == ExtractResult.RESULT_FILE_CORRUPT) {
      //The file could not be read because it was damaged
    }
```

If the file was extracted successfully the **data** will contain the
path to the folder where the tiles are stored.

```dart
    if (extractResult.isSuccessful()) {
        var folder= extractResult.data;
        //Do something
    }
```

Progress can be tracked by registering the following stream 
```dart
    StreamSubscription<dynamic> subscription = 
    MBTilesExtractor.onProgress().listen((dynamic event) {
        var percent = event['progress'] / event['total'];
        print("$event, $percent %");
      });
   
   ExtractResult extractResult = await ...
   
   subscription?.cancel();

```


## Extra info

This plugin uses the extracted folder to generate a Google Maps like map
so you could make a project that uses offline maps.

[apptreesoftware/flutter_map](https://github.com/apptreesoftware/flutter_map)

The Android part use a library to read the .mbtiles file. The original
project for Java:

[mbtiles4j](https://github.com/imintel/mbtiles4j)

And the Android version:

[mbtiles4j-android](https://github.com/fullhdpixel/mbtiles4j)

**NOTE**: I included a compiled .jar of this library since it don't
exist in **Maven** or **JitPack** (at least i couldn't find it).
Consider update it if exists a new version.