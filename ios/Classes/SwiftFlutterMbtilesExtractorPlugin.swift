import Flutter
import UIKit

public class SwiftFlutterMbtilesExtractorPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let methodChannel = FlutterMethodChannel(name: "flutter_mbtiles_extractor", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterMbtilesExtractorPlugin()
        registrar.addMethodCallDelegate(instance, channel: methodChannel)
        let eventChannel = FlutterEventChannel(name:  "flutter_mbtiles_extractor_progress", binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if (call.method=="extractMBTilesFile"){
            let map = call.arguments as! NSDictionary
            let extractRequest = ExtractRequest.fromMap(map: map)
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let extractResult = self?.extractTilesFromFile(extractRequest: extractRequest)
                DispatchQueue.main.async {
                    result(extractResult?.toMap())
                }
            }
        }else if(call.method=="requestPermissions"){
            result(true)
        }else{
            result(FlutterMethodNotImplemented)
        }
    }

    private var sinks: [FlutterEventSink] = []

    public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        sinks.append(eventSink)
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        sinks.removeAll()
        return nil
    }

    func notify(progress: Int32, total: Int32) {
        var value = [NSString : NSNumber]()
        value["total"] = NSNumber(value: total)
        value["progress"] = NSNumber(value: progress)
        for case let it in sinks {
            it(value)
        }
    }

    func extractTilesFromFile(extractRequest:ExtractRequest) -> ExtractResult {
        let fileManager = FileManager.default
        let pathToDB:String = extractRequest.pathToDB
        if(fileManager.fileExists(atPath: pathToDB)){
            var reader:MBTilesReader? = nil
            do{
                try reader = MBTilesReader(filePath: pathToDB)
            }catch{
                print(error)
            }
            if(reader != nil){
                let tiles = reader!.getTiles()
                let count = reader!.getTileCount()
                var tilesList:[Tile]=[]
                let metadata = getMetadataFromReader(reader: reader!)
                if (!extractRequest.onlyReference) {
                    let url = URL(string:pathToDB)
                    let filename = url?.deletingPathExtension().lastPathComponent
                    let filesDir = createMainFolder(name: filename!, path: extractRequest.desiredPath)
                    if (filesDir != nil) {
                        while (tiles.hasNext()) {
                            let tile = tiles.next()
                            if (!saveTileIntoFile(schema: extractRequest.schema, filesDir: filesDir!, tile: tile) && extractRequest.stopOnError){
                                return ExtractResult(code: 4,data: "Failed to extract tiles")
                            }
                            if (extractRequest.returnReference){
                                tilesList.append(Tile(zoom: tile.zoom, column: tile.column, row: tile.row))
                                notify(progress: Int32(tilesList.count), total: count)
                            }
                        }
                        tiles.close()
                        reader!.close()
                        if (extractRequest.removeAfterExtract){
                            do{
                                try fileManager.removeItem(atPath: extractRequest.pathToDB)
                            }catch{
                                print("\(error)")
                            }
                        }
                        return ExtractResult(code: 0, data: filesDir!, metadata: metadata, tiles: tilesList)
                    } else {
                        return ExtractResult(code: 2, data: "Directory could not be created")
                    }
                } else {
                    while (tiles.hasNext()) {
                        let tile = tiles.next()
                        tilesList.append(Tile(zoom: tile.zoom, column: tile.column, row: tile.row))
                    }
                    return ExtractResult(code: 0, data: "No extraction performed", metadata: metadata, tiles: tilesList)
                }
            } else {
                return ExtractResult(code: 1,data: "The file could not be read")
            }
        } else {
            return ExtractResult(code: 3, data: "MBTiles file does not exist!")
        }
    }
    
    func getMetadataFromReader(reader: MBTilesReader)-> MBTilesMetadata {
        let attribution = reader.getMetadata().getAttribution() ?? ""
        let format = reader.getMetadata().getRequiredKeyValuePairs()["format"] ?? ""
        let name = reader.getMetadata().getTileSetName() ?? ""
        let version = reader.getMetadata().getTileSetVersion() ?? ""
        let latitudeSW = reader.getMetadata().getTileSetBounds()?.bottom ?? 0.0
        let longitudeSW = reader.getMetadata().getTileSetBounds()?.left ?? 0.0
        let latitudeNE = reader.getMetadata().getTileSetBounds()?.top ?? 0.0
        let longitudeNE = reader.getMetadata().getTileSetBounds()?.right ?? 0.0
        let zoomMax = reader.getMetadata().getCustomKeyValuePairs()["maxzoom"] ?? "0.0"
        let zoomMin = reader.getMetadata().getCustomKeyValuePairs()["minzoom"] ?? "0.0"
        return MBTilesMetadata(attribution: attribution,name: name,
                               format: format,version: version,
                               latitudeSW: latitudeSW, longitudeSW: longitudeSW,
                               latitudeNE: latitudeNE, longitudeNE: longitudeNE,
                               zoomMax: Double(zoomMax)!, zoomMin: Double(zoomMin)!)
    }
    
    func createMainFolder(name:String, path:String) -> String?{
        let fileManager = FileManager.default
        var mainDir:String? = path+"/"+name
        if (path.isEmpty){
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            if(!paths.isEmpty && paths.first != nil){
                mainDir = paths.first!+"/"+name
            }
        }
        if (mainDir != nil){
            if(fileManager.fileExists(atPath: mainDir!)) {
                return mainDir
            }
            do {
                try fileManager.createDirectory(atPath: mainDir!, withIntermediateDirectories: true, attributes: nil)
                return mainDir
            } catch {
                print(error)
            }
        }
        return nil
    }
    
    func saveTileIntoFile(schema:Int, filesDir:String, tile:TileData) -> Bool{
        let fileManager = FileManager.default
        let tilePath = "\(filesDir)/\(tile.zoom)/\(tile.column)"
        let row = (schema == 0 ? tile.row : flip(tile: tile))
        let filename = "\(row).png"
        if(!fileManager.fileExists(atPath:tilePath)){
            do {
                try fileManager.createDirectory(atPath: tilePath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
                return false
            }
        }
        let file = tilePath+"/"+filename
        return fileManager.createFile(atPath: file, contents: tile.data, attributes: nil)
    }

    func flip(tile: TileData) -> Int {
        return Int(pow(2.0, Double(tile.zoom)) - 1.0) - tile.row
    }
}
