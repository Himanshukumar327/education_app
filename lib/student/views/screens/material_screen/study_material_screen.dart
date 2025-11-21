import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StudyMaterialScreen extends StatelessWidget {
  const StudyMaterialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Material Screen",style: GoogleFonts.poppins(color: Colors.white,fontSize: 22),),
        iconTheme: IconThemeData(color: Colors.white,),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Text("Study Material", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text("Notes, PDFs and practice papers (placeholder).", style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemBuilder: (context, idx) {
                    return ListTile(
                      leading: const Icon(Icons.picture_as_pdf),
                      title: Text("Chapter ${idx + 1} - Notes"),
                      subtitle: Text("Size: ${3 + idx} MB"),
                      trailing: ElevatedButton(onPressed: () {}, child: Text("Download",style: GoogleFonts.poppins(color: Colors.white),)),
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(color: Colors.white,),
                  itemCount: 10,
                ),
              ),
            ],
             //login as admin and login as a user
            // hide school tool
            // name of the selected school click the school then show schedule class
            //
          ),
        ),
      ),
    );
  }
}
