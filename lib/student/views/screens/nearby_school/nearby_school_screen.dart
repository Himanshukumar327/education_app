import 'dart:developer';

import 'package:education_app/student/views/screens/main_screen/student_main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// import '../controllers/nearby_schools_controller.dart';
import '../../../controllers/screen_controller/nearby_schools_controller.dart';
import '../../widget/theme/theme.dart';

class NearbySchoolsScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  NearbySchoolsScreen({super.key, required this.latitude, required this.longitude});

  @override
  State<NearbySchoolsScreen> createState() => _NearbySchoolsScreenState();
}

class _NearbySchoolsScreenState extends State<NearbySchoolsScreen> {
  final NearbySchoolsController controller = Get.put(NearbySchoolsController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.loadUserId();
  }

  @override
  Widget build(BuildContext context) {
    controller.fetchNearbySchools(widget.latitude, widget.longitude);

    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: Text("Nearby Schools", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                onChanged: controller.filterSchools,
                decoration: InputDecoration(
                  hintText: "Search school by name or address",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: controller.filteredSchools.length,
                itemBuilder: (context, index) {
                  var school = controller.filteredSchools[index];
                  bool isSelected = controller.selectedSchoolId.value == school['school_id'];

                  return GestureDetector(
                    onTap: () => controller.selectSchool(school['school_id']),
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected ? AppTheme.primary : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppTheme.accent.withOpacity(0.2),
                          backgroundImage: school['profilePhoto'] != null
                              ? NetworkImage("https://audio.aserp.in/public/${school['profilePhoto']}")
                              : null,
                          child: school['profilePhoto'] == null
                              ? const Icon(Icons.school, color: AppTheme.primary)
                              : null,
                        ),
                        title: Text(school["schoolName"] ?? "Unknown",
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                        subtitle: Text(
                          "${school["address"] ?? ""}\nCity: ${school["city"] ?? 'N/A'} | State: ${school["state"] ?? 'N/A'}",
                          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                        ),
                        isThreeLine: true,
                      ),
                    ),
                  );
                },
              ),
            ),

            Obx(() => controller.selectedSchoolId.value != null
                ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    bool success = await controller.submitSelectedSchool();
                    if (success) {
                      Get.snackbar("Success", "School selected successfully");
                      // Navigate to next screen
                      Get.offAll(() => StudentMainScreen());
                    } else {
                      log("error failed to select school");
                      Get.snackbar("Error", "Failed to select school");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    "Next",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
            ) : const SizedBox.shrink()),
          ],
        );
      }),
    );
  }
}
