import 'package:education_app/student/views/screens/main_screen/student_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:education_app/student/views/screens/lecture_screen/lecture_screen.dart';
import 'package:education_app/student/views/screens/profile_screen.dart';
import 'package:education_app/student/views/screens/school_finder/school_finder_screen.dart';
import 'package:education_app/student/views/screens/material_screen/study_material_screen.dart';
import 'package:education_app/student/views/widget/theme/theme.dart';

// same UI style as your first "StudentHomeScreen"
class StudentMainScreen extends StatelessWidget {
  StudentMainScreen({super.key});

  // define your cards here
  final List<_HomeCard> _cards = [
    _HomeCard(Icons.home_outlined, AppTheme.primary, 'Main', StudentHomeScreen()),
    _HomeCard(Icons.search_outlined, Colors.orange, 'Finder', const SchoolFinderScreen()),
    _HomeCard(Icons.video_library_outlined, Colors.green, 'Lecture', const LectureScreen()),
    _HomeCard(Icons.menu_book_outlined, Colors.purple, 'Material', const StudyMaterialScreen()),
    _HomeCard(Icons.person_outline, Colors.blue, 'Profile', const ProfileScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Student Dashboard",
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: AppTheme.primary,
        elevation: 0,
      ),
      backgroundColor: AppTheme.bg,
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/images/app_background_image.jpg',
          //     fit: BoxFit.cover,
          //   ),
          // ),
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Column(
                children: [
                  // header banner or image carousel (optional)
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/img.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // grid of cards
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: _cards.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 15,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      final card = _cards[index];
                      return GestureDetector(
                        onTap: () => Get.to(() => card.screen),
                        child: _CustomCardWidget(
                          icon: card.icon,
                          iconsColor: card.color,
                          textColor: card.color,
                          title: card.title,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeCard {
  final IconData icon;
  final Color color;
  final String title;
  final Widget screen;

  _HomeCard(this.icon, this.color, this.title, this.screen);
}

class _CustomCardWidget extends StatelessWidget {
  final IconData icon;
  final Color iconsColor;
  final Color textColor;
  final String title;

  const _CustomCardWidget({
    required this.icon,
    required this.iconsColor,
    required this.textColor,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardSize = screenWidth * 0.25;

    return Container(
      height: cardSize,
      width: cardSize,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            spreadRadius: 1,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: cardSize * 0.4, color: iconsColor),
          SizedBox(height: cardSize * 0.05),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: cardSize * 0.15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// dummy HomeTab widget from your previous screen
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text("Main HomeTab Screen"),
      ),
    );
  }
}
