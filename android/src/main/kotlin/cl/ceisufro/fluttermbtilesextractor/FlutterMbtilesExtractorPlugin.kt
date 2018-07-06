package cl.ceisufro.fluttermbtilesextractor

import android.Manifest
import android.app.Activity
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.support.v4.app.ActivityCompat
import android.support.v4.content.ContextCompat
import com.myroutes.mbtiles4j.MBTilesReadException
import com.myroutes.mbtiles4j.MBTilesReader
import com.myroutes.mbtiles4j.TileIterator
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.io.File
import java.io.FileOutputStream


class FlutterMbtilesExtractorPlugin(val activity: Activity, val methodChannel: MethodChannel, val registrar: Registrar) : MethodCallHandler,
        PluginRegistry.RequestPermissionsResultListener {
    val PERMISSION_REQUEST_CODE = 1
    private lateinit var result: MethodChannel.Result

    companion object {
        lateinit var registrar: Registrar
        @JvmStatic
        fun registerWith(registrar: Registrar): Unit {
            val channel = MethodChannel(registrar.messenger(), "flutter_mbtiles_extractor")
            val plugin = FlutterMbtilesExtractorPlugin(registrar.activity(), channel, registrar)
            channel.setMethodCallHandler(plugin)
            registrar.addRequestPermissionsResultListener(plugin)
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result): Unit {
        if (call.method.equals("extractMBTilesFile")) {
            val map = call.arguments as Map<String, Any>
            val extractRequest = ExtractRequest.fromMap(map)
            val extractResult: ExtractResult = extractTilesFromFile(extractRequest)
            result.success(extractResult.toMap())
        } else if (call.method.equals("requestPermissions")) {
            if (!hasPermissions()) {
                this.result = result
                requestStoragePermissions()
            }else{
                result.success(true)
            }
        } else {
            result.notImplemented()
        }
    }

    private fun extractTilesFromFile(extractRequest: ExtractRequest): ExtractResult {
        if (!hasPermissions())
            return ExtractResult(2, "Storage permissions not granted")
        val dbFile = File(extractRequest.pathToDB)
        if (extractRequest.pathToDB.isNotEmpty() && dbFile.exists()) {
            var reader: MBTilesReader? = null
            try {
                reader = MBTilesReader(File(extractRequest.pathToDB))
            } catch (e: MBTilesReadException) {
                e.printStackTrace()
            }
            if (reader != null) {
                val tiles = reader.tiles
                val tilesList = arrayListOf<Tile>()
                if (!extractRequest.onlyReference) {
                    val filesDir = createMainFolder(dbFile.nameWithoutExtension, extractRequest.desiredPath)
                    if (filesDir != null) {
                        while (tiles.hasNext()) {
                            val tile = tiles.next()
                            if (!saveTileIntoFile(filesDir, tile) && extractRequest.stopOnError)
                                return ExtractResult(4, "Failed to extract tiles")
                            if (extractRequest.returnReference)
                                tilesList.add(Tile(tile.zoom, tile.column, tile.row))
                        }
                        tiles.close()
                        reader.close()
                        if (extractRequest.removeAfterExtract)
                            dbFile.delete()
                        return ExtractResult(0, filesDir.path, tilesList)
                    } else {
                        return ExtractResult(2, "Directory could not be created")
                    }
                } else {
                    while (tiles.hasNext()) {
                        val tile = tiles.next()
                        tilesList.add(Tile(tile.zoom, tile.column, tile.row))
                    }
                    return ExtractResult(0, "No extraction performed", tilesList)
                }
            } else {
                return ExtractResult(1, "The file could not be read")
            }
        } else {
            return ExtractResult(3, "MBTiles file path is empty")
        }
    }

    private fun createMainFolder(filename: String, path: String): File? {
        var mainDir = File(path, filename)
        if (path.isEmpty())
            mainDir = File(activity.getExternalFilesDir(null), filename)
        try {
            if (mainDir.exists() || mainDir.mkdirs())
                return mainDir
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return null
    }

    private fun saveTileIntoFile(filesDir: File, tile: TileIterator.Tile): Boolean {
        val sep = File.separator
        val tilePath = "${filesDir.path}$sep${tile.zoom}$sep" +
                "${tile.column}"
        val filename = "${tile.row}.png"
        val dir = File(tilePath)
        if (dir.exists() || dir.mkdirs()) {
            val file = File(dir, filename)
            if (file.exists() || file.createNewFile()) {
                try {
                    val bitmap = BitmapFactory.decodeStream(tile.data)
                    val out = FileOutputStream(file)
                    if (bitmap.compress(Bitmap.CompressFormat.PNG, 90, out)) {
                        out.close()
                        return true
                    }
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            }
        }
        return false
    }

    private fun hasPermissions(): Boolean {
        if (ContextCompat.checkSelfPermission(activity, Manifest.permission.READ_EXTERNAL_STORAGE)
                != PackageManager.PERMISSION_GRANTED)
            return false
        if (ContextCompat.checkSelfPermission(activity, Manifest.permission.WRITE_EXTERNAL_STORAGE)
                != PackageManager.PERMISSION_GRANTED)
            return false
        return true
    }

    private fun requestStoragePermissions() {
        val array = arrayListOf<String>()
        if (ContextCompat.checkSelfPermission(activity, Manifest.permission.READ_EXTERNAL_STORAGE)
                != PackageManager.PERMISSION_GRANTED) {
            array.add(Manifest.permission.READ_EXTERNAL_STORAGE)
        }
        if (ContextCompat.checkSelfPermission(activity, Manifest.permission.WRITE_EXTERNAL_STORAGE)
                != PackageManager.PERMISSION_GRANTED) {
            array.add(Manifest.permission.WRITE_EXTERNAL_STORAGE)
        }
        if (array.isNotEmpty())
            ActivityCompat.requestPermissions(activity, array.toArray(arrayOf<String>()),
                    PERMISSION_REQUEST_CODE)
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>?, result: IntArray?): Boolean {
        var granted = false
        when (requestCode) {
            PERMISSION_REQUEST_CODE -> {
                if (result != null && result.size > 0 && result[0] == PackageManager.PERMISSION_GRANTED) {
                    granted = true
                }
                this.result.success(granted)
                return true
            }
        }
        return false
    }

}
