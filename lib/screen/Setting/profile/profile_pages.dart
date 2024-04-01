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
  Map<String, dynamic> listImage = {};
  File? _imageFile;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    getSharedPref();
  }

  Future<void> refreshData() async {
    await getDataCustomer();
  }

  getSharedPref() async {
    final sp = await SharedPreferences.getInstance();

    setState(() {
      token = sp.getString("token")!;
      name = sp.getString("name") ?? "Guest";
    });
    getDataCustomer();
  }

  getDataCustomer() async {
    print(Endpoint.getCustomer);
    try {
      final response = await http
          .get(Uri.parse(Endpoint.getCustomer), headers: <String, String>{
        'Content-Type': 'application/json',
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
          listImage = responseJson['content'];
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

  Future<void> uploadImageProfile() async {
    print("SalesAddItem");
    print(Endpoint.upProfileImg);
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(Endpoint.upProfileImg),
      );
      request.headers['X-auth-token'] = token;
      request.fields['userfile'] = '';

      print("==================");
      print("========= Body Upload Image ==========");
      print('Request Body: ${request.fields}');

      final response = await request.send();
      final responseData = await response.stream.transform(utf8.decoder).join();
      print("Upload Foto : ${response.statusCode}");
      if (response.statusCode == 200) {
        print('${response.statusCode}');
        final Map<String, dynamic> responseJson = json.decode(responseData);
        String content = responseJson['content'];
        print(content);
        //CustomDialog().warning(context, '', content);
        print("============== Item Add =================");
        print(responseJson);
      } else if (response.statusCode == 400) {
        print('${response.statusCode}');
        final Map<String, dynamic> errorJson = json.decode(responseData);
        String errorMessage = errorJson["error"];
        //CustomDialog().warning(context, '', errorMessage);
        print(errorMessage);
      } else {
        print("Error salesAddItem status code: ${response.statusCode}");
      }
    } catch (e) {
      //CustomDialog().warning(context, '', e.toString());
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Panggil Navigator.pop(context) saat ikon kembali diklik
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.purple,
      ),
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                      Stack(
                        children: [
                          SizedBox(
                            width: 120,
                            height: 129,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(""),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.purple),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                size: 20,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        listImage['email'].toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        listImage['phone1'].toString(),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
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
      ),
    );
  }

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
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
}
