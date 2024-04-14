// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:rsnaturopaty/screen/Setting/profile/editProfile/getFoto.dart';

// class EditFotoProfile extends StatefulWidget {
//   const EditFotoProfile({super.key});

//   @override
//   State<EditFotoProfile> createState() => _EditFotoProfileState();
// }

// class _EditFotoProfileState extends State<EditFotoProfile> {
//   Uint8List? _imageFile;

//   void selectdImage() async {
//     Uint8List img = await pickImage(ImageSource.gallery);
//     setState(() {
//       _imageFile = img;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Test"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Stack(
//               children: [
//                 _imageFile != null
//                     ? CircleAvatar(
//                         radius: 64,
//                         backgroundImage: MemoryImage(_imageFile!),
//                       )
//                     : const CircleAvatar(
//                         radius: 64,
//                         backgroundImage: NetworkImage("assets/placeholder.png"),
//                       ),
//                 Positioned(
//                   child: IconButton(
//                     onPressed: () {
//                       selectdImage;
//                     },
//                     icon: const Icon(Icons.add_a_photo),
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
