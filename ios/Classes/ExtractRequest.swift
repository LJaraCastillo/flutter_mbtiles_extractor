//
//  ExtractRequest.swift
//  flutter_mbtiles_extractor
//
//  Created by CEISUFRO on 09-07-18.
//

import Foundation
class ExtractRequest:NSObject{
    let pathToDB:String
    let desiredPath:String
    let requestPermissions:Bool
    let removeAfterExtract:Bool
    let stopOnError:Bool
    let onlyReference:Bool
    let returnReference:Bool
    let schema:Int

    init(pathToDB:String,desiredPath:String,requestPermissions:Bool,removeAfterExtract:Bool,stopOnError:Bool,onlyReference:Bool,returnReference:Bool,schema:Int) {
        self.pathToDB = pathToDB
        self.desiredPath=desiredPath
        self.requestPermissions=requestPermissions
        self.removeAfterExtract=removeAfterExtract
        self.stopOnError=stopOnError
        self.onlyReference=onlyReference
        self.returnReference=returnReference
        self.schema=schema
    }
    
    static func fromMap(map:NSDictionary) -> ExtractRequest{
        let pathToDB:String = map["pathToDB"] as! String
        let desiredPath:String = map["desiredPath"] as! String
        let requestPermissions:Bool = map["requestPermissions"] as! Bool
        let removeAfterExtract:Bool = map["removeAfterExtract"] as! Bool
        let stopOnError:Bool = map["stopOnError"] as! Bool
        let onlyReference:Bool = map["onlyReference"] as! Bool
        let returnReference:Bool = map["returnReference"] as! Bool
        let schema:Int = map["schema"] as! Int
        return ExtractRequest(
            pathToDB: pathToDB,
            desiredPath: desiredPath,
            requestPermissions: requestPermissions,
            removeAfterExtract: removeAfterExtract,
            stopOnError: stopOnError,
            onlyReference: onlyReference,
            returnReference: returnReference,
            schema: schema)
    }
    
    func toMap() -> NSDictionary{
        return [
            "pathToDB":self.pathToDB,
            "desiredPath":self.desiredPath,
            "requestPermissions":self.requestPermissions,
            "removeAfterExtract":self.removeAfterExtract,
            "stopOnError":self.stopOnError,
            "onlyReference":self.onlyReference,
            "returnReference":self.returnReference,
            "schema":self.schema,
        ]
    }
}
