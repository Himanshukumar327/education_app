import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Screen",style: GoogleFonts.poppins(color: Colors.white,fontSize: 22),),
        iconTheme: IconThemeData(color: Colors.white,),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              const SizedBox(height: 18),
              CircleAvatar(radius: 44, child: Text("SC")),
              const SizedBox(height: 12),
              Text("Student Name", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 6),
              Text("Class 10 - Science", style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 16),
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(12),
                  children: [
                    ListTile(leading: const Icon(Icons.settings), title: const Text("Settings")),
                    ListTile(leading: const Icon(Icons.logout), title: const Text("Logout"), onTap: () => Navigator.of(context).pop()),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
