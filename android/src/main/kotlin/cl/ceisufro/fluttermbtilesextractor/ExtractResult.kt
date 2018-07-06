package cl.ceisufro.fluttermbtilesextractor


class ExtractResult(val code: Int, val data: String) {
    var tiles: ArrayList<Tile> = arrayListOf()

    constructor(code: Int, data: String, tiles: ArrayList<Tile>) : this(code, data) {
        this.tiles = tiles;
    }

    companion object {
        fun fromMap(map: Map<String, Any>): ExtractResult {
            val code = map["code"] as Int
            val data = map["data"] as String
            val tileList = arrayListOf<Tile>();
            val tilesMap = map["tiles"] as ArrayList<Map<String, Any>>
            tilesMap.forEach {
                tileList.add(Tile.fromMap(it))
            }
            return ExtractResult(code, data)
        }
    }

    fun toMap(): HashMap<String, Any> {
        val map = hashMapOf<String, Any>()
        map.put("code", code)
        map.put("data", data)
        map.put("tiles", Tile.toMapList(tiles))
        return map
    }
}