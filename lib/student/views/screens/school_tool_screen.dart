// import 'package:flutter/material.dart';
//
// class SchoolToolScreen extends StatelessWidget {
//   const SchoolToolScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(18.0),
//           child: Column(
//             children: [
//               const SizedBox(height: 18),
//               Text("School Tool", style: Theme.of(context).textTheme.titleLarge),
//               const SizedBox(height: 12),
//               Text("Tools and utilities for students (placeholder).", style: Theme.of(context).textTheme.bodyMedium),
//               const SizedBox(height: 18),
//               Expanded(
//                 child: GridView.count(
//                   crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
//                   childAspectRatio: 1.1,
//                   crossAxisSpacing: 12,
//                   mainAxisSpacing: 12,
//                   children: List.generate(8, (i) {
//                     return Card(
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                       child: Center(child: Text("Tool ${i+1}")),
//                     );
//                   }),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
