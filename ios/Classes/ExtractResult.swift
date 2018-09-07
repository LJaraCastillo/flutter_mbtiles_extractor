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
    let metadata:MBTilesMetadata?
    var tiles:[Tile]
    
    init(code:Int, data:String) {
        self.code = code
        self.data = data
        self.tiles = []
    }
    
    init(code:Int, data:String, tiles:[Tile]) {
        self.code = code
        self.data = data
        self.tiles = tiles
    }

    init(code:Int, data:String, metadata:MBTilesMetadata, tiles:[Tile]) {
        self.code = code
        self.data = data
        self.metadata = metadata
        self.tiles = tiles
    }
    
    func toMap() -> NSDictionary {
        return [
            "code":self.code,
            "data":self.data,
            "metadata":self.metadata?.toMap(),
            "tiles":Tile.toMapList(list: self.tiles),
        ]
    }
}
