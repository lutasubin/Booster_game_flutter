package com.example.booster_game

import android.os.Bundle
import android.content.Context
import android.app.ActivityManager
import android.content.pm.PackageManager
import android.os.Build
import android.os.StatFs
import android.os.Environment
import java.io.File
import com.google.android.ump.*
import com.google.android.gms.ads.MobileAds
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private lateinit var consentInformation: ConsentInformation
    private var consentForm: ConsentForm? = null
    
    // MethodChannel cho system cleaner
    private val SYSTEM_CLEANER_CHANNEL = "system_cleaner"
    
    // MethodChannel cho CPU monitoring
    private val CPU_MONITOR_CHANNEL = "cpu_monitor"
    
    // CpuManager instance
    private lateinit var cpuManager: CpuManager

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Khởi tạo CpuManager
        cpuManager = CpuManager(this)

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

        // 🚀 SYSTEM CLEANER CHANNEL
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SYSTEM_CLEANER_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "forceGC" -> {
                        try {
                            forceGarbageCollection()
                            result.success("GC completed successfully")
                        } catch (e: Exception) {
                            result.error("GC_ERROR", "Failed to run GC: ${e.message}", null)
                        }
                    }
                    "clearSystemCache" -> {
                        try {
                            val clearedSize = clearSystemCache()
                            result.success("Cleared $clearedSize MB of system cache")
                        } catch (e: Exception) {
                            result.error("CACHE_ERROR", "Failed to clear cache: ${e.message}", null)
                        }
                    }
                    "getMemoryInfo" -> {
                        try {
                            val memoryInfo = getMemoryInfo()
                            result.success(memoryInfo)
                        } catch (e: Exception) {
                            result.error("MEMORY_ERROR", "Failed to get memory info: ${e.message}", null)
                        }
                    }
                    "getStorageInfo" -> {
                        try {
                            val storageInfo = getStorageInfo()
                            result.success(storageInfo)
                        } catch (e: Exception) {
                            result.error("STORAGE_ERROR", "Failed to get storage info: ${e.message}", null)
                        }
                    }
                    "killBackgroundApps" -> {
                        try {
                            val killedApps = killBackgroundApps()
                            result.success("Killed $killedApps background processes")
                        } catch (e: Exception) {
                            result.error("KILL_ERROR", "Failed to kill background apps: ${e.message}", null)
                        }
                    }
                    "clearAppCache" -> {
                        try {
                            val clearedSize = clearAppCache()
                            result.success("Cleared ${clearedSize}MB of app cache")
                        } catch (e: Exception) {
                            result.error("APP_CACHE_ERROR", "Failed to clear app cache: ${e.message}", null)
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

    // 🧹 EXISTING SYSTEM CLEANER FUNCTIONS (giữ nguyên)
    
    private fun forceGarbageCollection() {
        System.gc()
        Runtime.getRuntime().gc()
        Thread.sleep(100)
        System.gc()
        println("🗑️ Garbage Collection completed")
    }
    
    private fun clearSystemCache(): Long {
        var clearedSize = 0L
        
        try {
            val cacheDir = cacheDir
            if (cacheDir != null && cacheDir.exists()) {
                clearedSize = deleteFolderRecursively(cacheDir)
            }
            
            val externalCacheDir = externalCacheDir
            if (externalCacheDir != null && externalCacheDir.exists()) {
                clearedSize += deleteFolderRecursively(externalCacheDir)
            }
            
            println("🧹 System cache cleared: ${clearedSize / (1024 * 1024)}MB")
            
        } catch (e: Exception) {
            println("❌ Error clearing system cache: ${e.message}")
        }
        
        return clearedSize / (1024 * 1024)
    }
    
    private fun getMemoryInfo(): Map<String, Any> {
        val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val memoryInfo = ActivityManager.MemoryInfo()
        activityManager.getMemoryInfo(memoryInfo)
        
        val totalRAM = memoryInfo.totalMem / (1024 * 1024)
        val availableRAM = memoryInfo.availMem / (1024 * 1024)
        val usedRAM = totalRAM - availableRAM
        val memoryThreshold = memoryInfo.threshold / (1024 * 1024)
        
        return mapOf(
            "totalRAM" to totalRAM,
            "availableRAM" to availableRAM,
            "usedRAM" to usedRAM,
            "memoryThreshold" to memoryThreshold,
            "isLowMemory" to memoryInfo.lowMemory
        )
    }
    
    private fun getStorageInfo(): Map<String, Any> {
        val stat = StatFs(Environment.getDataDirectory().path)
        val bytesAvailable = stat.blockSizeLong * stat.availableBlocksLong
        val bytesTotal = stat.blockSizeLong * stat.blockCountLong
        val bytesUsed = bytesTotal - bytesAvailable
        
        return mapOf(
            "totalStorage" to bytesTotal / (1024 * 1024),
            "availableStorage" to bytesAvailable / (1024 * 1024),
            "usedStorage" to bytesUsed / (1024 * 1024)
        )
    }
    
    private fun killBackgroundApps(): Int {
        var killedCount = 0
        
        try {
            val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            val runningApps = activityManager.runningAppProcesses
            val packageManager = packageManager
            
            runningApps?.forEach { processInfo ->
                try {
                    if (processInfo.processName != packageName && 
                        processInfo.importance > ActivityManager.RunningAppProcessInfo.IMPORTANCE_VISIBLE) {
                        android.os.Process.killProcess(processInfo.pid)
                        killedCount++
                    }
                } catch (e: Exception) {
                    // Ignore
                }
            }
            
            println("⚡ Killed $killedCount background processes")
            
        } catch (e: Exception) {
            println("❌ Error killing background apps: ${e.message}")
        }
        
        return killedCount
    }
    
    private fun clearAppCache(): Long {
        var clearedSize = 0L
        
        try {
            val cacheDir = cacheDir
            if (cacheDir?.exists() == true) {
                clearedSize += deleteFolderRecursively(cacheDir)
            }
            
            val externalCacheDir = externalCacheDir  
            if (externalCacheDir?.exists() == true) {
                clearedSize += deleteFolderRecursively(externalCacheDir)
            }
            
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                val codeCacheDir = codeCacheDir
                if (codeCacheDir?.exists() == true) {
                    clearedSize += deleteFolderRecursively(codeCacheDir)
                }
            }
            
        } catch (e: Exception) {
            println("❌ Error clearing app cache: ${e.message}")
        }
        
        return clearedSize / (1024 * 1024)
    }
    
    private fun deleteFolderRecursively(folder: File): Long {
        var deletedSize = 0L
        
        try {
            if (folder.exists()) {
                folder.listFiles()?.forEach { file ->
                    if (file.isDirectory) {
                        deletedSize += deleteFolderRecursively(file)
                    } else {
                        val size = file.length()
                        if (file.delete()) {
                            deletedSize += size
                        }
                    }
                }
                folder.delete()
            }
        } catch (e: Exception) {
            println("❌ Error deleting folder ${folder.path}: ${e.message}")
        }
        
        return deletedSize
    }
}