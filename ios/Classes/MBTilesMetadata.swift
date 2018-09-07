//
//  MBTilesMetadata.swift
//  flutter_mbtiles_extractor
//
//  Created by LJaraCastillo on 09-07-18.
//

import Foundation
class MBTilesMetadata:NSObject{
    let attribution: String
    let name: String
    let format: String
    let version: Int
    let latitudeSW: Double
    let longitudeSW: Double
    let latitudeNE: Double
    let longitudeNE: Double
    let zoomMax: Double
    let zoomMin: Double

    init (attribution:String, name: String, format: String, 
    version: Int, latitudeSW: Double, longitudeSW: Double, 
    latitudeNE: Double,longitudeNE: Double,zoomMax: Double, zoomMin: Double) {
        self.attribution = attribution
        self.name = name
        self.format = format
        self.version = version
        self.latitudeSW = latitudeSW
        self.longitudeSW = longitudeSW
        self.latitudeNE = latitudeNE
        self.longitudeNE = longitudeNE
        self.zoomMax = zoomMax
        self.zoomMin = zoomMin
    }

    func toMap() -> NSDictionary {
        return [
            "attribution":self.attribution,
            "name":self.name,
            "format":self.format,
            "version":self.version,
            "latitudeSW":self.latitudeSW,
            "longitudeSW":self.longitudeSW,
            "latitudeNE":self.latitudeNE,
            "longitudeNE":self.longitudeNE,
            "zoomMax":self.zoomMax,
            "zoomMin":self.zoomMin,
        ]
    }
}