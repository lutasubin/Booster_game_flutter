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

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

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

    // --- Đăng ký Custom Native Ads + System Cleaner ---
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
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "customNativeAd")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "customNativeAdMedium")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "customNativeAdFull")
    }

    // 🧹 SYSTEM CLEANER FUNCTIONS
    
    /**
     * Force garbage collection
     */
    private fun forceGarbageCollection() {
        // Gọi GC multiple times để đảm bảo hiệu quả
        System.gc()
        Runtime.getRuntime().gc()
        
        // Sleep một chút để GC có thời gian chạy
        Thread.sleep(100)
        
        // Gọi lại lần nữa
        System.gc()
        
        println("🗑️ Garbage Collection completed")
    }
    
    /**
     * Clear system cache (requires system permissions - may not work on all devices)
     */
    private fun clearSystemCache(): Long {
        var clearedSize = 0L
        
        try {
            // Clear app's internal cache
            val cacheDir = cacheDir
            if (cacheDir != null && cacheDir.exists()) {
                clearedSize = deleteFolderRecursively(cacheDir)
            }
            
            // Clear external cache if available
            val externalCacheDir = externalCacheDir
            if (externalCacheDir != null && externalCacheDir.exists()) {
                clearedSize += deleteFolderRecursively(externalCacheDir)
            }
            
            println("🧹 System cache cleared: ${clearedSize / (1024 * 1024)}MB")
            
        } catch (e: Exception) {
            println("❌ Error clearing system cache: ${e.message}")
        }
        
        return clearedSize / (1024 * 1024) // Convert to MB
    }
    
    /**
     * Get memory information
     */
    private fun getMemoryInfo(): Map<String, Any> {
        val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val memoryInfo = ActivityManager.MemoryInfo()
        activityManager.getMemoryInfo(memoryInfo)
        
        val totalRAM = memoryInfo.totalMem / (1024 * 1024) // MB
        val availableRAM = memoryInfo.availMem / (1024 * 1024) // MB
        val usedRAM = totalRAM - availableRAM
        val memoryThreshold = memoryInfo.threshold / (1024 * 1024) // MB
        
        return mapOf(
            "totalRAM" to totalRAM,
            "availableRAM" to availableRAM,
            "usedRAM" to usedRAM,
            "memoryThreshold" to memoryThreshold,
            "isLowMemory" to memoryInfo.lowMemory
        )
    }
    
    /**
     * Get storage information
     */
    private fun getStorageInfo(): Map<String, Any> {
        val stat = StatFs(Environment.getDataDirectory().path)
        val bytesAvailable = stat.blockSizeLong * stat.availableBlocksLong
        val bytesTotal = stat.blockSizeLong * stat.blockCountLong
        val bytesUsed = bytesTotal - bytesAvailable
        
        return mapOf(
            "totalStorage" to bytesTotal / (1024 * 1024), // MB
            "availableStorage" to bytesAvailable / (1024 * 1024), // MB
            "usedStorage" to bytesUsed / (1024 * 1024) // MB
        )
    }
    
    /**
     * Kill background apps (limited effectiveness on modern Android)
     */
    private fun killBackgroundApps(): Int {
        var killedCount = 0
        
        try {
            val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            
            // Get running app processes
            val runningApps = activityManager.runningAppProcesses
            val packageManager = packageManager
            
            runningApps?.forEach { processInfo ->
                try {
                    // Chỉ kill các process không phải system và không phải app hiện tại
                    if (processInfo.processName != packageName && 
                        processInfo.importance > ActivityManager.RunningAppProcessInfo.IMPORTANCE_VISIBLE) {
                        
                        // Thử kill process (có thể không work trên Android mới)
                        android.os.Process.killProcess(processInfo.pid)
                        killedCount++
                    }
                } catch (e: Exception) {
                    // Ignore - không có quyền kill process này
                }
            }
            
            println("⚡ Killed $killedCount background processes")
            
        } catch (e: Exception) {
            println("❌ Error killing background apps: ${e.message}")
        }
        
        return killedCount
    }
    
    /**
     * Clear app's cache directories
     */
    private fun clearAppCache(): Long {
        var clearedSize = 0L
        
        try {
            // Clear internal cache
            val cacheDir = cacheDir
            if (cacheDir?.exists() == true) {
                clearedSize += deleteFolderRecursively(cacheDir)
            }
            
            // Clear external cache
            val externalCacheDir = externalCacheDir  
            if (externalCacheDir?.exists() == true) {
                clearedSize += deleteFolderRecursively(externalCacheDir)
            }
            
            // Clear code cache (Android 5.0+)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                val codeCacheDir = codeCacheDir
                if (codeCacheDir?.exists() == true) {
                    clearedSize += deleteFolderRecursively(codeCacheDir)
                }
            }
            
        } catch (e: Exception) {
            println("❌ Error clearing app cache: ${e.message}")
        }
        
        return clearedSize / (1024 * 1024) // Convert to MB
    }
    
    /**
     * Helper function to delete folder recursively and return size
     */
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
                folder.delete() // Delete the folder itself
            }
        } catch (e: Exception) {
            println("❌ Error deleting folder ${folder.path}: ${e.message}")
        }
        
        return deletedSize
    }
}