//package com.example.education_app
//
//import android.content.Intent
//import android.os.Build
//import android.os.Bundle
//import android.util.Log
//import io.flutter.embedding.android.FlutterActivity
//import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.plugin.common.MethodChannel
//
//class MainActivity : FlutterActivity() {
//
//    private val CHANNEL = "com.example.education_app/audio"
//
//    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        super.configureFlutterEngine(flutterEngine)
//
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
//            .setMethodCallHandler { call, result ->
//                when (call.method) {
//                    "playAudio" -> {
//                        val url = call.argument<String>("url")
//                        if (!url.isNullOrEmpty()) {
//                            playAudioFromFlutter(url)
//                            result.success("Audio started from native side")
//                        } else {
//                            result.error("INVALID_URL", "URL is null or empty", null)
//                        }
//                    }
//                    else -> result.notImplemented()
//                }
//            }
//    }
//
//    private fun playAudioFromFlutter(url: String) {
//        Log.d("MainActivity", "🎵 Starting foreground service with URL: $url")
//        val intent = Intent(this, AudioForegroundService::class.java)
//        intent.putExtra("AUDIO_URL", url)
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            startForegroundService(intent)
//        } else {
//            startService(intent)
//        }
//    }
//
//    override fun onCreate(savedInstanceState: Bundle?) {
//        super.onCreate(savedInstanceState)
//        Log.d("MainActivity", "✅ MainActivity loaded successfully")
//    }
//}



package com.example.education_app


import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    // Nothing else needed
}
