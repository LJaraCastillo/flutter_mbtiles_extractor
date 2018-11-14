//
//  MBTilesReader.swift
//  flutter_mbtiles_extractor
//
//  Created by CEISUFRO on 27-07-18.
//

import Foundation
import SQLite3

class MBTilesReader:NSObject{
    private var filePath:String
    private var dbConnection:OpaquePointer?
    
    init(filePath:String) throws{
        self.filePath = filePath
        self.dbConnection = SQLHelper.establishConnection(filePath: filePath)
    }
    
    func close(){
        sqlite3_close(dbConnection)
    }
    
    func getMetadata() -> MetadataEntry{
        let sql:String = "SELECT * FROM metadata;"
        let resultSet = SQLHelper.executeQuery(db: dbConnection, sql: sql)
        let metadataEntry:MetadataEntry = MetadataEntry()
        while(sqlite3_step(resultSet)==SQLITE_ROW){
            let name:String = String(cString: sqlite3_column_text(resultSet, 0))
            let value:String = String(cString: sqlite3_column_text(resultSet, 1))
            metadataEntry.addKeyValue(name: name, value: value)
        }
        return metadataEntry
    }
    
    func getTiles() -> TileIterator{
        let sql:String = "SELECT * FROM tiles;"
        let resultSet = SQLHelper.executeQuery(db: dbConnection, sql: sql)
        return TileIterator(resultSet: resultSet!)
    }

    func getTileCount() -> Int32 {
        var count:Int32 = 0
        let sql:String = "SELECT count(*) FROM tiles;"
        let resultSet = SQLHelper.executeQuery(db: dbConnection, sql: sql)
        while(sqlite3_step(resultSet)==SQLITE_ROW){
            count = sqlite3_column_int(resultSet, 0)
        }
        return count
    }
}
