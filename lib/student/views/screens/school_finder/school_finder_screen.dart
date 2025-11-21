import 'package:education_app/student/controllers/screen_controller/school_finder_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
// import '../controllers/school_finder_controller.dart';

class SchoolFinderScreen extends StatelessWidget {
  const SchoolFinderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SchoolFinderController());

    return Scaffold(
      appBar: AppBar(
        title: Text("Finder",
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 22)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.schools.isEmpty) {
          return const Center(child: Text("No schools found nearby."));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.schools.length,
          itemBuilder: (context, i) {
            final school = controller.schools[i];
            if (school == null) return const SizedBox.shrink(); // ✅ safety guard

            return Card(
              child: ListTile(
                leading: CircleAvatar(
                    child: Text(
                        (school['schoolName']?.isNotEmpty ?? false)
                            ? school['schoolName'][0].toUpperCase()
                            : '?')),
                title: Text(school['schoolName'] ?? 'Unknown School'),
                subtitle: Text(
                  "${school['address'] ?? 'No address'}\n"
                      "Distance: ${double.tryParse(school['distance']?.toString() ?? '0')?.toStringAsFixed(2)} km",
                ),
                trailing: ElevatedButton(
                  onPressed: () => controller.selectSchool(school),
                  child: Text("Select", style: GoogleFonts.poppins(color: Colors.white)),
                ),

              ),
            );
          },
        );
      }),
    );
  }
}
