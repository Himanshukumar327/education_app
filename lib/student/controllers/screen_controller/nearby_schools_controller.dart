import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NearbySchoolsController extends GetxController {
  var isLoading = false.obs;
  var schools = [].obs;
  var filteredSchools = [].obs;
  var selectedSchoolId = RxnInt();
  var userId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserId();
  }

  Future<void> loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId.value = prefs.getInt("user_id") ?? 0;
    log("Loaded user_id: ${userId.value}");
  }

  Future<void> fetchNearbySchools(double lat, double lon) async {
    try {
      isLoading.value = true;

      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      var request = http.Request(
        'POST',
        Uri.parse('https://audio.aserp.in/api/nearby-schools'),
      );
      request.body = json.encode({
        "latitude": lat,
        "longitude": lon,
      });
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final result = json.decode(await response.stream.bytesToString());
        log("messages ${result['data']}");

        if (result["status"] == true) {
          log("messagssse $result['data]");
          // log(" SCHHOL ${selectedSchoolId.value}");
          // SharedPreferences prefs = await SharedPreferences.getInstance();
          // if (selectedSchoolId.value != null) {
          //   await prefs.setInt("school_id", selectedSchoolId.value!);
          // }
          log("message $result['data]");
          schools.value = result["data"];
          filteredSchools.value = result["data"];
        }
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void filterSchools(String query) {
    if (query.isEmpty) {
      filteredSchools.value = schools;
    } else {
      filteredSchools.value = schools
          .where((school) =>
      (school["school_name"] ?? "")
          .toLowerCase()
          .contains(query.toLowerCase()) ||
          (school["address"] ?? "")
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    }
  }

  void selectSchool(int? id) {
    if (selectedSchoolId.value == id) {
      selectedSchoolId.value = null; // unselect if tapped again
    } else {
      selectedSchoolId.value = id;
    }
  }

  Future<bool> submitSelectedSchool() async {
    if (selectedSchoolId.value == null || userId.value == 0) {
      log("Cannot submit: selectedSchoolId=${selectedSchoolId.value}, userId=${userId.value}");
      return false;
    }

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    var request = http.Request(
      'POST',
      Uri.parse('https://audio.aserp.in/api/students/school_location_select'),
    );

    request.body = json.encode({
      "user_id": userId.value,
      "school_id": selectedSchoolId.value,
    });

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    final respBody = await response.stream.bytesToString();
    log("API response: $respBody");

    if (response.statusCode == 200) {
      final result = json.decode(respBody);
      log("Parsed result: $result");
      if (result["status"] == true) {
        registerFCMToken();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt("school_id", selectedSchoolId.value!);
        log("✅ Saved school_id: ${selectedSchoolId.value}");

        return true;
      } else {
        log("API returned false status: ${result['message']}");
      }
    } else {
      log("Status code: ${response.statusCode}, reason: ${response.reasonPhrase}");
    }

    return false;
  }

  Future<void> registerFCMToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.get('user_id')?.toString() ?? '';
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        print("📱 FCM Token: $token");
        final uri = Uri.parse('https://audio.aserp.in/api/userfcmtoken');
        final request = http.MultipartRequest('POST', uri);
        request.fields.addAll({
          'user_id': userId,
          'school_id': selectedSchoolId.value.toString(),
          'token': token,
        });
        await request.send();
      }
    } catch (e) {
      print("❗ Token registration failed: $e");
    }
  }

}
