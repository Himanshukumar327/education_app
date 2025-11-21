import 'dart:convert';
import 'dart:developer';
import 'package:education_app/student/controllers/screen_controller/school_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SchoolFinderController extends GetxController {
  var isLoading = false.obs;
  final RxList<Map<String, dynamic>> schools = <Map<String, dynamic>>[].obs;
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    getLocationAndFetchSchools();
  }


  Future<void> getLocationAndFetchSchools() async {
    try {
      isLoading.value = true;

      // ✅ Request permission
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        Get.snackbar("Error", "Location permission denied");
        isLoading.value = false;
        return;
      }

      // ✅ Get current position
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);

      latitude.value = position.latitude;
      longitude.value = position.longitude;

      // ✅ Fetch nearby schools
      await fetchNearbySchools();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchNearbySchools() async {
    final url = Uri.parse('https://audio.aserp.in/api/nearby-schools');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    final body = jsonEncode({
      "latitude": latitude.value,
      "longitude": longitude.value
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == true && jsonResponse['data'] != null) {
        // ✅ safely cast data
        final List data = jsonResponse['data'];
        log("message $data");
        schools.value =
            data.map((e) => e as Map<String, dynamic>).toList(); // ✅
      } else {
        schools.clear();

        Get.snackbar("Error", jsonResponse['message'] ?? "Unknown error");
      }
    } else {
      schools.clear();
      Get.snackbar("Error", "Failed to fetch schools");
    }
  }


  // ✅ New method: Select school
  Future<void> selectSchool(Map<String, dynamic> school) async {
    bool confirmed = await Get.defaultDialog<bool>(
      title: "Confirm",
      middleText: "Do you want to select this school?",
      textConfirm: "Yes",
      textCancel: "No",
      onConfirm: () => Get.back(result: true),
      onCancel: () => Get.back(result: false),
    ) ?? false;

    if (!confirmed) return;

    // ✅ Show loading dialog
    Get.dialog(
      Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt("user_id") ?? 0;

      // ✅ Remove old school_id before saving new one
      await prefs.remove("school_id");

      var headers = {'Content-Type': 'application/json', 'Accept': 'application/json'};
      var request = http.Request(
        'POST',
        Uri.parse('https://audio.aserp.in/api/students/school_location_update'),
      );
      request.body = json.encode({"user_id": userId, "school_id": school['school_id']});
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      var resStr = await response.stream.bytesToString();
      var res = jsonDecode(resStr);

      Get.back(); // ✅ close loading dialog

      if (response.statusCode == 200 && res['status'] == true) {
        // ✅ Save newly selected school_id
        await prefs.setInt("school_id", school['school_id']);
        Get.snackbar("Success", res['message'], snackPosition: SnackPosition.BOTTOM);

        if (Get.isRegistered<StudentHomeController>()) {
          Get.find<StudentHomeController>().fetchSelectedSchool();
        }
      } else {
        log("Error ${res['message'] }");
        Get.snackbar("Error", res['message'] ?? "Update failed");
      }
    } catch (e) {
      Get.back();
      log("Error ${e.toString()}");
      Get.snackbar("Error", e.toString());
    }
  }
}
