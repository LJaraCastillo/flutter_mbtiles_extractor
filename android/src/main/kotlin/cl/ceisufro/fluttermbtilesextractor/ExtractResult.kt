package cl.ceisufro.fluttermbtilesextractor


class ExtractResult(val code: Int, val data: String) {
    var tiles: ArrayList<Tile> = arrayListOf()
    var mbtilesMetadata: MBTilesMetadata? = null

    constructor(code: Int, data: String, tiles: ArrayList<Tile>) : this(code, data) {
        this.tiles = tiles
    }

    constructor(code: Int, data: String, mbTilesMetadata: MBTilesMetadata, tiles: ArrayList<Tile>) : this(code, data) {
        this.tiles = tiles
        this.mbtilesMetadata = mbTilesMetadata
    }

    fun toMap(): HashMap<String, Any?> {
        val map = hashMapOf<String, Any?>()
        map.put("code", code)
        map.put("data", data)
        map.put("metadata", mbtilesMetadata?.toMap())
        map.put("tiles", Tile.toMapList(tiles))
        return map
    }
}