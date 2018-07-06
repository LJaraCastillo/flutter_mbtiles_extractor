# flutter_mbtiles_extractor

Basic plugin to extract the data (png tiles) from an .mbtiles file and
automatically create the folder structure (../folder_name/z/x/y.png).

#### Installation

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

#### How to use

In the following example you can see how to realize a extraction of
one file.

```dart
ExtractResult extractResult = await MbtilesExtractor.extractMBTilesFile(
        new ExtractRequest(
          "/storage/emulated/0/Download/volcan_villarica.mbtiles", //Your file. I will not upload this one.
          desiredPath: "/storage/emulated/0/Download/tiles/", //The tiles will be extracted here
          requestPermissions: true, //Request the writing permissions before extracting
          removeAfterExtract: false, //Remove the mbtiles file after extracting
          stopOnError: true, //If fails while extracting one tile, the extraction will be stopped.
          onlyReference: false, //If true, the call will return the list of tiles of the db but not extract.
          returnReference: true, //If true, the call will extract and return the list of tiles.
        ),
      );
```

The extraction will return an instance of **ExtractResult** that
contains a **code** and **data**. The code determinate the extraction
result and could be checked using the **isSuccessful()** function in
**ExtractResult** class or could be done manually.

```dart
    if (extractResult.code == MbtilesExtractor.RESULT_FILE_CORRUPT) {
      //The file could not be read because it was damaged
    }
```

If the file was extracted successfully the **data** will contain the
path to the folder where the tiles are stored.

```dart
    if (extractResult.isSuccessful()) {
        var folder= extractResult.data;
        //Do some stuff with this value.
    }
```

#### Extra info

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







