package com.qyinter.miyou_link

import android.content.Context
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.util.DisplayMetrics
import android.view.WindowManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import android.telephony.TelephonyManager

import com.github.gzuliyujiang.oaid.DeviceID;
import com.github.gzuliyujiang.oaid.IGetter;

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.qyinter.miyou_link/device"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
             when (call.method) {
                "getDeviceInfo" -> {
                    val deviceInfo = getDeviceInfo()
                    result.success(deviceInfo)
                }
                "getOaid" -> {
                    getOaid { oaid ->
                        val oaidMap = mapOf("oaid" to oaid)
                        result.success(oaidMap)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun getDeviceInfo(): Map<String, Any> {
        val sdCapacity = getTotalInternalMemorySize()
        val ramRemain = getAvailableInternalMemorySize()
        val screenSize = getScreenSize()
        val hostName = getHostname()
        val buildType = Build.TYPE
        val buildTags = Build.TAGS
        val buildTime = Build.TIME
        val buildUser = Build.USER
        val simState = getSimState()
        val cpuType = getCpuType()
        val manufacturer = Build.MANUFACTURER

        return mapOf(
            "sdCapacity" to sdCapacity,
            "ramRemain" to ramRemain,
            "screenSize" to screenSize,
            "hostName" to hostName,
            "buildType" to buildType,
            "buildTags" to buildTags,
            "buildTime" to buildTime,
            "buildUser" to buildUser,
            "simState" to simState,
            "cpuType" to cpuType,
            "manufacturer" to manufacturer
        )
    }

    private fun getOaid(callback: (String) -> Unit) {
        try{
            DeviceID.getOAID(this, object : IGetter {
                override fun onOAIDGetComplete(result: String) {
                    callback(result)
                }

                override fun onOAIDGetError(error: Exception) {
                    callback("error_1008003")
                }
            })
        }catch(error: Exception){
            callback("error_1008003")
        }
    }
    
    private fun getTotalInternalMemorySize(): String {
        val path = Environment.getDataDirectory()
        val stat = android.os.StatFs(path.path)
        val blockSize = stat.blockSizeLong
        val totalBlocks = stat.blockCountLong
        val totalBytes = totalBlocks * blockSize
        val totalMB = totalBytes / (1024 * 1024)
        return totalMB.toString()
    }

    private fun getAvailableInternalMemorySize(): String {
        val path = Environment.getDataDirectory()
        val stat = android.os.StatFs(path.path)
        val blockSize = stat.blockSizeLong
        val availableBlocks = stat.availableBlocksLong
        val availableBytes = availableBlocks * blockSize
        val availableMB = availableBytes / (1024 * 1024)
        return availableMB.toString()
    }

    private fun getScreenSize(): String {
        val windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager
        val display = windowManager.defaultDisplay
        val metrics = DisplayMetrics()
        display.getMetrics(metrics)
        val width = metrics.widthPixels
        val height = metrics.heightPixels
        return "${width}x${height}"
    }

    private fun getHostname(): String {
        return try {
            Build.HOST
        } catch (e: Exception) {
            "unknown"
        }
    }

    private fun getSimState(): Int {
        val telephonyManager = getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
        return telephonyManager.simState
    }

    private fun getCpuType(): String {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            Build.SUPPORTED_ABIS.joinToString(", ")
        } else {
            @Suppress("DEPRECATION")
            Build.CPU_ABI
        }
    }
}