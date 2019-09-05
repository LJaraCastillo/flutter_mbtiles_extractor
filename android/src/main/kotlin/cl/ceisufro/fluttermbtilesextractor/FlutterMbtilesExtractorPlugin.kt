package cl.ceisufro.fluttermbtilesextractor

import android.Manifest
import android.app.Activity
import android.content.pm.PackageManager
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.lang.ref.WeakReference


class FlutterMbtilesExtractorPlugin(private val activity: Activity)
    : MethodCallHandler, EventChannel.StreamHandler, PluginRegistry.RequestPermissionsResultListener {

    private val permissionRequestCode = 1
    private lateinit var result: Result

    companion object {

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val methodChannel = MethodChannel(registrar.messenger(), "flutter_mbtiles_extractor")
            val eventChannel = EventChannel(registrar.messenger(), "flutter_mbtiles_extractor_progress")
            val plugin = FlutterMbtilesExtractorPlugin(registrar.activity())
            methodChannel.setMethodCallHandler(plugin)
            eventChannel.setStreamHandler(plugin)
            registrar.addRequestPermissionsResultListener(plugin)
        }
    }

    private var sinks = mutableListOf<EventChannel.EventSink?>()


    override fun onListen(args: Any?, sink: EventChannel.EventSink?) {
        sinks.add(sink)
    }

    override fun onCancel(args: Any?) {
        sinks.forEach {
            it?.endOfStream()
        }
        sinks.clear()
    }


    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "extractMBTilesFile") {
            val map = call.arguments as Map<String, Any>
            val extractRequest = ExtractRequest.fromMap(map)
            Executor.executeExtractAsync(WeakReference(activity), extractRequest, object : ExecutionCallback {
                override fun onTaskFinish(extractResult: ExtractResult?) {
                    result.success(extractResult!!.toMap())
                }
            }, sinks)
        } else if (call.method == "requestPermissions") {
            if (!Utils.hasPermissions(activity)) {
                this.result = result
                requestStoragePermissions()
            } else {
                result.success(true)
            }
        } else {
            result.notImplemented()
        }
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
                    permissionRequestCode)
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>?, result: IntArray?): Boolean {
        var granted = false
        when (requestCode) {
            permissionRequestCode -> {
                if (result != null && result.isNotEmpty() && result[0] == PackageManager.PERMISSION_GRANTED) {
                    granted = true
                }
                this.result.success(granted)
                return true
            }
        }
        return false
    }

}
