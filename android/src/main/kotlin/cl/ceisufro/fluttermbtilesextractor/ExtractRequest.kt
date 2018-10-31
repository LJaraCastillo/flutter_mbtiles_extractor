package cl.ceisufro.fluttermbtilesextractor


class ExtractRequest(val pathToDB: String,
                     val desiredPath: String,
                     val requestPermissions: Boolean,
                     val removeAfterExtract: Boolean,
                     val stopOnError: Boolean,
                     val onlyReference: Boolean,
                     val returnReference: Boolean,
                     val schema: Int) {
    companion object {
        fun fromMap(map: Map<String, Any>): ExtractRequest {
            val pathToDB = map["pathToDB"] as String
            val desiredPath = map["desiredPath"] as String
            val requestPermissions = map["requestPermissions"] as Boolean
            val removeAfterExtract = map["removeAfterExtract"] as Boolean
            val stopOnError = map["stopOnError"] as Boolean
            val onlyReference = map["onlyReference"] as Boolean
            val returnReference = map["returnReference"] as Boolean
            val schema = map["schema"] as Int
            return ExtractRequest(pathToDB, desiredPath, requestPermissions, removeAfterExtract, stopOnError, onlyReference, returnReference, schema)
        }
    }

    fun toMap(): Map<String, Any> {
        val map = hashMapOf<String, Any>()
        map.put("pathToDB", pathToDB)
        map.put("desiredPath", desiredPath)
        map.put("requestPermissions", requestPermissions)
        map.put("removeAfterExtract", removeAfterExtract)
        map.put("stopOnError", stopOnError)
        map.put("onlyReference", onlyReference)
        map.put("returnReference", returnReference)
        map.put("schema", schema)
        return map
    }
}