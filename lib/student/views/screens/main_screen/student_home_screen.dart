import 'package:education_app/student/controllers/screen_controller/school_home_controller.dart';
import 'package:education_app/student/views/screens/lecture_screen/lecture_screen.dart';
import 'package:education_app/student/views/widget/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/notification_service/notification_service.dart';

class StudentHomeScreen extends StatelessWidget {
   StudentHomeScreen({super.key});
  final controller = Get.put(StudentHomeController());

  @override
  Widget build(BuildContext context) {
    // Responsive paddings
    final w = MediaQuery.of(context).size.width;
    final horizontalPadding = w > 600 ? 28.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        title: Text("Home",style: GoogleFonts.poppins(color: Colors.white,fontSize: 22),),
        iconTheme: IconThemeData(color: Colors.white,),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top selected school card
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = controller.schoolData;
                if (data.isEmpty) {
                  return Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: AppTheme.primary.withOpacity(0.12),
                            child: Text("NA",
                                style: TextStyle(
                                    color: AppTheme.primary, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text("No school selected",
                                style: Theme.of(context).textTheme.titleLarge),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return GestureDetector(
                  onTap: () {
                    Get.snackbar("Selected School",
                        "School: ${data['school_name']}\nStudent: ${data['student_name']}",
                        snackPosition: SnackPosition.BOTTOM);
                  },
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: AppTheme.primary.withOpacity(0.12),
                            child: Text(
                              data['school_name'] != null
                                  ? data['school_name'][0].toUpperCase()
                                  : '?',
                              style: TextStyle(
                                  color: AppTheme.primary, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data['school_name'] ?? "Unknown School",
                                    style: Theme.of(context).textTheme.titleLarge),
                                const SizedBox(height: 6),
                                Text(data['school_address'] ?? "",
                                    style: Theme.of(context).textTheme.bodyMedium),
                                const SizedBox(height: 6),
                                Text("Student: ${data['student_name'] ?? ''}",
                                    style: Theme.of(context).textTheme.bodyMedium),
                              ],
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey[600]),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              // ElevatedButton(
              //   onPressed: () => AudioNotificationService.fetchAndPlay(),
              //   child: Text("Test Audio"),
              // )

              const SizedBox(height: 18),

              // Options grid (Search, Select/Change, Choose lecture, School tool, Study material)
              // We'll create a responsive grid of tiles
              LayoutBuilder(builder: (context, constraints) {
                final width = constraints.maxWidth;
                final crossAxisCount = width > 700 ? 3 : (width > 450 ? 2 : 1);

                final tiles = [
                  _ActionTile(
                    index: 1,
                    title: 'Search nearby School',
                    icon: Icons.search,
                    onTap: () => Get.toNamed('/finder'),
                  ),
                  _ActionTile(
                    index: 2,
                    title: 'Select / Change School',
                    icon: Icons.location_city_outlined,
                    onTap: () => Get.snackbar("Select School", "Select or change school (placeholder)"),
                  ),
                  _ActionTile(
                    index: 3,
                    title: 'Choose Lecture',
                    icon: Icons.play_circle_outline,
                    onTap: () => Get.to(() => LectureScreen()),
                    // onTap: () => Get.toNamed('/lecture'),
                  ),
                  // _ActionTile(
                  //   index: 4,
                  //   title: 'School Tool',
                  //   icon: Icons.build,
                  //   onTap: () => Get.toNamed('/tool'),
                  // ),
                  _ActionTile(
                    index: 5,
                    title: 'Study Material',
                    icon: Icons.menu_book,
                    onTap: () => Get.toNamed('/material'),
                  ),
                ];

                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 3.8,
                  children: tiles,
                );
              }),

              const SizedBox(height: 18),

              // Option to enable/disable autoplay for lecture (as in your sketch)
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Expanded(child: Text("Enable Auto-play for each lecture", style: Theme.of(context).textTheme.bodyLarge)),
                      // simple toggle
                      StatefulBuilder(builder: (context, setState) {
                        bool autoplay = false;
                        return StatefulBuilder(
                          builder: (context, setLocal) {
                            return Switch(
                              value: autoplay,
                              onChanged: (v) {
                                setLocal(() {
                                  autoplay = v;
                                  Get.snackbar("Auto-play", autoplay ? "Enabled" : "Disabled", snackPosition: SnackPosition.BOTTOM);
                                });
                              },
                              activeColor: AppTheme.primary,
                            );
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // Some extra filler - recent lectures / materials (placeholder)
              Text("Recent Lectures", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, idx) {
                    return Container(
                      width: 250,
                      margin: const EdgeInsets.only(right: 12),
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top texts
                              Text(
                                "Lecture ${idx + 1}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontSize: 16),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Topic: Important concept ${idx + 1}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: Colors.black54),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer(), // pushes button to bottom

                              // Single full-width button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    // Action when pressed
                                    Get.snackbar("Lecture", "Starting Lecture ${idx + 1}",
                                        snackPosition: SnackPosition.BOTTOM);
                                  },
                                  icon: const Icon(Icons.play_circle_fill),
                                  label: Text(
                                    "Start Lecture",
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600, color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    backgroundColor: AppTheme.primary, // custom primary color
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );

                  },
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final int index;
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  const _ActionTile({required this.index, required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: AppTheme.primary.withOpacity(0.12),
                child: Icon(icon, color: AppTheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15,),
                    Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
                    const SizedBox(height: 6),
                    Text("Tap to open", style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              Text("$index", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18, color: Colors.black45)),
            ],
          ),
        ),
      ),
    );
  }
}