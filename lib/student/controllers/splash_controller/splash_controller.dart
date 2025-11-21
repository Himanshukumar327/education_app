import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SplashController extends GetxController {
  RxBool isLoading = true.obs;
  int? userId;

  @override
  void onInit() {
    super.onInit();
    initSplash();
  }

  Future<void> initSplash() async {
    await _loadUserId();
    await _fetchSplashData();
  }

  /// Load stored user_id from SharedPreferences
  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id');
    print('📦 Loaded user_id: $userId');
  }

  /// Call the splash API and handle navigation
  Future<void> _fetchSplashData() async {
    try {
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      };

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://audio.aserp.in/api/splash'),
      );
      request.fields.addAll({'user_id': (userId ?? 0).toString()});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var jsonData = jsonDecode(responseBody);
        print('✅ Splash API Response: $jsonData');
      } else {
        print('⚠️ Error: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('❌ Exception during splash: $e');
    } finally {
      // Keep splash visible for at least 2 seconds
      await Future.delayed(const Duration(seconds: 2));
      isLoading.value = false;

      // Navigate based on login state
      if (userId != null && userId != '0') {
        Get.offAllNamed('/home');
      } else {
        Get.offAllNamed('/'); // or '/login' depending on your route setup
      }
    }
  }
}
