//
//  TIle.swift
//  flutter_mbtiles_extractor
//
//  Created by CEISUFRO on 09-07-18.
//

import Foundation
class Tile: NSObject{
    let zoom:Int
    let column:Int
    let row:Int
    
    init(zoom:Int,column:Int, row:Int) {
        self.zoom=zoom
        self.column=column
        self.row=row
    }
    
    static func fromMap(map:NSDictionary) -> Tile {
        let zoom = map["zoom"] as! Int
        let column = map["column"] as! Int
        let row = map["row"] as! Int
        return Tile(zoom: zoom, column: column, row: row)
    }
    
    static func toMapList(list: [Tile]) -> [NSDictionary] {
        var result:[NSDictionary] = []
        list.forEach { element in
            result.append(element.toMap())
        }
        return result
    }
    
    func toMap() -> NSDictionary{
        return [
            "zoom":self.zoom,
            "column":self.column,
            "row":self.row,
        ]
    }
}
