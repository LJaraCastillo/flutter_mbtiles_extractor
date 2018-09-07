part of mbtiles_extractor;

class MBTilesMetadata{
  String attribution;
  String name;
  String format;
  int version;
  double latitudeSW;
  double longitudeSW;
  double latitudeNE;
  double longitudeNE;
  double zoomMax;
  double zoomMin;

  MBTilesMetadata.fromMap(Map map){
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
    "attribution":attribution,
    "name":name,
    "format":format,
    "version":version,
    "latitudeSW":latitudeSW,
    "longitudeSW":longitudeSW,
    "latitudeNE":latitudeNE,
    "longitudeNE":longitudeNE,
    "zoomMax":zoomMax,
    "zoomMin":zoomMin,
  };
}