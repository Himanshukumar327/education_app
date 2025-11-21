//package com.example.education_app
//
//import android.app.Notification
//import android.app.NotificationChannel
//import android.app.NotificationManager
//import android.app.Service
//import android.content.Intent
//import android.net.Uri
//import android.os.Build
//import android.os.IBinder
//import android.util.Log
//import androidx.core.app.NotificationCompat
//import androidx.media3.common.MediaItem
//import androidx.media3.exoplayer.ExoPlayer
//
//class AudioForegroundService : Service() {
//    private var player: ExoPlayer? = null
//    private val CHANNEL_ID = "audio_playback_channel"
//
//    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
//        val channelId = "audio_channel"
//        val channelName = "Audio Playback"
//
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            val chan = NotificationChannel(
//                channelId,
//                channelName,
//                NotificationManager.IMPORTANCE_LOW
//            )
//            val manager = getSystemService(NotificationManager::class.java)
//            manager.createNotificationChannel(chan)
//        }
//
//        val notification: Notification = NotificationCompat.Builder(this, channelId)
//            .setContentTitle("Audio Playing")
//            .setContentText("Your audio is playing")
//            .setSmallIcon(R.mipmap.ic_launcher)
//            .build()
//
//        // 🚨 Start foreground with mediaPlayback type
//        startForeground(1, notification, ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PLAYBACK)
//
//        // Play your audio here
//        return START_STICKY
//    }
//
//
//    private fun playAudio(url: String) {
//        try {
//            player = ExoPlayer.Builder(this).build().apply {
//                setMediaItem(MediaItem.fromUri(Uri.parse(url)))
//                prepare()
//                playWhenReady = true
//            }
//            Log.d("AudioService", "🎶 Audio playback started: $url")
//        } catch (e: Exception) {
//            Log.e("AudioService", "❌ Error playing audio: ${e.message}")
//        }
//    }
//
//    private fun createNotification(contentText: String): Notification {
//        val manager = getSystemService(NotificationManager::class.java)
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            val channel = NotificationChannel(
//                CHANNEL_ID, "Audio Playback", NotificationManager.IMPORTANCE_LOW
//            )
//            manager.createNotificationChannel(channel)
//        }
//        return NotificationCompat.Builder(this, CHANNEL_ID)
//            .setContentTitle("Education App")
//            .setContentText(contentText)
//            .setSmallIcon(R.mipmap.ic_launcher)
//            .setOngoing(true)
//            .build()
//    }
//
//    override fun onDestroy() {
//        player?.release()
//        player = null
//        super.onDestroy()
//    }
//
//    override fun onBind(intent: Intent?): IBinder? = null
//}
