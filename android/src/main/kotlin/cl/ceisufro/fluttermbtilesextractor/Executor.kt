package cl.ceisufro.fluttermbtilesextractor

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.AsyncTask
import com.myroutes.mbtiles4j.MBTilesReadException
import com.myroutes.mbtiles4j.MBTilesReader
import com.myroutes.mbtiles4j.TileIterator
import java.io.File
import java.io.FileOutputStream
import java.lang.ref.WeakReference

class Executor private constructor(private var contextReference: WeakReference<Context>,
                                   private var extractRequest: ExtractRequest,
                                   private var executionCallback: ExecutionCallback) : AsyncTask<Void, Void, ExtractResult>() {

    companion object {
        fun executeExtractAsync(contextReference: WeakReference<Context>, extractRequest: ExtractRequest, executionCallback: ExecutionCallback): Executor {
            val executor = Executor(contextReference, extractRequest, executionCallback)
            executor.executeOnExecutor(AsyncTask.THREAD_POOL_EXECUTOR)
            return executor
        }
    }

    override fun doInBackground(vararg params: Void?): ExtractResult {
        return extractTilesFromFile();
    }

    override fun onPostExecute(result: ExtractResult?) {
        super.onPostExecute(result)
        this.executionCallback.onTaskFinish(result);
    }

    private fun extractTilesFromFile(): ExtractResult {
        val context = contextReference.get();
        if (!Utils.hasPermissions(context!!))
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
                val metadata = getMetadataFromReader(reader)
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
                        return ExtractResult(0, filesDir.path, metadata, tilesList)
                    } else {
                        return ExtractResult(2, "Directory could not be created")
                    }
                } else {
                    while (tiles.hasNext()) {
                        val tile = tiles.next()
                        tilesList.add(Tile(tile.zoom, tile.column, tile.row))
                    }
                    return ExtractResult(0, "No extraction performed", metadata, tilesList)
                }
            } else {
                return ExtractResult(1, "The file could not be read")
            }
        } else {
            return ExtractResult(3, "MBTiles file path is empty")
        }
    }

    private fun getMetadataFromReader(reader: MBTilesReader): MBTilesMetadata? {
        try{
            val attribution = reader.metadata.attribution
            var format = ""
            reader.metadata.requiredKeyValuePairs.forEach {
                if (it.key == "format")
                    format = it.value
            }
            val name = reader.metadata.tilesetName
            val version = reader.metadata.tilesetVersion
            val latitudeSW = reader.metadata.tilesetBounds.bottom
            val longitudeSW = reader.metadata.tilesetBounds.left
            val latitudeNE = reader.metadata.tilesetBounds.top
            val longitudeNE = reader.metadata.tilesetBounds.right
            var zoomMax = 0.0
            var zoomMin = 0.0
            reader.metadata.customKeyValuePairs.forEach {
                if (it.key.equals("maxzoom")) {
                    zoomMax = it.value.toDouble()
                } else if (it.key.equals("minzoom")) {
                    zoomMin = it.value.toDouble()
                }
            }
            return MBTilesMetadata(attribution, name, format, version,
                    latitudeSW, longitudeSW, latitudeNE, longitudeNE, zoomMin, zoomMax)
        }catch(e :Exception){
            e.printStackTrace()
        }
        return null;
    }

    private fun createMainFolder(filename: String, path: String): File? {
        val context = contextReference.get();
        var mainDir = File(path, filename)
        if (path.isEmpty())
            mainDir = File(context!!.getExternalFilesDir(null), filename)
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

}