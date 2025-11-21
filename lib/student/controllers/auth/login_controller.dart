import 'dart:convert';
import 'dart:developer';
import 'package:education_app/main.dart';
import 'package:education_app/student/views/screens/nearby_school/nearby_school_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:education_app/student/views/widget/theme/theme.dart';

class StudentController extends GetxController {
  var isLoading = false.obs;
  var userId = RxnInt();
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;

  final String _baseUrl = "https://audio.aserp.in/public/api/students/register";
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer 8|EcTjMZtReXFmVvAo3QR0PlvRZynBU20ZHJ84U6RV13054422',
  };

  /// 🔹 Request all required permissions (Location, Microphone, Storage)
  Future<bool> requestAllPermissions() async {
    // 1️⃣ Location
    PermissionStatus locationStatus = await Permission.locationWhenInUse.request();
    if (!locationStatus.isGranted) {
      Get.snackbar(
        "Permission Required",
        "Location permission is required to continue.",
        backgroundColor: Colors.white,
        colorText: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    // 2️⃣ Microphone
    PermissionStatus micStatus = await Permission.microphone.request();
    if (!micStatus.isGranted) {
      Get.snackbar(
        "Permission Required",
        "Microphone permission is required to continue.",
        backgroundColor: Colors.white,
        colorText: Colors.redAccent,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    // 3️⃣ For Android 13+ audio access (if you plan to pick/share audio)
    if (GetPlatform.isAndroid && await Permission.audio.isDenied) {
      PermissionStatus audioStatus = await Permission.audio.request();
      if (!audioStatus.isGranted) {
        Get.snackbar(
          "Permission Required",
          "Audio access permission is required to continue.",
          backgroundColor: Colors.white,
          colorText: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    }
    // 4️⃣ Notification Permission (Android 13+)
    if (GetPlatform.isAndroid && await Permission.notification.isDenied) {
      PermissionStatus notificationStatus = await Permission.notification.request();
      if (!notificationStatus.isGranted) {
        Get.snackbar(
          "Permission Required",
          "Notification permission is required to play audio alerts.",
          backgroundColor: Colors.white,
          colorText: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    }



    return true;
  }

  /// 🔹 Get current location safely
  Future<bool> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar("Location Disabled", "Please enable location services.",
            backgroundColor: Colors.white, colorText: Colors.redAccent);
        await Geolocator.openLocationSettings();
        return false;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          Get.snackbar(
            "Permission Denied",
            "Location permission is required.",
            backgroundColor: Colors.white,
            colorText: Colors.redAccent,
          );
          return false;
        }
      }

      // Get.dialog(
      //   const Center(
      //     child: Column(
      //       mainAxisSize: MainAxisSize.min,
      //       children: [
      //         CircularProgressIndicator(color: AppTheme.primary),
      //         SizedBox(height: 10),
      //         Text("Fetching your location...",
      //             style: TextStyle(color: AppTheme.primaryDark)),
      //       ],
      //     ),
      //   ),
      //   barrierDismissible: false,
      // );

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      latitude.value = position.latitude;
      longitude.value = position.longitude;

      // Get.back(); // Close dialog
      return true;
    } catch (e) {
      // Get.back();
      Get.snackbar("Error", "Failed to get location: $e",
          backgroundColor: Colors.white, colorText: Colors.redAccent);
      return false;
    }
  }

  /// 🔹 Register student (after permission + location)
  Future<void> registerStudent({
    required String name,
    required String mobile,
    required int age,
  }) async {
    try {
      isLoading.value = true;

      // Step 1: Request permissions
      bool hasPermissions = await requestAllPermissions();
      if (!hasPermissions) {
        isLoading.value = false;
        return;
      }

      // Step 2: Get location
      bool gotLocation = await getCurrentLocation();
      if (!gotLocation) {
        isLoading.value = false;
        return;
      }

      // Step 3: Send data to server
      final body = json.encode({
        "name": name,
        "mobile_no": mobile,
        "age": age,
      });

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: _headers,
        body: body,
      );

      isLoading.value = false;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["status"] == "success") {
          int id = data["user_id"];
          userId.value = id;

          final prefs = await SharedPreferences.getInstance();
          await prefs.setInt("user_id", id);

          Get.snackbar(
            "Successful 🎉",
            "Login successfully!",
            backgroundColor: Colors.white,
            colorText: AppTheme.primaryDark,
            snackPosition: SnackPosition.BOTTOM,
          );
          log("message Lat${latitude.value } long${longitude.value}");
          // await registerFCMToken(); // ✅ abhi yahan call hoga

          Get.offAll(() => NearbySchoolsScreen(
            latitude: latitude.value,
            longitude: longitude.value,
          ));
        } else {
          Get.snackbar("Error", data["message"] ?? "Unexpected error",
              backgroundColor: Colors.white, colorText: Colors.redAccent);
        }
      } else {
        Get.snackbar("Server Error",
            "Failed with status: ${response.statusCode}",
            backgroundColor: Colors.white, colorText: Colors.redAccent);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Error", "Something went wrong: $e",
          backgroundColor: Colors.white, colorText: Colors.redAccent);
    }
  }

}
