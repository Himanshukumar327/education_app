import 'package:education_app/student/views/widget/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
// import '../theme/app_theme.dart';

class StudentAuthScreen extends StatelessWidget {
  const StudentAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF002F4B), Color(0xFF007E7F)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // subtle pattern circle
          Positioned(
            left: -size.width * 0.25,
            top: -size.width * 0.2,
            child: Container(
              width: size.width * 0.7,
              height: size.width * 0.7,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo placeholder
                    Hero(
                      tag: 'appLogo',
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: Text(
                          "AC", // Subhash Chandra initials
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.primary),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      "Welcome to Achyuta Academy",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Choose your role to continue",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 30),

                    // Admin (optional)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // For now go to home too (or remove)
                          Get.toNamed('/home');
                        },
                        child: Text("Login as Admin",style: GoogleFonts.poppins(color: Colors.white),),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Student (this must go to student home)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.toNamed('/loginScreen');
                        },
                        child: Text("Login as Student",style: GoogleFonts.poppins(color: Colors.white),),
                      ),
                    ),

                    const SizedBox(height: 14),
                    // Teacher login (we keep route same placeholder)
                    // SizedBox(
                    //   width: double.infinity,
                    //   child: ElevatedButton(
                    //     onPressed: () {
                    //       // Could be teacher-specific home in future
                    //       Get.toNamed('/home');
                    //     },
                    //     child: Text("Login as Teacher",style: GoogleFonts.poppins(color: Colors.white),),
                    //   ),
                    // ),

                    const SizedBox(height: 22),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
