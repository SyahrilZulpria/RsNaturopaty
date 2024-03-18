import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:rsnaturopaty/screen/Setting/profile/EditProfileNumber.dart';
import 'package:rsnaturopaty/screen/Setting/profile/EditProfileText.dart';
import 'package:rsnaturopaty/widget/utils/CustomDialog.dart';
import 'package:rsnaturopaty/widget/utils/WTextEditeProfile.dart';
//import 'package:rsnaturopaty/widget/widget_all/WCilcularImage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = '';
  String token = '';

  List listCustomer = [];
  // final TextEditingController _nameController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _bioController = TextEditingController();

  //String _profileImageUrl = 'https://via.placeholder.com/150';
  //late File _profileImageFile = File('');
  File? _imageFile;

  //PickedFile? _imageFile;
  //final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    getSharedPref();
  }

  getSharedPref() async {
    final sp = await SharedPreferences.getInstance();

    setState(() {
      token = sp.getString("token")!;
      // userId = sp.getString("userId")!;
      name = sp.getString("name") ?? "Guest";
      // email = sp.getString("email")!;
      // noPhone = sp.getString("noPhone")!;
      // log = sp.getString("log")!;
    });
    getDataCustomer();
  }

  // Future<void> _changeProfileImage() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(
  //     source: ImageSource.gallery,
  //   ); // Change to ImageSource.camera for camera

  //   if (pickedFile != null) {
  //     setState(() {
  //       _profileImageFile = File(pickedFile.path);
  //     });
  //   }
  // }
  getDataCustomer() async {
    try {
      final response = await http
          .get(Uri.parse(Endpoint.getCustomer), headers: <String, String>{
        //'Content-Type': 'application/json',
        'X-auth-token': token,
      }).timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        print('status code: ${response.statusCode}');
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());

        final Map<String, dynamic> dataCustomer = responseJson['content'];
        print(dataCustomer);
        setState(() {
          listCustomer = [dataCustomer];
        });
        print("============Hasil Get data listCustomer===========");
        print(listCustomer);
      } else {
        CustomDialog().warning(context, '', 'Error: ${response.reasonPhrase}');
        print('Login failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      CustomDialog().warning(context, '', e.toString());
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                  top: 20, right: 20, left: 20, bottom: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade400, blurRadius: 3),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 15, right: 20, left: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return SafeArea(
                              child: Wrap(
                                children: <Widget>[
                                  const SizedBox(height: 10),
                                  ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: const Text('Photo Library'),
                                    onTap: () {
                                      _pickImage(ImageSource.gallery);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.camera_alt),
                                    title: const Text('Camera'),
                                    onTap: () {
                                      _pickImage(ImageSource.camera);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: _imageFile == null
                          ? const CircleAvatar(
                              radius: 50,
                              backgroundImage: AssetImage('assets/nophoto.jpg'),
                            )
                          : CircleAvatar(
                              radius: 150,
                              backgroundImage: FileImage(_imageFile!),
                            ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Username',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Email Address',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    // SizedBox(
                    //   width: double.infinity,
                    //   child: Column(
                    //     children: [
                    //       WCircularImage(
                    //         image: _profileImageFile != null
                    //             ? _profileImageFile
                    //                 .path // Gunakan path dari File
                    //             : 'https://via.placeholder.com/150',
                    //         width: 150,
                    //         height: 150,
                    //       ),
                    //       TextButton(
                    //         onPressed: () {
                    //           _changeProfileImage();
                    //         },
                    //         child: const Text('Change Profile Picture'),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    const SizedBox(height: 30),
                    const Divider(
                      thickness: 0.5,
                      color: Colors.black,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: listCustomer.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              //const SizedBox(height: 20),
                              WTextEditeProfile(
                                onPressed: () {
                                  editDataPage(EditType.Name);
                                  print('Edit Name');
                                },
                                title: 'Name',
                                value: listCustomer[index]['fname'] ??
                                    'Your name'.toString(),
                              ),
                              const Divider(
                                thickness: 0.5,
                                color: Colors.black,
                              ),
                              WTextEditeProfile(
                                onPressed: () {
                                  print('Edit email');
                                },
                                title: 'E-mail',
                                value: listCustomer[index]['email'] ??
                                    'Your email'.toString(),
                              ),
                              const Divider(
                                thickness: 0.5,
                                color: Colors.black,
                              ),
                              WTextEditeProfile(
                                onPressed: () {
                                  print('Edit phone');
                                },
                                title: 'No Phone',
                                value: listCustomer[index]['phone1'] ??
                                    'Your no phone'.toString(),
                              ),
                              const Divider(
                                thickness: 0.5,
                                color: Colors.black,
                              ),
                              WTextEditeProfile(
                                onPressed: () {
                                  print('Edit password');
                                },
                                title: 'Password',
                                value: listCustomer[index]['password'] ??
                                    '**********'.toString(),
                              ),
                              const Divider(
                                thickness: 0.5,
                                color: Colors.black,
                              ),
                              WTextEditeProfile(
                                onPressed: () {
                                  print('Edit city');
                                },
                                title: 'City',
                                value: listCustomer[index]['city'] ??
                                    'Your city'.toString(),
                              ),
                              const Divider(
                                thickness: 0.5,
                                color: Colors.black,
                              ),
                              WTextEditeProfile(
                                onPressed: () {
                                  print('Edit address');
                                  editDataPage(EditType.Address);
                                },
                                title: 'Addres',
                                value: listCustomer[index]['address'] ??
                                    'Your address'.toString(),
                              ),
                              const Divider(
                                thickness: 0.5,
                                color: Colors.black,
                              ),
                              WTextEditeProfile(
                                onPressed: () {
                                  editDataNumberPage(EditNumberType.ZIP);
                                  print('Edit zip');
                                },
                                title: 'Kode Pos',
                                value: listCustomer[index]['zip'] ??
                                    'Your zip'.toString(),
                              ),
                              const Divider(
                                thickness: 0.5,
                                color: Colors.black,
                              ),
                              WTextEditeProfile(
                                onPressed: () {
                                  editDataPage(EditType.Profession);
                                  print('Edit profession');
                                },
                                title: 'Profession',
                                value: listCustomer[index]['profession'] ??
                                    'Your profession'.toString(),
                              ),
                              const Divider(
                                thickness: 0.5,
                                color: Colors.black,
                              ),
                              WTextEditeProfile(
                                onPressed: () {
                                  editDataPage(EditType.Organization);
                                  print('Edit organization');
                                },
                                title: 'Organization',
                                value: listCustomer[index]['organization'] ??
                                    'Your organization'.toString(),
                              ),
                              const Divider(
                                thickness: 0.5,
                                color: Colors.black,
                              ),
                              WTextEditeProfile(
                                onPressed: () {
                                  editDataNumberPage(EditNumberType.NPWP);
                                  print('Edit npwp');
                                },
                                title: 'NPWP',
                                value: listCustomer[index]['npwp'] ??
                                    'Your NPWP'.toString(),
                              ),
                              const Divider(
                                thickness: 0.5,
                                color: Colors.black,
                              ),
                              WTextEditeProfile(
                                onPressed: () {
                                  editDataPage(EditType.Website);
                                  print('Edit website');
                                },
                                title: 'Website',
                                value: listCustomer[index]['website'] ??
                                    'Your website',
                              ),
                              const Divider(
                                thickness: 0.5,
                                color: Colors.black,
                              ),
                              WTextEditeProfile(
                                onPressed: () {
                                  editDataPage(EditType.Instagram);
                                  print('Edit instagram');
                                },
                                title: 'Instagram',
                                value: listCustomer[index]['instagram'] ??
                                    'Your instagram',
                              ),
                              const Divider(
                                thickness: 0.5,
                                color: Colors.black,
                              ),
                              const SizedBox(height: 50),
                            ],
                          );
                        })
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void editDataPage(EditType editType) {
    String currentValue = '';
    switch (editType) {
      case EditType.Name:
        currentValue =
            listCustomer.isNotEmpty ? listCustomer[0]['fname'] ?? '' : '';
        break;
      case EditType.Address:
        currentValue =
            listCustomer.isNotEmpty ? listCustomer[0]['address'] ?? '' : '';
        break;
      case EditType.Profession:
        currentValue =
            listCustomer.isNotEmpty ? listCustomer[0]['profession'] ?? '' : '';
        break;
      case EditType.Organization:
        currentValue = listCustomer.isNotEmpty
            ? listCustomer[0]['organization'] ?? ''
            : '';
        break;
      case EditType.Website:
        currentValue =
            listCustomer.isNotEmpty ? listCustomer[0]['website'] ?? '' : '';
        break;
      case EditType.Instagram:
        currentValue =
            listCustomer.isNotEmpty ? listCustomer[0]['instagram'] ?? '' : '';
        break;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditDataPage(
          data: listCustomer[0],
          editType: editType,
          currentValue: currentValue,
        ),
      ),
    );
  }

  void editDataNumberPage(EditNumberType editNumberType) {
    String currentValue = '';
    switch (editNumberType) {
      case EditNumberType.NPWP:
        currentValue =
            listCustomer.isNotEmpty ? listCustomer[0]['npwp'] ?? '' : '';
        break;
      case EditNumberType.ZIP:
        currentValue =
            listCustomer.isNotEmpty ? listCustomer[0]['zip'] ?? '' : '';
        break;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditDataNumberPage(
          data: listCustomer[0],
          editNumberType: editNumberType,
          currentValue: currentValue,
        ),
      ),
    );
  }

  // Widget bottomSheet() {
  //   return Container(
  //     height: 100.0,
  //     width: MediaQuery.of(context).size.width,
  //     margin: const EdgeInsets.symmetric(
  //       horizontal: 20,
  //       vertical: 20,
  //     ),
  //     child: Column(
  //       children: <Widget>[
  //         const Text(
  //           "Choose Profile photo",
  //           style: TextStyle(
  //             fontSize: 20.0,
  //           ),
  //         ),
  //         const SizedBox(
  //           height: 20,
  //         ),
  //         Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
  //           TextButton.icon(
  //             icon: const Icon(Icons.camera),
  //             onPressed: () {
  //               takePhoto(ImageSource.camera);
  //             },
  //             label: const Text("Camera"),
  //           ),
  //           TextButton.icon(
  //             icon: const Icon(Icons.image),
  //             onPressed: () {
  //               takePhoto(ImageSource.gallery);
  //             },
  //             label: const Text("Gallery"),
  //           ),
  //         ])
  //       ],
  //     ),
  //   );
  // }

  // void takePhoto(ImageSource source) async {
  //   final pickedFile = await _picker.pickImage(
  //     source: source,
  //   );
  //   setState(() {
  //     if (pickedFile != null) {
  //       _imageFile = File(pickedFile.path) as PickedFile;
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }
}
