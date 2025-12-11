plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id ("com.google.gms.google-services")
    id("com.google.firebase.crashlytics") version "3.0.6" apply false
    id("applovin-quality-service")
}
applovin {
    apiKey = "krw1Xc9M0vKxNQ7E1FQRLQX4RST2gVJT3mK0Vk3rXtC1Es9E0PFzdFJLTygKDrE8Ak9cAp5MPSf1DK8tcG6Cnt"
}

android {
    namespace = "com.example.scratchjoy"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "28.1.13356709"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        // 启用核心库脱糖
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "17"  // 明确指定JVM目标版本为17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
//        applicationId = "com.crazerush.scratest"
        applicationId = "com.crazerush.scra"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        minSdkVersion(27)
        targetSdkVersion(36)
        versionCode = 3
        versionName = "1.0.1"
    }

    signingConfigs {
        create("release") {
            storeFile = file("/Users/scratchwindaily/Desktop/scratchjoysings.jks")
            storePassword = "123456"
            keyAlias = "scratchjoysings"
            keyPassword = "123456"
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // facebook
    implementation ("com.facebook.android:facebook-android-sdk:latest.release")
    // When using the BoM, you don't specify versions in Firebase library dependencies
    implementation("com.google.firebase:firebase-crashlytics-ndk")
    implementation("com.google.firebase:firebase-analytics")
    implementation(platform("com.google.firebase:firebase-bom:34.4.0"))

    // 添加核心库脱糖依赖 通知需要
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")

    implementation ("com.adjust.sdk:adjust-android:4.38.0")

    api("io.github.alex-only:max_adapter_tu:1.2.5")

    implementation ("com.google.android.gms:play-services-ads-identifier:18.1.0")

    implementation ("com.google.gms:google-services:4.3.15")
    implementation("com.applovin.mediation:bidmachine-adapter:+")
    implementation("com.applovin.mediation:bigoads-adapter:+")
    implementation("com.applovin.mediation:chartboost-adapter:+")
    implementation("com.google.android.gms:play-services-base:16.1.0")
    implementation("com.applovin.mediation:fyber-adapter:+")
    implementation("com.applovin.mediation:google-ad-manager-adapter:+")
    implementation("com.applovin.mediation:google-adapter:+")
    implementation("com.applovin.mediation:inmobi-adapter:+")
    implementation("com.squareup.picasso:picasso:2.8")
    implementation("androidx.recyclerview:recyclerview:1.1.0")
    implementation("com.applovin.mediation:ironsource-adapter:8.7.0.0.0")
    implementation("com.applovin.mediation:vungle-adapter:+")
    implementation("com.applovin.mediation:facebook-adapter:+")
    implementation("com.applovin.mediation:mintegral-adapter:16.9.71.0")
    implementation("com.applovin.mediation:mobilefuse-adapter:+")
    implementation("com.applovin.mediation:moloco-adapter:+")
    implementation("com.applovin.mediation:bytedance-adapter:6.5.0.8.1")
    implementation("com.applovin.mediation:unityads-adapter:+")

    //TU (Necessary)
    api ("com.thinkup.sdk:core-tpn:6.4.85")
    api ("com.thinkup.sdk:nativead-tpn:6.4.85")
    api ("com.thinkup.sdk:banner-tpn:6.4.85")
    api ("com.thinkup.sdk:interstitial-tpn:6.4.85")
    api ("com.thinkup.sdk:rewardedvideo-tpn:6.4.85")
    api ("com.thinkup.sdk:splash-tpn:6.4.85")

    //Androidx (Necessary)
    api ("androidx.appcompat:appcompat:1.6.1")
    api ("androidx.browser:browser:1.4.0")

    //Vungle
    api ("com.thinkup.sdk:adapter-tpn-vungle:6.4.85")
    api ("com.vungle:vungle-ads:7.4.3")
    api ("com.google.android.gms:play-services-basement:18.7.1")
    api ("com.google.android.gms:play-services-ads-identifier:18.1.0")

    //UnityAds
    api ("com.thinkup.sdk:adapter-tpn-unityads:6.4.85")
    api ("com.unity3d.ads:unity-ads:4.14.0")

    //Ironsource
    api ("com.thinkup.sdk:adapter-tpn-ironsource:6.4.85")
    api ("com.ironsource.sdk:mediationsdk:8.7.0")
    api ("com.google.android.gms:play-services-appset:16.0.2")
//    api ("com.google.android.gms:play-services-ads-identifier:18.0.1")
    api ("com.google.android.gms:play-services-basement:18.7.1")

    //Bigo
    api ("com.thinkup.sdk:adapter-tpn-bigo:6.4.85")
    api ("com.bigossp:bigo-ads:5.3.0")

    //Pangle
    api ("com.thinkup.sdk:adapter-tpn-pangle:6.4.85")
    api ("com.pangle.global:ads-sdk:6.5.0.6")
//    api ("com.google.android.gms:play-services-ads-identifier:18.0.1")

    //Kwai
    api ("com.thinkup.sdk:adapter-tpn-kwai:6.4.85")
    api ("io.github.kwainetwork:adApi:1.2.15")
    api ("io.github.kwainetwork:adImpl:1.2.15")
    api ("androidx.media3:media3-exoplayer:1.0.0-alpha01")
    api ("androidx.appcompat:appcompat:1.6.1")
    api ("com.google.android.material:material:1.2.1")
    api ("androidx.annotation:annotation:1.2.0")
    api ("org.jetbrains.kotlin:kotlin-stdlib-jdk7:1.4.10")
//    api ("com.google.android.gms:play-services-ads-identifier:18.0.1")

    //Admob
    api ("com.thinkup.sdk:adapter-tpn-admob:6.4.85")
    api ("com.google.android.gms:play-services-ads:24.5.0")

    //Inmobi
    api ("com.thinkup.sdk:adapter-tpn-inmobi:6.4.85")
    api ("com.inmobi.monetization:inmobi-ads-kotlin:10.8.2")

    //AppLovin
    api ("com.thinkup.sdk:adapter-tpn-applovin:6.4.85")
    api ("com.applovin:applovin-sdk:+")

    //Mintegral
    api ("com.thinkup.sdk:adapter-tpn-mintegral:6.4.85")
    api ("com.mbridge.msdk.oversea:mbridge_android_sdk:16.9.11")
    api ("androidx.recyclerview:recyclerview:1.1.0")

    //Bidmachine
    api ("com.thinkup.sdk:adapter-tpn-bidmachine:6.4.85")
    api ("io.bidmachine:ads:3.1.1")

    //Chartboost
    api ("com.thinkup.sdk:adapter-tpn-chartboost:6.4.85")
    api ("com.chartboost:chartboost-sdk:9.8.2")
    api ("com.chartboost:chartboost-mediation-sdk:4.9.2")
    api ("com.chartboost:chartboost-mediation-adapter-chartboost:4.9.8.1.0")
    api ("com.jakewharton.retrofit:retrofit2-kotlinx-serialization-converter:1.0.0")
    api ("com.squareup.okhttp3:logging-interceptor:4.10.0")
    api ("com.squareup.okhttp3:okhttp:4.10.0")
    api ("com.squareup.retrofit2:converter-scalars:2.9.0")
    api ("com.squareup.retrofit2:retrofit:2.9.0")
    api ("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.7.1")
    api ("org.jetbrains.kotlinx:kotlinx-serialization-json:1.5.1")

    //Fyber
    api ("com.thinkup.sdk:adapter-tpn-fyber:6.4.85")
    api ("com.fyber:marketplace-sdk:8.3.5")
//    api ("com.google.android.gms:play-services-ads-identifier:18.0.1")

//Tramini
    api ("com.thinkup.sdk:tramini-plugin-tpn:6.4.85")
}