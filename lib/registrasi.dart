import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:rsnaturopaty/verify.dart';
import 'package:rsnaturopaty/widget/button_widget/ButtonOval.dart';
import 'package:rsnaturopaty/widget/utils/Colors.dart';
import 'package:rsnaturopaty/widget/utils/CustomDialog.dart';
import 'package:rsnaturopaty/widget/utils/NavBar.dart';
import 'package:search_choices/search_choices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Registrasi extends StatefulWidget {
  const Registrasi({super.key});

  @override
  State<Registrasi> createState() => _RegistrasiState();
}

class _RegistrasiState extends State<Registrasi> {
  TextEditingController nameController = TextEditingController();
  // TextEditingController tanggalLahirController = TextEditingController();
  TextEditingController noHandPhoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController kodePosController = TextEditingController();
  //TextEditingController kodeReveralController = TextEditingController();
  TextEditingController namaRekeningController = TextEditingController();
  TextEditingController noRekeningController = TextEditingController();
  TextEditingController inviteCodeController = TextEditingController();

  bool _obscureTextLogin = true;
  DateTime? _selectedDate;

  List<Map<String, dynamic>> listCity = [];
  List<Map<String, dynamic>> listBank = [];

  late ProgressDialog loading;

  String? selectedBank;
  String idBank = "";
  String namaBank = "";

  String? selectedCity;
  String idCity = "";
  String namaCity = "";

  @override
  void initState() {
    super.initState();

    loading = ProgressDialog(context,
        type: ProgressDialogType.normal, isDismissible: true, showLogs: false);
    loading.style(
        progressWidget: Padding(
      padding: const EdgeInsets.all(10),
      child: CircularProgressIndicator(color: colorPrimary),
    ));

    getSharedPref();
  }

  getSharedPref() async {
    // ignore: unused_local_variable
    final sp = await SharedPreferences.getInstance();

    await getDataCity();
    await getDataBank();
  }

  getDataCity() async {
    try {
      final response = await http.get(
        Uri.parse(Endpoint.city),
        headers: <String, String>{
          'Content-Type': 'application/json',
          //'X-auth-token': token,
        },
      ).timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        setState(() {
          listCity = List<Map<String, dynamic>>.from(
            responseJson['content']['result'].map(
                (city) => {'label': city['label'], 'value': city['value']}),
          );
        });
      } else if (response.statusCode == 401) {
        print('Login failed with : Unauthorized access');
      } else if (response.statusCode == 403) {
        CustomDialog()
            .expiredTokens(context, 'Token Expired', "Harap Login Kembali!");
      } else {
        print("Get data failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      CustomDialog().warning(context, '', e.toString());
    }
  }

  getDataBank() async {
    try {
      final response = await http.get(
        Uri.parse(Endpoint.bankList),
        headers: <String, String>{
          'Content-Type': 'application/json',
          //'X-auth-token': token,
        },
      ).timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        setState(() {
          listBank = List<Map<String, dynamic>>.from(
            responseJson['content']['result']
                .map((bank) => {'id': bank['id'], 'code': bank['code']}),
          );
        });
      } else if (response.statusCode == 401) {
        print('Login failed with : Unauthorized access');
      } else if (response.statusCode == 403) {
        CustomDialog()
            .expiredTokens(context, 'Token Expired', "Harap Login Kembali!");
      } else {
        print("Get data failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      CustomDialog().warning(context, '', e.toString());
    }
  }

  submitRegistration() async {
    print(Endpoint.registrasi);

    print("======== Data Registrasi Yang di Kirim =======");
    print("Nama: ${nameController.text}");
    print(_selectedDate);
    print("No Handphone: ${noHandPhoneController.text}");
    print("email: ${emailController.text}");
    print("Password: ${passwordController.text}");
    print("alamat: ${alamatController.text}");
    print("nama Kota: $namaCity");
    print("0");
    print("Kode Pos: ${kodePosController.text}");
    print("kode reveral: ${inviteCodeController.text}");
    print("taccname: ${namaRekeningController.text.toString()}");
    print("taccno: ${noRekeningController.text}");
    print("taccbank: $namaBank");
    print("========================================");

    try {
      final response = await http
          .post(Uri.parse(Endpoint.registrasi), headers: <String, String>{
        "Content-Type": "application/x-www-form-urlencoded",
        //HttpHeaders.authorizationHeader: "Bearer " + token
      }, body: {
        "tname": nameController.text.toString(),
        "tdob": _selectedDate != null
            ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
            : '',
        "tphone1": noHandPhoneController.text.toString(),
        "temail": emailController.text.toString(),
        "tpassword": passwordController.text.toString(),
        "taddress": alamatController.text.toString(),
        "ccity": namaCity,
        "cdistrict": "0",
        "tzip": kodePosController.text.toString(),
        "tcode": inviteCodeController.text.toString(),
        "taccname": namaRekeningController.text.toString(),
        "taccno": noRekeningController.text.toString(),
        "taccbank": namaBank,
      }).timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        print('API request successful');
        print(response.body);

        print("========================================");
        print("========= Get Data Respon API ==========");
        print("========================================");

        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        print(responseJson);
        var userId = responseJson["content"]["id"].toString();
        var email = responseJson["content"]["email"].toString();
        dataRegistrasiToSP(responseJson['content']);
        print("========================================");
        print("========================================");

        print(userId);
        print(email); // Assuming
        print(responseJson);

        print("========================================");
        print("========================================");

        // CustomDialog().dialogSuksesWithNavigator(
        //     context,
        //     "Berhasil Melakukan Registrasi",
        //     Navigator.of(context).pushReplacement(
        //         CupertinoPageRoute(builder: (context) => const VerifyPages())));
      } else if (response.statusCode == 400) {
        // Bad request, handle the error response
        final Map<String, dynamic> responseJson = json.decode(response.body);
        String errorMessage = responseJson['error'];
        CustomDialog().warning(context, 'Error', errorMessage);
      } else if (response.statusCode == 401) {
        CustomDialog()
            .expiredTokens(context, 'Token Expired', "Harap Login Kembali!");
      } else {
        // Failed request
        print('API request failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      CustomDialog().warning(context, '', e.toString());
    }
  }

  dataRegistrasiToSP(var data) async {
    final sp = await SharedPreferences.getInstance();

    sp.setString('userId', data['id'].toString());
    sp.setString('name', data['first_name'].toString());
    sp.setString('email', data['email'].toString());
    sp.setString('levelPotition', data['level_position'].toString());
    sp.setString('noRek', data['acc_no'].toString());
    sp.setString('nameRek', data['acc_name'].toString());
    sp.setString('nameBank', data['acc_bank'].toString());

    Navigator.of(context).pushReplacement(
        CupertinoPageRoute(builder: (context) => const VerifyPages()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => const NavCustomButton(),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Login",
                style: GoogleFonts.lato(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.w700),
              ),
            )
          ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Text("Register now",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.lato(
                        fontSize: 30, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                TextFormField(
                  controller: nameController,
                  style: const TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(top: 15, left: 15),
                    labelText: 'Name',
                    labelStyle: const TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: formColor,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: formBorder)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: formBorder)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: formBorder)),
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: Colors.black26,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  readOnly: true, // Membuat field hanya bisa dibaca
                  controller: TextEditingController(
                    text: _selectedDate != null
                        ? DateFormat('d/M/y').format(_selectedDate!)
                        : '',
                  ),
                  style: const TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(top: 15, left: 15),
                    labelText: 'Date of Birth',
                    labelStyle: const TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: formColor,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: formBorder)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: formBorder)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: formBorder)),
                    prefixIcon: const Icon(
                      Icons.calendar_today,
                      color: Colors.black26,
                    ),
                  ),
                  onTap: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate ?? DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );

                    if (pickedDate != null) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                  validator: (value) {
                    if (_selectedDate == null) {
                      return 'Tanggal lahir wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: noHandPhoneController,
                  style: const TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(top: 15, left: 15),
                    labelText: 'No.Handphone',
                    labelStyle: const TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: formColor,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: formBorder)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: formBorder)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: formBorder)),
                    prefixIcon: const Icon(
                      Icons.phone_android_sharp,
                      color: Colors.black26,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'No handphone wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  style: const TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(top: 15, left: 15),
                    labelText: 'E-Mail',
                    labelStyle: const TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: formColor,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: formBorder)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: formBorder)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: formBorder)),
                    prefixIcon: const Icon(
                      Icons.email_sharp,
                      color: Colors.black26,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'E-Mail wajib diisi';
                    } else if (!value.contains('@')) {
                      return 'Format E-Mail tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  obscureText: _obscureTextLogin,
                  style: const TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(top: 15, left: 15),
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: formColor,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: formBorder)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: formBorder)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: formBorder)),
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Colors.black26,
                    ),
                    suffixIcon: GestureDetector(
                      onTap: _lihatPassword,
                      child: Opacity(
                        opacity: 0.5,
                        child: Image.asset(
                          _obscureTextLogin
                              ? "assets/icons/ic_eye600.png"
                              : "assets/icons/ic_eye_slash.png",
                          height: 5,
                        ),
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password wajib diisi';
                    } else if (value.length < 8) {
                      return 'Password harus memiliki setidaknya 8 karakter';
                    } else if (!RegExp(r'^(?=.*[A-Z])(?=.*[0-9\W]).+$')
                        .hasMatch(value)) {
                      return 'Password harus memiliki huruf besar di awal, 1 angka atau simbol';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: alamatController,
                  style: const TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(top: 15, left: 15),
                    labelText: 'Alamat',
                    labelStyle: const TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: formColor,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: formBorder)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: formBorder)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: formBorder)),
                    prefixIcon: const Icon(
                      Icons.phone_android_sharp,
                      color: Colors.black26,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: formBorder)),
                  child: SearchChoices.single(
                    underline: const SizedBox(
                      height: 0,
                    ),
                    displayClearIcon: false,
                    closeButton: "Tutup",
                    isExpanded: true,
                    iconSize: 25,
                    padding: const EdgeInsets.only(right: 5, left: 10),
                    value: selectedCity,
                    items: listCity.map((item) {
                      return DropdownMenuItem(
                          value: "${item['value']}-${item['label']}",
                          child: Text(
                            item['label'],
                            style: const TextStyle(fontSize: 16.0),
                            overflow: TextOverflow.ellipsis,
                          ));
                    }).toList(),
                    hint: const Text(
                      "Pilih Kota",
                      style: TextStyle(color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                    searchHint: "Pilih Kota",
                    onChanged: (newVal) {
                      FocusScope.of(context).requestFocus(
                          FocusNode()); // <--- add this biar ga balik fokus ke textfield
                      setState(() {
                        selectedCity = newVal;

                        if (newVal != null) {
                          idCity = newVal.split('-')[0];
                          namaCity = newVal.split('-')[1];
                          print("label $namaCity");
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: kodePosController,
                  style: const TextStyle(fontSize: 16.0),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ], // Memungkinkan hanya angka yang dimasukkan
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(top: 15, left: 15),
                    labelText: 'Kode Pos',
                    labelStyle: const TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: formColor,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: formBorder)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: formBorder)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: formBorder)),
                    prefixIcon: const Icon(
                      Icons.phone_android_sharp,
                      color: Colors.black26,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kode Pos wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: inviteCodeController,
                  style: const TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(top: 15, left: 15),
                    labelText: 'Invitation Code',
                    labelStyle: const TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: formColor,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: formBorder)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: formBorder)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: formBorder)),
                    prefixIcon: const Icon(
                      Icons.group_add,
                      color: Colors.black26,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: namaRekeningController,
                  style: const TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(top: 15, left: 15),
                    labelText: 'Nama Rekening',
                    labelStyle: const TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: formColor,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: formBorder)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: formBorder)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: formBorder)),
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: Colors.black26,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama Rek wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: noRekeningController,
                  style: const TextStyle(fontSize: 16.0),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ], // Memungkinkan hanya angka yang dimasukkan
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(top: 15, left: 15),
                    labelText: 'No Rekening',
                    labelStyle: const TextStyle(color: Colors.black),
                    filled: true,
                    fillColor: formColor,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: formBorder)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: formBorder)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: formBorder)),
                    prefixIcon: const Icon(
                      Icons.credit_card_outlined,
                      color: Colors.black26,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'No Rek wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: formBorder)),
                  child: SearchChoices.single(
                    underline: const SizedBox(
                      height: 0,
                    ),
                    displayClearIcon: false,
                    closeButton: "Tutup",
                    isExpanded: true,
                    iconSize: 25,
                    padding: const EdgeInsets.only(right: 5, left: 10),
                    value: selectedBank,
                    items: listBank.map((item) {
                      return DropdownMenuItem(
                          value: "${item['id']}-${item['code']}",
                          child: Text(
                            item['code'],
                            style: const TextStyle(fontSize: 16.0),
                            overflow: TextOverflow.ellipsis,
                          ));
                    }).toList(),
                    hint: const Text(
                      "Select Bank",
                      style: TextStyle(color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                    searchHint: "Select Bank",
                    onChanged: (newVal) {
                      FocusScope.of(context).requestFocus(
                          FocusNode()); // <--- add this biar ga balik fokus ke textfield
                      setState(() {
                        selectedBank = newVal;

                        if (newVal != null) {
                          idBank = newVal.split('-')[0];
                          namaBank = newVal.split('-')[1];
                          print("code $namaBank");
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(height: 50),
                ButtonOval(
                  color: Colors.green,
                  width: MediaQuery.of(context).size.width,
                  label: "Daftar",
                  onPressed: () {
                    // Navigator.of(context).pushReplacement(CupertinoPageRoute(
                    //     builder: (context) => const VerifyPages()));
                    if (_validateForm()) {
                      // Lakukan registrasi jika semua field sudah terisi
                      submitRegistration();
                    } else {
                      // Tampilkan pesan bahwa ada field yang belum terisi
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Semua field wajib diisi'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 70),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _lihatPassword() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void hideLoading() {
    if (loading.isShowing()) {
      loading.hide().then((isHidden) {
        print(isHidden);
      });
    }
  }

  bool _validateForm() {
    // Lakukan validasi untuk setiap field
    return nameController.text.isNotEmpty &&
        noHandPhoneController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        alamatController.text.isNotEmpty &&
        kodePosController.text.isNotEmpty &&
        namaRekeningController.text.isNotEmpty &&
        noRekeningController.text.isNotEmpty;
  }
}
