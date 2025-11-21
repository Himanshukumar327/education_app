// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:just_audio/just_audio.dart';
//
// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   static Future<void> initialize() async {
//     const AndroidInitializationSettings androidSettings =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const InitializationSettings initSettings =
//     InitializationSettings(android: androidSettings);
//
//     await _notificationsPlugin.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: (details) async {
//         if (details.payload != null && details.payload!.isNotEmpty) {
//           final player = AudioPlayer();
//           await player.setUrl(details.payload!);
//           await player.play();
//         }
//       },
//     );
//   }
//
//   static Future<void> showNotification({
//     required String title,
//     required String body,
//     String? payload,
//   }) async {
//     const AndroidNotificationDetails androidDetails =
//     AndroidNotificationDetails(
//       'audio_channel_id',
//       'Audio Notifications',
//       channelDescription: 'Channel for school audio announcements',
//       importance: Importance.max,
//       priority: Priority.high,
//       playSound: true,
//       enableVibration: true,
//       ongoing: true,
//     );
//
//     const NotificationDetails notificationDetails =
//     NotificationDetails(android: androidDetails);
//
//     await _notificationsPlugin.show(
//       0,
//       title,
//       body,
//       notificationDetails,
//       payload: payload,
//     );
//   }
// }
//
// class AudioAutoPlayer {
//   static const String PREF_LAST_URL = 'last_audio_url';
//   static const String PREF_LAST_SCHEDULE = 'last_audio_scheduled';
// }
