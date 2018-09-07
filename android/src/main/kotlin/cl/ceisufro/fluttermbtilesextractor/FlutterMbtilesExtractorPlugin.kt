package cl.ceisufro.fluttermbtilesextractor

import android.Manifest
import android.app.Activity
import android.content.pm.PackageManager
import android.support.v4.app.ActivityCompat
import android.support.v4.content.ContextCompat
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar
import java.lang.ref.WeakReference


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

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method.equals("extractMBTilesFile")) {
            val map = call.arguments as Map<String, Any>
            val extractRequest = ExtractRequest.fromMap(map)
            Executor.executeExtractAsync(WeakReference(activity), extractRequest, object : ExecutionCallback {
                override fun onTaskFinish(extractResult: ExtractResult?) {
                    result.success(extractResult!!.toMap())
                }
            })
        } else if (call.method.equals("requestPermissions")) {
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
