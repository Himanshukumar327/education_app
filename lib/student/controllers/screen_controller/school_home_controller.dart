import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StudentHomeController extends GetxController {
  var isLoading = false.obs;
  var schoolData = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSelectedSchool();
  }

  Future<void> fetchSelectedSchool() async {
    try {
      isLoading.value = true;

      // ✅ Get user id from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt("user_id");

      if (userId == null) {
        Get.snackbar("Error", "User not logged in (ID missing)");
        isLoading.value = false;
        return;
      }

      // ✅ Make API call
      final url = Uri.parse(
          "https://audio.aserp.in/api/students/get_user_selected_school/$userId");
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse["status"] == true && jsonResponse["data"] != null) {
          schoolData.value = jsonResponse["data"];
        } else {
          Get.snackbar("Error", "No school found for this user");
        }
      } else {
        Get.snackbar("Error", "Failed to fetch school (${response.statusCode})");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
