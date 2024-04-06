import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:rsnaturopaty/login.dart';
import 'package:rsnaturopaty/widget/button_widget/ButtonOval.dart';
import 'package:rsnaturopaty/widget/utils/Colors.dart';
import 'package:rsnaturopaty/widget/utils/CustomDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class VerifyPages extends StatefulWidget {
  const VerifyPages({super.key});

  @override
  State<VerifyPages> createState() => _VerifyPagesState();
}

class _VerifyPagesState extends State<VerifyPages> {
  String userId = "";
  String name = "";
  String username = "";
  String level = "";
  String noPhone = "";

  List dataCustomer = [];

  bool isLoading = true;

  TextEditingController otpController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    getSharedPref();
  }

  getSharedPref() async {
    final sp = await SharedPreferences.getInstance();

    setState(() {
      userId = sp.getString("userId") ??
          ""; // Menggunakan operator ?? untuk menangani jika data null
      name = sp.getString("name") ?? "";
      username = sp.getString("email") ?? "";
      level = sp.getString("levelPotition") ??
          ""; // Perhatikan penulisan levelPosition yang sebelumnya
      noPhone = sp.getString("noPhone") ?? "";
      emailController.text = username;
    });
  }

  requestOTP() async {
    print(Endpoint.otp);
    try {
      var requestBody = jsonEncode({"username": username});
      setState(() {
        isLoading = true;
      });
      final response = await http
          .post(Uri.parse(Endpoint.otp),
              headers: <String, String>{
                "Content-Type": "application/json",
              },
              body: requestBody)
          .timeout(const Duration(seconds: 60));

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('OTP telah berhasil dikirim ke ${emailController.text}'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Gagal mengirim OTP');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Future<void>
  VerifyAccount() async {
    print(userId);
    print(otpController.text);
    print('${Endpoint.otp}$userId/${otpController.text}');
    print('${Endpoint.verifyAccount}$userId/${otpController.text}');
    try {
      setState(() {
        isLoading = true;
      });

      final response = await http.get(
        Uri.parse("${Endpoint.verifyAccount}$userId/${otpController.text}"),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 60));

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());

        print(responseJson);
        // Navigator.of(context).pushReplacement(
        //     CupertinoPageRoute(builder: (context) => const Login()));
        // setState(() {
        //   dataCustomer = responseJson['content'];
        // });
        print("========================");
        print(dataCustomer);
        print("========================");
        CustomDialog().dialogSuksesMultiplePop(
            context, "Successful Account Verification", 1);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/LogoRS'n.png",
                      width: 200,
                    ),
                    const SizedBox(height: 100),
                    const Text(
                      "Verify Account",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 50),
                    TextFormField(
                      readOnly: true,
                      controller: emailController,
                      style: const TextStyle(fontSize: 16.0),
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(top: 15, left: 15),
                        labelText: 'Email',
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
                    ),
                    const SizedBox(height: 20),
                    Stack(
                      children: [
                        TextFormField(
                          controller: otpController,
                          style: const TextStyle(fontSize: 16.0),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.only(top: 15, left: 15),
                            labelText: 'OTP',
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
                              return 'No OTP wajib diisi';
                            }
                            return null;
                          },
                        ),
                        Positioned(
                          right: 5,
                          top: 7,
                          child: ElevatedButton(
                              onPressed: () {
                                requestOTP();
                                print("Request OTP");
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors
                                    .blue, // Ubah warna latar belakang menjadi biru
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      50), // Ubah bentuk tombol
                                ),
                              ),
                              child: const Text(
                                'Request OTP',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              )),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    ButtonOval(
                      color: Colors.green,
                      label: 'Kirim',
                      onPressed: () {
                        if (_validateForm()) {
                          // Lakukan registrasi jika semua field sudah terisi
                          VerifyAccount();
                        } else {
                          // Tampilkan pesan bahwa ada field yang belum terisi
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Semua field wajib diisi'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                        // FocusScope.of(context).unfocus();
                        // print("kirim");
                        // Navigator.of(context).pushReplacement(
                        //     CupertinoPageRoute(
                        //         builder: (context) => const Login()));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateForm() {
    // Lakukan validasi untuk setiap field
    return emailController.text.isNotEmpty && otpController.text.isNotEmpty;
  }
}
