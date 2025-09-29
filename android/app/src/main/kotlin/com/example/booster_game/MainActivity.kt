package com.example.booster_game

import android.os.Bundle
import com.google.android.ump.*
import com.google.android.gms.ads.MobileAds
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private lateinit var consentInformation: ConsentInformation
    private var consentForm: ConsentForm? = null
    
    // MethodChannel constants
    private val SYSTEM_CLEANER_CHANNEL = "system_cleaner"
    private val CPU_MONITOR_CHANNEL = "cpu_monitor"
    
    // Manager instances
    private lateinit var cpuManager: CpuManager
    private lateinit var systemCleaner: SystemCleaner

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Khởi tạo managers
        cpuManager = CpuManager(this)
        systemCleaner = SystemCleaner(this)

        // Khởi động UMP trước khi init quảng cáo
        requestUserConsent()
    }

    private fun requestUserConsent() {
        val params = ConsentRequestParameters
            .Builder()
            .setTagForUnderAgeOfConsent(false)
            .build()

        consentInformation = UserMessagingPlatform.getConsentInformation(this)

        consentInformation.requestConsentInfoUpdate(
            this,
            params,
            {
                if (consentInformation.isConsentFormAvailable) {
                    loadConsentForm()
                } else {
                    initMobileAds()
                }
            },
            { error ->
                println("UMP error: ${error.message}")
                initMobileAds() // fallback nếu lỗi
            }
        )
    }

    private fun loadConsentForm() {
        UserMessagingPlatform.loadConsentForm(
            this,
            { form ->
                consentForm = form
                if (consentInformation.consentStatus == ConsentInformation.ConsentStatus.REQUIRED) {
                    form.show(this) {
                        // Sau khi đóng form, thử lại
                        loadConsentForm()
                    }
                } else {
                    initMobileAds()
                }
            },
            { error ->
                println("UMP load form error: ${error.message}")
                initMobileAds()
            }
        )
    }

    private fun initMobileAds() {
        MobileAds.initialize(this) {
            println("✅ Google Mobile Ads initialized")
        }
    }

    // --- Đăng ký Custom Native Ads + System Cleaner + CPU Monitor ---
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Native Ads
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "customNativeAd",
            CustomNativeAdFactory(this)
        )

        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "customNativeAdMedium",
            CustomNativeAdMediumFactory(this)
        )

        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "customNativeAdFull",
            CustomNativeAdFullFactory(this)
        )

        // 🚀 ENHANCED SYSTEM CLEANER CHANNEL
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SYSTEM_CLEANER_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    // Legacy methods (for backward compatibility)
                    "forceGC" -> {
                        try {
                            systemCleaner.forceGarbageCollection()
                            result.success("GC completed successfully")
                        } catch (e: Exception) {
                            result.error("GC_ERROR", "Failed to run GC: ${e.message}", null)
                        }
                    }
                    "clearSystemCache" -> {
                        try {
                            val clearedSize = systemCleaner.clearSystemCache()
                            result.success("Cleared $clearedSize MB of system cache")
                        } catch (e: Exception) {
                            result.error("CACHE_ERROR", "Failed to clear cache: ${e.message}", null)
                        }
                    }
                    "getMemoryInfo" -> {
                        try {
                            val memoryInfo = systemCleaner.getMemoryInfo()
                            result.success(memoryInfo)
                        } catch (e: Exception) {
                            result.error("MEMORY_ERROR", "Failed to get memory info: ${e.message}", null)
                        }
                    }
                    "getStorageInfo" -> {
                        try {
                            val storageInfo = systemCleaner.getStorageInfo()
                            result.success(storageInfo)
                        } catch (e: Exception) {
                            result.error("STORAGE_ERROR", "Failed to get storage info: ${e.message}", null)
                        }
                    }
                    "killBackgroundApps" -> {
                        try {
                            val killedApps = systemCleaner.killBackgroundApps()
                            result.success("Killed $killedApps background processes")
                        } catch (e: Exception) {
                            result.error("KILL_ERROR", "Failed to kill background apps: ${e.message}", null)
                        }
                    }
                    "clearAppCache" -> {
                        try {
                            val clearedSize = systemCleaner.clearAppCache()
                            result.success("Cleared ${clearedSize}MB of app cache")
                        } catch (e: Exception) {
                            result.error("APP_CACHE_ERROR", "Failed to clear app cache: ${e.message}", null)
                        }
                    }
                    "performFullCleanup" -> {
                        try {
                            val results = systemCleaner.performFullCleanup()
                            result.success(results)
                        } catch (e: Exception) {
                            result.error("FULL_CLEANUP_ERROR", "Failed to perform full cleanup: ${e.message}", null)
                        }
                    }
                    
                    // 🆕 NEW ENHANCED METHODS
                    "killAllRunningApps" -> {
                        try {
                            val results = systemCleaner.killAllRunningApps()
                            result.success(results)
                        } catch (e: Exception) {
                            result.error("KILL_ALL_ERROR", "Failed to kill all apps: ${e.message}", null)
                        }
                    }
                    "clearAllCache" -> {
                        try {
                            val results = systemCleaner.clearAllCache()
                            result.success(results)
                        } catch (e: Exception) {
                            result.error("CLEAR_ALL_CACHE_ERROR", "Failed to clear all cache: ${e.message}", null)
                        }
                    }
                    "deleteTemporaryFiles" -> {
                        try {
                            val results = systemCleaner.deleteTemporaryFiles()
                            result.success(results)
                        } catch (e: Exception) {
                            result.error("DELETE_TEMP_ERROR", "Failed to delete temp files: ${e.message}", null)
                        }
                    }
                    "clearJunkFiles" -> {
                        try {
                            val results = systemCleaner.clearJunkFiles()
                            result.success(results)
                        } catch (e: Exception) {
                            result.error("CLEAR_JUNK_ERROR", "Failed to clear junk files: ${e.message}", null)
                        }
                    }
                    "clearMemory" -> {
                        try {
                            val results = systemCleaner.clearMemory()
                            result.success(results)
                        } catch (e: Exception) {
                            result.error("CLEAR_MEMORY_ERROR", "Failed to clear memory: ${e.message}", null)
                        }
                    }
                    "performDeepCleanup" -> {
                        try {
                            val results = systemCleaner.performDeepCleanup()
                            result.success(results)
                        } catch (e: Exception) {
                            result.error("DEEP_CLEANUP_ERROR", "Failed to perform deep cleanup: ${e.message}", null)
                        }
                    }
                    "getSystemStats" -> {
                        try {
                            val stats = systemCleaner.getSystemStats()
                            result.success(stats)
                        } catch (e: Exception) {
                            result.error("SYSTEM_STATS_ERROR", "Failed to get system stats: ${e.message}", null)
                        }
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            }

        // 🧠 CPU MONITOR CHANNEL  
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CPU_MONITOR_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getCpuUsage" -> {
                        try {
                            val cpuUsage = cpuManager.getCpuUsage()
                            result.success(cpuUsage)
                        } catch (e: Exception) {
                            result.error("CPU_ERROR", "Failed to get CPU usage: ${e.message}", null)
                        }
                    }
                    "getAppCpuUsage" -> {
                        try {
                            val appCpuUsage = cpuManager.getAppCpuUsage()
                            result.success(appCpuUsage)
                        } catch (e: Exception) {
                            result.error("APP_CPU_ERROR", "Failed to get app CPU usage: ${e.message}", null)
                        }
                    }
                    "getCpuInfo" -> {
                        try {
                            val cpuInfo = cpuManager.getCpuInfo()
                            result.success(cpuInfo)
                        } catch (e: Exception) {
                            result.error("CPU_INFO_ERROR", "Failed to get CPU info: ${e.message}", null)
                        }
                    }
                    "testCpuMethods" -> {
                        try {
                            val testResults = cpuManager.testAllMethods()
                            result.success(testResults)
                        } catch (e: Exception) {
                            result.error("CPU_TEST_ERROR", "Failed to test CPU methods: ${e.message}", null)
                        }
                    }
                    "resetCpuManager" -> {
                        try {
                            cpuManager.reset()
                            result.success("CPU Manager reset successfully")
                        } catch (e: Exception) {
                            result.error("CPU_RESET_ERROR", "Failed to reset CPU manager: ${e.message}", null)
                        }
                    }
                    else -> {
                        result.notImplemented()
                    }
                }
            }
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "customNativeAd")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "customNativeAdMedium")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "customNativeAdFull")
    }
}