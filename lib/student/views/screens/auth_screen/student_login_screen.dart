import 'package:education_app/student/controllers/auth/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:education_app/student/views/widget/theme/theme.dart';

class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({super.key});

  @override
  State<StudentLoginScreen> createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final StudentController studentController = Get.put(StudentController());
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  bool isLoading = false;

  void _onLogin() async {
    if (_formKey.currentState!.validate()) {
      await studentController.registerStudent(
        name: _nameController.text.trim(),
        mobile: _mobileController.text.trim(),
        age: int.parse(_ageController.text.trim()),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: SafeArea(
        child: Stack(
          children: [
            // Top gradient background
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primary, AppTheme.accent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),

            // White container with rounded top
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                decoration: BoxDecoration(
                  color: AppTheme.bg, // <- changed from white
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, -2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title section
                        Center(
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.school_rounded,
                                  color: AppTheme.primary,
                                  size: 60,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "Welcome Back!",
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primaryDark,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Login to continue your learning journey",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),

                        // Full Name
                        Text("Full Name", style: AppTheme.textTheme.bodyLarge),
                        const SizedBox(height: 6),
                        _buildInputField(
                          controller: _nameController,
                          hint: "Enter your full name",
                          icon: Icons.person_outline,
                          validator: (value) =>
                          value!.isEmpty ? "Please enter your name" : null,
                        ),
                        const SizedBox(height: 18),

                        // Mobile Number
                        Text("Mobile Number", style: AppTheme.textTheme.bodyLarge),
                        const SizedBox(height: 6),
                        _buildInputField(
                          controller: _mobileController,
                          hint: "Enter your mobile number",
                          icon: Icons.phone_android_outlined,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter mobile number";
                            } else if (value.length != 10) {
                              return "Enter a valid 10-digit number";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),

                        // Age
                        Text("Age", style: AppTheme.textTheme.bodyLarge),
                        const SizedBox(height: 6),
                        _buildInputField(
                          controller: _ageController,
                          hint: "Enter your age",
                          icon: Icons.calendar_month_outlined,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your age";
                            } else if (int.tryParse(value)! < 5 ||
                                int.tryParse(value)! > 100) {
                              return "Enter a valid age";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 28),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : _onLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              padding:
                              const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Obx(() => studentController.isLoading.value
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.login, color: Colors.white),
                                const SizedBox(width: 8),
                                Text(
                                  "Login",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )),

                          ),
                        ),

                        const SizedBox(height: 20),

                        // Footer
                        Center(
                          child: Text(
                            "By continuing, you agree to our Terms & Privacy Policy",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                fontSize: 12, color: Colors.black54),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    FormFieldValidator<String>? validator,
    TextInputType? keyboardType,
    int? maxLength,
  }) {
    return Container(
      padding: EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.white, // distinct background for fields
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        validator: validator,
        decoration: InputDecoration(
          counterText: "",
          hintText: hint,
          prefixIcon: Icon(icon, color: AppTheme.primary),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppTheme.primary, width: 1.2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
