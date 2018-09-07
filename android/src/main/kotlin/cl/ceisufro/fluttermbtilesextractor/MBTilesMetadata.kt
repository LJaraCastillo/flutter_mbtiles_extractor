package cl.ceisufro.fluttermbtilesextractor

class MBTilesMetadata(private val attribution: String, private val name: String,
                      private val format: String, private val version: Int,
                      private val latitudeSW: Double, private val longitudeSW: Double,
                      private val latitudeNE: Double, private val longitudeNE: Double,
                      private val zoomMin: Double, private val zoomMax: Double) {

    fun toMap(): HashMap<String, Any> {
        val map = hashMapOf<String, Any>()
        map.put("attribution", attribution)
        map.put("name", name)
        map.put("format", format)
        map.put("version", version)
        map.put("latitudeSW", latitudeSW)
        map.put("longitudeSW", longitudeSW)
        map.put("latitudeNE", latitudeNE)
        map.put("longitudeNE", longitudeNE)
        map.put("zoomMin", zoomMin)
        map.put("zoomMax", zoomMax)
        return map
    }
}