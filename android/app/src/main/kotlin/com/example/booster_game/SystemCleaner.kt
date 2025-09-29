package com.example.booster_game

import android.content.Context
import android.app.ActivityManager
import android.content.pm.ApplicationInfo
import android.os.Build
import android.os.Environment
import android.os.StatFs
import java.io.File
import java.util.concurrent.TimeUnit

class SystemCleaner(private val context: Context) {

    /**
     * Force garbage collection - Enhanced version
     */
    fun forceGarbageCollection() {
        println("🗑️ Starting enhanced garbage collection...")

        repeat(3) {
            System.gc()
            Runtime.getRuntime().gc()
            Thread.sleep(200)
        }

        System.runFinalization()
        Thread.sleep(100)
        System.gc()

        println("🗑️ Enhanced Garbage Collection completed")
    }

    /**
     * Kill ALL running apps (except system and current app)
     */
    fun killAllRunningApps(): Map<String, Any> {
        var killedCount = 0
        val killedApps = mutableListOf<String>()

        try {
            val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            val packageManager = context.packageManager

            val runningProcesses = activityManager.runningAppProcesses

            runningProcesses?.forEach { processInfo ->
                try {
                    if (processInfo.processName != context.packageName) {
                        val appInfo = packageManager.getApplicationInfo(processInfo.processName, 0)
                        val isSystemApp = (appInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0

                        if (!isSystemApp || processInfo.importance > ActivityManager.RunningAppProcessInfo.IMPORTANCE_SERVICE) {
                            android.os.Process.killProcess(processInfo.pid)
                            killedApps.add(processInfo.processName)
                            killedCount++
                        }
                    }
                } catch (_: Exception) {
                }
            }

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                try {
                    activityManager.killBackgroundProcesses(context.packageName)
                } catch (_: Exception) {}
            }

            println("⚡ Killed $killedCount applications")

        } catch (e: Exception) {
            println("❌ Error killing applications: ${e.message}")
        }

        return mapOf(
            "killedCount" to killedCount,
            "killedApps" to killedApps,
            "success" to true
        )
    }

    /**
     * Clear all cache
     */
    fun clearAllCache(): Map<String, Any> {
        var totalClearedSize = 0L
        val results = mutableMapOf<String, Any>()

        try {
            val internalCache = context.cacheDir
            val internalCacheSize = deleteFolderRecursively(internalCache)

            val externalCache = context.externalCacheDir
            val externalCacheSize = if (externalCache != null) deleteFolderRecursively(externalCache) else 0L

            val codeCacheSize = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                deleteFolderRecursively(context.codeCacheDir)
            } else 0L

            val obbCacheSize = clearObbCache()

            totalClearedSize = internalCacheSize + externalCacheSize + codeCacheSize + obbCacheSize

            results["internalCache"] = "${internalCacheSize / (1024 * 1024)}MB"
            results["externalCache"] = "${externalCacheSize / (1024 * 1024)}MB"
            results["codeCache"] = "${codeCacheSize / (1024 * 1024)}MB"
            results["obbCache"] = "${obbCacheSize / (1024 * 1024)}MB"
            results["totalCleared"] = "${totalClearedSize / (1024 * 1024)}MB"
            results["success"] = true

            println("🧹 Total cache cleared: ${totalClearedSize / (1024 * 1024)}MB")

        } catch (e: Exception) {
            println("❌ Error clearing cache: ${e.message}")
            results["error"] = e.message ?: "Unknown error"
            results["success"] = false
        }

        return results
    }

    /**
     * Delete temporary files
     */
    fun deleteTemporaryFiles(): Map<String, Any> {
        var deletedCount = 0
        var deletedSize = 0L
        val deletedLocations = mutableListOf<String>()

        try {
            val tempExtensions = listOf(".tmp", ".temp", ".log", ".bak", ".old", ".cache", ".swp")
            val locationsToClean = mutableListOf<File>()

            context.cacheDir?.let { locationsToClean.add(it) }
            context.filesDir?.let { locationsToClean.add(it) }
            context.externalCacheDir?.let { locationsToClean.add(it) }

            if (Environment.getExternalStorageState() == Environment.MEDIA_MOUNTED) {
                Environment.getExternalStorageDirectory()?.let { extStorage ->
                    File(extStorage, "Android/data").listFiles()?.forEach { appDir ->
                        File(appDir, "cache").takeIf { it.exists() }?.let { locationsToClean.add(it) }
                        File(appDir, "tmp").takeIf { it.exists() }?.let { locationsToClean.add(it) }
                    }
                    File(extStorage, "temp").takeIf { it.exists() }?.let { locationsToClean.add(it) }
                    File(extStorage, ".tmp").takeIf { it.exists() }?.let { locationsToClean.add(it) }
                }
            }

            locationsToClean.forEach { location ->
                try {
                    location.walkTopDown().forEach { file ->
                        if (file.isFile) {
                            val fileName = file.name.lowercase()
                            val shouldDelete = tempExtensions.any { ext -> fileName.endsWith(ext) } ||
                                    fileName.startsWith("tmp") ||
                                    fileName.contains("temp") ||
                                    (file.lastModified() < System.currentTimeMillis() - TimeUnit.DAYS.toMillis(7))
                            if (shouldDelete) {
                                val size = file.length()
                                if (file.delete()) {
                                    deletedCount++
                                    deletedSize += size
                                    if (!deletedLocations.contains(location.absolutePath)) {
                                        deletedLocations.add(location.absolutePath)
                                    }
                                }
                            }
                        }
                    }
                } catch (_: Exception) {}
            }

            println("🗂️ Deleted $deletedCount temp files (${deletedSize / (1024 * 1024)}MB)")

        } catch (e: Exception) {
            println("❌ Error deleting temp files: ${e.message}")
        }

        return mapOf(
            "deletedCount" to deletedCount,
            "deletedSize" to "${deletedSize / (1024 * 1024)}MB",
            "cleanedLocations" to deletedLocations,
            "success" to true
        )
    }

    /**
     * Clear junk files
     */
    fun clearJunkFiles(): Map<String, Any> {
        var deletedCount = 0
        var deletedSize = 0L
        val junkTypes = mutableMapOf<String, Int>()

        try {
            val junkPatterns = mapOf(
                "thumbnails" to listOf(".thumbnails", "thumbs.db", ".ds_store"),
                "logs" to listOf(".log", "crash", "error.log", "debug.log"),
                "backups" to listOf(".bak", ".backup", ".old", "~"),
                "temp_media" to listOf(".tmp.jpg", ".tmp.png", ".tmp.mp4", ".tmp.mp3"),
                "system_junk" to listOf("desktop.ini", ".directory", ".localized")
            )

            if (Environment.getExternalStorageState() == Environment.MEDIA_MOUNTED) {
                Environment.getExternalStorageDirectory()?.walkTopDown()?.forEach { file ->
                    if (file.isFile) {
                        val fileName = file.name.lowercase()
                        junkPatterns.forEach { (category, patterns) ->
                            if (patterns.any { pattern -> fileName.contains(pattern) || fileName.endsWith(pattern) }) {
                                val size = file.length()
                                if (file.delete()) {
                                    deletedCount++
                                    deletedSize += size
                                    junkTypes[category] = (junkTypes[category] ?: 0) + 1
                                }
                            }
                        }
                    }
                }
            }

            println("🗑️ Deleted $deletedCount junk files (${deletedSize / (1024 * 1024)}MB)")

        } catch (e: Exception) {
            println("❌ Error clearing junk files: ${e.message}")
        }

        return mapOf(
            "deletedCount" to deletedCount,
            "deletedSize" to "${deletedSize / (1024 * 1024)}MB",
            "junkTypes" to junkTypes,
            "success" to true
        )
    }

    private fun clearObbCache(): Long {
        var clearedSize = 0L
        try {
            val obbDir = context.obbDir
            if (obbDir?.exists() == true) {
                clearedSize = deleteFolderRecursively(obbDir)
            }
        } catch (e: Exception) {
            println("Error clearing OBB cache: ${e.message}")
        }
        return clearedSize
    }

    fun clearMemory(): Map<String, Any> {
        val results = mutableMapOf<String, Any>()
        try {
            val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            val memoryInfoBefore = ActivityManager.MemoryInfo()
            activityManager.getMemoryInfo(memoryInfoBefore)

            forceGarbageCollection()
            Runtime.getRuntime().gc()
            System.runFinalization()

            val memoryInfoAfter = ActivityManager.MemoryInfo()
            activityManager.getMemoryInfo(memoryInfoAfter)

            val memoryFreed = (memoryInfoAfter.availMem - memoryInfoBefore.availMem) / (1024 * 1024)

            results["memoryFreed"] = "${memoryFreed}MB"
            results["availableMemoryBefore"] = "${memoryInfoBefore.availMem / (1024 * 1024)}MB"
            results["availableMemoryAfter"] = "${memoryInfoAfter.availMem / (1024 * 1024)}MB"
            results["success"] = true

            println("🧠 Memory freed: ${memoryFreed}MB")

        } catch (e: Exception) {
            println("❌ Error clearing memory: ${e.message}")
            results["error"] = e.message ?: "Unknown error"
            results["success"] = false
        }

        return results
    }

    fun performDeepCleanup(): Map<String, Any> {
        val results = mutableMapOf<String, Any>()
        try {
            println("🚀 Starting DEEP SYSTEM CLEANUP...")

            val killedApps = killAllRunningApps()
            results["killedApps"] = killedApps

            Thread.sleep(1000)

            results["cacheClearing"] = clearAllCache()
            results["tempFiles"] = deleteTemporaryFiles()
            results["junkFiles"] = clearJunkFiles()
            results["memoryCleanup"] = clearMemory()
            results["finalStats"] = getSystemStats()

            results["success"] = true
            results["message"] = "Deep cleanup completed successfully!"

            println("✅ DEEP CLEANUP COMPLETED!")

        } catch (e: Exception) {
            println("❌ Error during deep cleanup: ${e.message}")
            results["success"] = false
            results["error"] = e.message ?: "Unknown error"
        }

        return results
    }

    fun getSystemStats(): Map<String, Any> {
        val stats = mutableMapOf<String, Any>()
        try {
            val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
            val memoryInfo = ActivityManager.MemoryInfo()
            activityManager.getMemoryInfo(memoryInfo)

            stats["totalRAM"] = "${memoryInfo.totalMem / (1024 * 1024)}MB"
            stats["availableRAM"] = "${memoryInfo.availMem / (1024 * 1024)}MB"
            stats["usedRAM"] = "${(memoryInfo.totalMem - memoryInfo.availMem) / (1024 * 1024)}MB"
            stats["isLowMemory"] = memoryInfo.lowMemory

            val stat = StatFs(Environment.getDataDirectory().path)
            val totalStorage = stat.blockSizeLong * stat.blockCountLong
            val availableStorage = stat.blockSizeLong * stat.availableBlocksLong

            stats["totalStorage"] = "${totalStorage / (1024 * 1024)}MB"
            stats["availableStorage"] = "${availableStorage / (1024 * 1024)}MB"
            stats["usedStorage"] = "${(totalStorage - availableStorage) / (1024 * 1024)}MB"

            stats["runningApps"] = activityManager.runningAppProcesses?.size ?: 0

        } catch (e: Exception) {
            println("Error getting system stats: ${e.message}")
        }
        return stats
    }

    private fun deleteFolderRecursively(folder: File?): Long {
        var deletedSize = 0L
        try {
            folder?.let { dir ->
                if (dir.exists()) {
                    if (dir.isDirectory) {
                        dir.listFiles()?.forEach { file ->
                            if (file.isDirectory) {
                                deletedSize += deleteFolderRecursively(file)
                            } else {
                                val size = file.length()
                                try {
                                    if (file.delete()) {
                                        deletedSize += size
                                    }
                                } catch (_: SecurityException) {}
                            }
                        }
                        if (dir != context.cacheDir && dir != context.externalCacheDir) {
                            dir.delete()
                        }
                    } else {
                        val size = dir.length()
                        if (dir.delete()) {
                            deletedSize += size
                        }
                    }
                }
            }
        } catch (e: Exception) {
            println("❌ Error deleting folder ${folder?.path}: ${e.message}")
        }
        return deletedSize
    }

    // Legacy methods (safe type casting)
    fun clearSystemCache(): Long {
        val totalCleared = clearAllCache()["totalCleared"]
        return (totalCleared as? String)?.replace("MB", "")?.toLongOrNull() ?: 0L
    }

    fun clearAppCache(): Long {
        val totalCleared = clearAllCache()["totalCleared"]
        return (totalCleared as? String)?.replace("MB", "")?.toLongOrNull() ?: 0L
    }

    fun killBackgroundApps(): Int {
        val killedCount = killAllRunningApps()["killedCount"]
        return killedCount as? Int ?: 0
    }

    fun getMemoryInfo(): Map<String, Any> = getSystemStats()
    fun getStorageInfo(): Map<String, Any> = getSystemStats()
    fun performFullCleanup(): Map<String, Any> = performDeepCleanup()
}
