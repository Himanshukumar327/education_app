import 'dart:developer';
import 'package:education_app/student/views/screens/splash_screen/splash_screen.dart';
import 'package:education_app/views/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// Screens
import 'student/views/screens/auth_screen/student_login_screen.dart';
import 'student/views/screens/main_screen/student_main_screen.dart';
import 'student/views/screens/profile_screen.dart';
import 'student/views/screens/school_finder/school_finder_screen.dart';
import 'student/views/screens/lecture_screen/lecture_screen.dart';
import 'student/views/screens/material_screen/study_material_screen.dart';
import 'student/views/widget/theme/theme.dart';

/// 🔹 Background Message Handler (Play Immediately)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  final data = message.data;
  final title = message.notification?.title ?? data['title'] ?? '🎵 School Audio';
  final body = message.notification?.body ?? data['body'] ?? 'Tap to play latest audio';
  final audioUrl = data['audio_url'];

  if (audioUrl != null && audioUrl.isNotEmpty) {
    // Show notification
    await NotificationService.showNotification(
      title: title,
      body: body,
      payload: audioUrl,
    );

    // Play audio immediately
    final player = AudioPlayer();
    await player.setUrl(audioUrl);
    await player.play();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // ✅ Request notification permission
  final messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(alert: true, badge: true, sound: true);

  // ✅ Initialize local notifications
  await NotificationService.initialize();

  // ✅ Register background handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // ✅ Send FCM token when app starts
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('user_id');
  final schoolId = prefs.getInt('school_id');
  final token = await FirebaseMessaging.instance.getToken();
  if (token != null && userId != null && schoolId != null) {
    log("🚀 Initial FCM Token: $token");
    await sendTokenToServer(userId.toString(), schoolId.toString(), token);
  }

  // ✅ Listen for token refresh
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    log("🔁 Token refreshed: $newToken");
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    final schoolId = prefs.getInt('school_id');
    if (userId != null && schoolId != null) {
      await sendTokenToServer(userId.toString(), schoolId.toString(), newToken);
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Education App',
      theme: AppTheme.lightTheme,
      home: HomeScreen(),
      // initialRoute: '/splash',
      // getPages: [
      //   GetPage(name: '/splash', page: () => const SplashScreen()),
      //   GetPage(name: '/', page: () => const StudentLoginScreen()),
      //   GetPage(name: '/home', page: () => StudentMainScreen()),
      //   GetPage(name: '/finder', page: () => const SchoolFinderScreen()),
      //   GetPage(name: '/lecture', page: () => const LectureScreen()),
      //   GetPage(name: '/material', page: () => const StudyMaterialScreen()),
      //   GetPage(name: '/profile', page: () => const ProfileScreen()),
      // ],
    );
  }
}

/// 🔔 Notification Service (Instant Audio)
class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();
  // static final FlutterLocalNotificationsPlugin _plugin =
  // FlutterLocalNotificationsPlugin();
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> initialize() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) async {
        final payload = details.payload;
        if (payload != null && payload.isNotEmpty) {
          final player = AudioPlayer();
          await player.setUrl(payload);
          await player.play();
        }
      },
    );

    // ✅ Create notification channel
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.createNotificationChannel(const AndroidNotificationChannel(
      'audio_channel',
      'Audio Notifications',
      description: 'Used for school audio alerts',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    ));

    // ✅ Foreground message handling (Instant play)
    // Inside initialize()
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final data = message.data;
      final audioUrl = data['audio_url'];
      final title = data['title'] ?? '🎵 School Audio';
      final body = data['body'] ?? 'Tap to play latest audio';

      if (audioUrl != null && audioUrl.isNotEmpty) {
        await showNotification(title: title, body: body, payload: audioUrl);
        await _player.setUrl(audioUrl);
        await _player.play();
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      final audioUrl = message.data['audio_url'];
      if (audioUrl != null && audioUrl.isNotEmpty) {
        await _player.setUrl(audioUrl);
        await _player.play();
      }
    });
  }

  /// 🔸 Show notification immediately
  static Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'audio_channel',
      'Audio Notifications',
      channelDescription: 'Used for school audio alerts',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );
    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload,
    );
  }
}

/// ✅ Upload Token Function
Future<void> sendTokenToServer(
    String userId, String schoolId, String token) async {
  try {
    final url = Uri.parse('https://audio.aserp.in/api/userfcmtoken');
    final res = await http.post(url, body: {
      'user_id': userId,
      'school_id': schoolId,
      'token': token,
    });

    if (res.statusCode == 200) {
      log("✅ Token uploaded successfully: ${res.body}");
    } else {
      log("⚠️ Token upload failed (${res.statusCode}): ${res.body}");
    }
  } catch (e) {
    log("❌ Token upload error: $e");
  }
}
