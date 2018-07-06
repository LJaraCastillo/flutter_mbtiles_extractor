package cl.ceisufro.fluttermbtilesextractor

class Tile(val zoom: Int, val column: Int, val row: Int) {

    companion object {
        fun fromMap(map: Map<String, Any>): Tile {
            val zoom = map["zoom"] as Int
            val column = map["column"] as Int
            val row = map["row"] as Int
            return Tile(zoom, column, row)
        }

        fun toMapList(list: ArrayList<Tile>): List<Map<String, Any>> {
            val result = arrayListOf<Map<String, Any>>()
            list.forEach {
                result.add(it.toMap())
            }
            return result
        }
    }

    fun toMap(): HashMap<String, Any> {
        val map = hashMapOf<String, Any>()
        map.put("zoom", zoom)
        map.put("column", column)
        map.put("row", row)
        return map
    }
}


