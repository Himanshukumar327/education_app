import 'package:education_app/student/views/widget/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LectureScreen extends StatelessWidget {
  const LectureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Lecture",style: GoogleFonts.poppins(color: Colors.white,fontSize: 22),),
        backgroundColor: AppTheme.primary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Text("Lectures", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text("Choose from available recorded or live lectures (placeholder).", style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: 8,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, idx) {
                    return ListTile(
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      leading: Container(width: 72, height: 56, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8))),
                      title: Text("Lecture ${idx + 1} - Topic ${idx + 1}"),
                      subtitle: Text("Duration: ${20 + idx} min"),
                      trailing: IconButton(onPressed: () {}, icon: const Icon(Icons.play_circle_fill)),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
