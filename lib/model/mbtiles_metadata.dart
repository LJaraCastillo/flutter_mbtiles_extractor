part of mbtiles_extractor;

class MBTilesMetadata {
  String attribution;
  String name;
  String format;
  String version;

  ///Latitude of the South-West corner of the map
  double latitudeSW;

  ///Longitude of the South-West corner of the map
  double longitudeSW;

  ///Latitude of the North-East corner of the map
  double latitudeNE;

  ///Longitude of the North-East corner of the map
  double longitudeNE;

  ///The maximum zoom to which the map can reach
  ///
  ///
  ///This value is not always present in the .mbtiles files
  double zoomMax;

  ///The minimun zoom to which the map can reach
  ///
  ///This value is not always present in the .mbtiles files
  double zoomMin;

  MBTilesMetadata.fromMap(Map map) {
    attribution = map["attribution"];
    name = map["name"];
    format = map["format"];
    version = map["version"];
    latitudeSW = map["latitudeSW"];
    longitudeSW = map["longitudeSW"];
    latitudeNE = map["latitudeNE"];
    longitudeNE = map["longitudeNE"];
    zoomMax = map["zoomMax"];
    zoomMin = map["zoomMin"];
  }

  Map<String, dynamic> toMap() => {
        "attribution": attribution,
        "name": name,
        "format": format,
        "version": version,
        "latitudeSW": latitudeSW,
        "longitudeSW": longitudeSW,
        "latitudeNE": latitudeNE,
        "longitudeNE": longitudeNE,
        "zoomMax": zoomMax,
        "zoomMin": zoomMin,
      };
}
