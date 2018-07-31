//
//  flutter_mbtiles_extractor.swift
//  flutter_mbtiles_extractor
//
//  Created by CEISUFRO on 27-07-18.
//

import Foundation
import SQLite3

class SQLHelper:NSObject{
    static func establishConnection(filePath:String) -> OpaquePointer?{
        var db:OpaquePointer?=nil
        if sqlite3_open(filePath, &db)==SQLITE_OK{
            return db
        }
        return nil;
    }
    
    static func executeQuery(db:OpaquePointer?, sql:String) -> OpaquePointer? {
        var queryStatement:OpaquePointer?=nil
        if sqlite3_prepare_v2(db, sql, -1, &queryStatement, nil) == SQLITE_OK{
            return queryStatement;
        }
        return nil
    }
}
