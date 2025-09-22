plugins {
    id("com.android.application")
    // START: FlutterFire Configuration (nếu dùng Firebase)
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.booster_game"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // Hỗ trợ Java 8+ API trên Android cũ
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.example.booster_game"
        minSdk = 23
        targetSdk = 35
        versionCode = 1
        versionName = "1.0"

        // Nếu dùng nhiều SDK thì nên bật
        multiDexEnabled = true
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("debug")
          
        }
    }
}

dependencies {
    // Google SDKs
    implementation("com.google.android.ump:user-messaging-platform:2.1.0")
    implementation("com.google.android.gms:play-services-ads:24.4.0")

    // AndroidX UI
    implementation("androidx.constraintlayout:constraintlayout:2.1.4")

    // AndroidX hỗ trợ thêm
    implementation("androidx.multidex:multidex:2.0.1")
    implementation("androidx.localbroadcastmanager:localbroadcastmanager:1.0.0")
    implementation("androidx.work:work-runtime:2.9.0")

    // Java 8+ API trên Android cũ
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}

flutter {
    source = "../.."
}
