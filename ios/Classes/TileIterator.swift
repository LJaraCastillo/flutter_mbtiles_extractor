//
//  TileIterator.swift
//  flutter_mbtiles_extractor
//
//  Created by CEISUFRO on 27-07-18.
//

import Foundation
import SQLite3
class TileIterator: NSObject{
    private var resultSet:OpaquePointer
    
    init(resultSet:OpaquePointer) {
        self.resultSet = resultSet
    }
    
    func hasNext() -> Bool{
        if(sqlite3_step(resultSet) == SQLITE_ROW){
            return true
        }
        return false
    }
    
    func next() -> TileData{
        let zoom = sqlite3_column_int(resultSet, 0)
        let column = sqlite3_column_int(resultSet, 1)
        let row = sqlite3_column_int(resultSet, 2)
        let bytes = sqlite3_column_blob(resultSet, 3)
        let lenght = sqlite3_column_bytes(resultSet,3)
        let dbData = Data(bytes:bytes!, count:Int(lenght))
        return TileData(zoom: Int(zoom), column: Int(column), row: Int(row), data: dbData)
    }
    
    func close(){
        sqlite3_close(resultSet)
    }
}
