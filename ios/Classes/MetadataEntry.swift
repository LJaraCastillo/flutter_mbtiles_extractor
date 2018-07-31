//
//  MetadaEntry.swift
//  flutter_mbtiles_extractor
//
//  Created by CEISUFRO on 10-07-18.
//

import Foundation
class MetadataEntry:NSObject{
    var keyValuePairs = [String: String]()
    var customPairs = [String: String]()
    var requiredKeys: Set<String> = []
    
    override init(){
        super.init()
        initRequiredKeys()
        setTileSetName(name: "tilesetDefinedAt_\(NSDate().timeIntervalSince1970*1000)")
        setTileSetType(type: TileSetType.BASE_LAYER)
        setTileSetVersion(version: "0")
        setTileSetDescription(description: "n/a")
        setTileMimeType(fmt: TileMimeType.JPG)
        setTileSetBounds(left: -100, bottom: -85, right: 100, top: 85)
        setAttribution(attribution: "")
    }
    
    init(name:String, type:TileSetType, version:String, description:String, mimeType:TileMimeType) {
        super.init()
        initRequiredKeys()
        setTileSetName(name: name)
        setTileSetType(type: type)
        setTileSetVersion(version: version)
        setTileSetDescription(description: description)
        setTileMimeType(fmt: mimeType)
    }
    
    init(name:String, type:TileSetType, version:String, description:String, mimeType:TileMimeType, bounds:MetadataBounds) {
        super.init()
        initRequiredKeys()
        setTileSetName(name: name)
        setTileSetType(type: type)
        setTileSetVersion(version: version)
        setTileSetDescription(description: description)
        setTileMimeType(fmt: mimeType)
        setTileSetBounds(metadataBounds: bounds)
    }
    
    init(name:String, type:TileSetType, version:String, description:String, mimeType:TileMimeType, attribution:String) {
        super.init()
        initRequiredKeys()
        setTileSetName(name: name)
        setTileSetType(type: type)
        setTileSetVersion(version: version)
        setTileSetDescription(description: description)
        setTileMimeType(fmt: mimeType)
        setAttribution(attribution: attribution)
    }
    
    init(name:String, type:TileSetType, version:String, description:String, mimeType:TileMimeType, bounds:MetadataBounds, attribution:String) {
        super.init()
        initRequiredKeys()
        setTileSetName(name: name)
        setTileSetType(type: type)
        setTileSetVersion(version: version)
        setTileSetDescription(description: description)
        setTileMimeType(fmt: mimeType)
        setTileSetBounds(metadataBounds: bounds)
        setAttribution(attribution: attribution)
    }
    
    func setTileSetName(name:String){
        keyValuePairs["name"] = name
    }
    
    func getTileSetName()->String?{
        return keyValuePairs["name"]
    }
    
    func setTileSetType(type:TileSetType){
        keyValuePairs["type"] = type.rawValue
    }
    
    func getTileSetType() -> TileSetType? {
        let value = keyValuePairs["type"]
        if(value != nil){
            return TileSetType.getTypeFromString(strValue: value!)
        }
        return nil
    }
    
    func setTileSetVersion(version:String){
        keyValuePairs["version"] = version
    }
    
    func getTileSetVersion()->String?{
        return keyValuePairs["version"]
    }
    
    func setTileSetDescription(description:String){
        keyValuePairs["description"] = description
    }
    
    func getDescription()->String?{
        return keyValuePairs["description"]
    }
    
    func setTileSetBounds(left:Double,bottom:Double,right:Double,top:Double){
        setTileSetBounds(metadataBounds: MetadataBounds(left: left, bottom: bottom, right: right, top: top))
    }
    
    func setTileSetBounds(metadataBounds:MetadataBounds){
        keyValuePairs["bounds"] = metadataBounds.toString()
    }
    
    func getTileSetBounds()->MetadataBounds?{
        let value = keyValuePairs["bounds"]
        if(value != nil){
            return MetadataBounds(serialized: value!)
        }
        return nil
    }
    
    func setTileMimeType(fmt:TileMimeType){
        keyValuePairs["format"] = fmt.rawValue
    }
    
    func getTileMimeType() -> TileMimeType? {
        let value = keyValuePairs["format"]
        if(value != nil){
            return TileMimeType.getTypeFromString(strValue: value!)
        }
        return nil
    }
    
    func setAttribution(attribution:String){
        keyValuePairs["attribution"] = attribution
    }
    
    func getAttribution()->String?{
        return keyValuePairs["attribution"]
    }
    
    func addCustomKeyValue(key:String, value:String) -> MetadataEntry{
        if(requiredKeys.contains(key)){
            keyValuePairs[key]=value
        }else{
            customPairs[key]=value
        }
        return self
    }
    
    func getCustomKeyValuePairs() -> Dictionary<String, String> {
        return customPairs
    }
    
    func getRequiredKeyValuePairs() -> Dictionary<String, String> {
        return keyValuePairs
    }
    
    func addKeyValue(name:String, value:String){
        if(requiredKeys.contains(name)){
            keyValuePairs[name]=value
        }else{
            customPairs[name]=value
        }
    }
    
    func initRequiredKeys(){
        requiredKeys.insert("name")
        requiredKeys.insert("type")
        requiredKeys.insert("version")
        requiredKeys.insert("description")
        requiredKeys.insert("format")
        requiredKeys.insert("bounds")
        requiredKeys.insert("attribution")
    }
    enum TileMimeType:String {
        case PNG = "png"
        case JPG = "jpg"
        
        static func getTypeFromString(strValue:String) -> TileMimeType? {
            if(strValue==TileMimeType.PNG.rawValue){
                return TileMimeType.PNG
            } else if(strValue==TileMimeType.JPG.rawValue){
                return TileMimeType.JPG
            }
            return nil
        }
    }
    
    enum TileSetType:String {
        case OVERLAY = "overlay"
        case BASE_LAYER = "baseLayer"
        
        static func getTypeFromString(strValue:String) -> TileSetType? {
            if(strValue==TileSetType.OVERLAY.rawValue){
                return TileSetType.OVERLAY
            } else if(strValue==TileSetType.BASE_LAYER.rawValue){
                return TileSetType.BASE_LAYER
            }
            return nil
        }
    }
}
