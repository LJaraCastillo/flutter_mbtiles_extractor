//
//  ExtractResult.swift
//  flutter_mbtiles_extractor
//
//  Created by LJaraCastillo on 09-07-18.
//

import Foundation
class ExtractResult:NSObject{
    let code:Int
    let data:String
    var tiles:[Tile]
    
    init(code:Int,data:String) {
        self.code=code
        self.data=data
        self.tiles=[]
    }
    
    init(code:Int,data:String,tiles:[Tile]) {
        self.code=code
        self.data=data
        self.tiles=tiles
    }
    static func fromMap(map:NSDictionary) -> ExtractResult{
        let code = map["code"] as! Int
        let data = map["data"] as! String
        var tiles:[Tile] = []
        let tilesMapList = map["tiles"] as! [NSDictionary]
        tilesMapList.forEach{ tileMap in
            tiles.append(Tile.fromMap(map: tileMap))
        }
        return ExtractResult(code: code, data: data, tiles:tiles)
    }
    
    func toMap() -> NSDictionary {
        return [
            "code":self.code,
            "data":self.data,
            "tiles":Tile.toMapList(list: self.tiles),
        ]
    }
}
