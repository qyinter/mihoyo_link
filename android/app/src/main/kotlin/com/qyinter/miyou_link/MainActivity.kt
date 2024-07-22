package com.qyinter.miyou_link

import android.content.Context
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.util.DisplayMetrics
import android.view.WindowManager
import android.location.LocationManager
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import android.telephony.TelephonyManager

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.qyinter.miyou_link/device"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getDeviceInfo") {
                val deviceInfo = getDeviceInfo()
                result.success(deviceInfo)
            } else {
                result.notImplemented()
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
        val uiMode = getUiMode()
        val isMockLocation = isMockLocationEnabled()

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
            "uiMode" to uiMode,
            "isMockLocation" to isMockLocation
        )
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


    private fun getUiMode(): String {
        val uiModeManager = getSystemService(Context.UI_MODE_SERVICE) as UiModeManager
        return when (uiModeManager.currentModeType) {
            UiModeManager.MODE_NIGHT_NO -> "UI_MODE_TYPE_NORMAL"
            UiModeManager.MODE_NIGHT_YES -> "UI_MODE_TYPE_CAR"
            UiModeManager.MODE_NIGHT_AUTO -> "UI_MODE_TYPE_TELEVISION"
            UiModeManager.MODE_NIGHT_CUSTOM -> "UI_MODE_TYPE_APPLIANCE"
            UiModeManager.MODE_NIGHT_UNDEFINED -> "UI_MODE_TYPE_WATCH"
            else -> "UNKNOWN"
        }
    }

    private fun isMockLocationEnabled(): Int {
        val locationManager = getSystemService(Context.LOCATION_SERVICE) as LocationManager
        val providers = locationManager.allProviders
        return if (providers.contains(LocationManager.GPS_PROVIDER) || providers.contains(LocationManager.NETWORK_PROVIDER)) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                if (locationManager.isProviderMock(LocationManager.GPS_PROVIDER) || locationManager.isProviderMock(LocationManager.NETWORK_PROVIDER)) {
                    1
                } else {
                    0
                }
            } else {
                android.provider.Settings.Secure.getString(contentResolver, android.provider.Settings.Secure.ALLOW_MOCK_LOCATION) != "0"
            }
        } else {
            0
        }
    }
}