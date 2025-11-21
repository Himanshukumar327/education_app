//package com.example.education_app
//
//import android.app.NotificationChannel
//import android.app.NotificationManager
//import android.app.PendingIntent
//import android.content.Context
//import android.content.Intent
//import android.os.Build
//import android.util.Log
//import androidx.core.app.NotificationCompat
//import com.google.firebase.messaging.FirebaseMessagingService
//import com.google.firebase.messaging.RemoteMessage
//
//class MyFirebaseMessagingService : FirebaseMessagingService() {
//
//    override fun onNewToken(token: String) {
//        super.onNewToken(token)
//        Log.d("FCM", "🆕 Token refreshed: $token")
//        // Send to server if required
//    }
//
//    override fun onMessageReceived(remoteMessage: RemoteMessage) {
//        super.onMessageReceived(remoteMessage)
//        Log.d("FCM", "📩 Message received: ${remoteMessage.data}")
//
//        val title = remoteMessage.notification?.title ?: "🎧 School Audio"
//        val body = remoteMessage.notification?.body ?: "Tap to listen to the audio"
//        val audioUrl = remoteMessage.data["audio_url"] ?: remoteMessage.data["audio_path"]
//
//        showNotification(title, body)
//
//        if (!audioUrl.isNullOrEmpty()) {
//            playAudioInBackground(audioUrl)
//        }
//    }
//
//    private fun playAudioInBackground(audioUrl: String) {
//        try {
//            val intent = Intent(this, AudioForegroundService::class.java)
//            intent.putExtra("AUDIO_URL", audioUrl)
//            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) startForegroundService(intent)
//            else startService(intent)
//        } catch (e: Exception) {
//            Log.e("AudioService", "❌ Error starting foreground service: ${e.message}")
//        }
//    }
//
//    private fun showNotification(title: String, body: String) {
//        val channelId = "audio_channel"
//        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
//
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            val channel = NotificationChannel(channelId, "Audio Notifications", NotificationManager.IMPORTANCE_HIGH)
//            notificationManager.createNotificationChannel(channel)
//        }
//
//        val intent = Intent(this, MainActivity::class.java)
//        val pendingIntent = PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_ONE_SHOT or PendingIntent.FLAG_IMMUTABLE)
//
//        val notification = NotificationCompat.Builder(this, channelId)
//            .setContentTitle(title)
//            .setContentText(body)
//            .setSmallIcon(R.mipmap.ic_launcher)
//            .setContentIntent(pendingIntent)
//            .setAutoCancel(true)
//            .build()
//
//        notificationManager.notify(1, notification)
//    }
//}
