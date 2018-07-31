//
//  TileData.swift
//  flutter_mbtiles_extractor
//
//  Created by CEISUFRO on 27-07-18.
//

import Foundation
class TileData:Tile{
    let data:Data
    
    init(zoom: Int, column: Int, row: Int, data:Data) {
        self.data = data
        super.init(zoom:zoom,column:column,row:row)
    }
}
