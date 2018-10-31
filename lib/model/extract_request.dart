class ExtractRequest {
  ///String path to the *.mbtiles File
  String pathToDB;

  ///Path for the destination folder where the files will be placed
  ///while extracting.
  ///If a path is not given a folder will be created next to the .mbtiles file
  ///with the same name. Consider that if the directory is not writable the
  ///extraction will fail.
  String desiredPath;

  ///Should request storage permissions in Android. Consider that if the
  ///permission are not granted for the app, it will not be possible to create
  ///the folder or files necessary for the extraction.
  ///
  ///The default value is false.
  bool requestPermissions;

  ///Remove the *.mbtiles file after extracting the tiles from it. If occurs an
  ///error the file will not be removed.
  ///
  ///The default value is false.
  bool removeAfterExtract;

  ///Determinate if the extraction is stopped when an error presents. Only
  ///continues if the error is not crucial for the extraction. eg: if false and
  ///one tile could not be extracted then continues with the next one. if true
  ///the extraction will fail even if could continue with other tile.
  ///
  ///The default value is true.
  bool stopOnError;

  ///If true, the file will be read and will return the list of tiles,
  ///but will not extract the files from the db. Also, if true is not
  ///necessary to set returnReference to true.
  ///
  /// The default value is false.
  bool onlyReference;

  ///If true, the extraction will also return the list of tiles.
  ///Consider that an .mbtiles file could have thousand of tiles. Be aware of
  ///memory and performance. If onlyReference the reference will be returned
  ///even if this attribute is false.
  ///
  ///The default value is false.
  bool returnReference;

  ///Tiling schema used when exporting. The [MBTiles Specification]
  ///(https://github.com/mapbox/mbtiles-spec/blob/master/1.3/spec.md) stores
  ///tiles that follows the Tile Map Service (TMS) Specification, where the Y
  ///axis is reversed from the "XYZ" coordinate system commonly used in the URLs
  ///to request individual tiles. Use the [Schema.XYZ] to flip the y axis back
  ///from the TMS schema i MBTiles til "XYZ" coordinate system, typically used by "slippy maps"
  ///like in OpenStreetMap and Leaflet.
  ///
  ///The default value is [Schema.TMS] (y axis is not flipped).
  Schema schema;

  ExtractRequest(
    this.pathToDB, {
    this.desiredPath = "",
    this.requestPermissions = false,
    this.removeAfterExtract = false,
    this.stopOnError = true,
    this.onlyReference = false,
    this.returnReference = false,
    this.schema = Schema.TMS,
  });

  ExtractRequest.fromMap(Map<String, dynamic> map) {
    this.pathToDB = map['pathToDB'];
    this.desiredPath = map['desiredPath'];
    this.requestPermissions = map['requestPermissions'];
    this.removeAfterExtract = map['removeAfterExtract'];
    this.stopOnError = map['stopOnError'];
    this.onlyReference = map['onlyReference'];
    this.returnReference = map['returnReference'];
    this.schema = Schema.values[map['schema']];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'pathToDB': this.pathToDB != null ? this.pathToDB : "",
      'desiredPath': this.desiredPath != null ? this.desiredPath : "",
      'requestPermissions': this.requestPermissions,
      'removeAfterExtract': this.removeAfterExtract,
      'stopOnError': this.stopOnError,
      'onlyReference': this.onlyReference,
      'returnReference': this.returnReference,
      'schema': this.schema.index,
    };
    return map;
  }

}

enum Schema {
  /// Tile Map Service tiling schema.
  /// Maps [z,y,x] = [tile_zoom, tile_row, tile_column] (default)
  TMS,
  /// Commonly used "XYZ" schema by "slippy maps".
  /// Maps [z,y,x] = [tile_zoom, (2 * tile_zoom - 1) - tile_row, tile_column]
  /// (y coordinate is flipped)
  ///
  XYZ,
}

