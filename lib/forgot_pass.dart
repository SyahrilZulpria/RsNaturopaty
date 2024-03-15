import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:rsnaturopaty/widget/button_widget/ButtonOval.dart';
import 'package:rsnaturopaty/widget/utils/Colors.dart';
import 'package:http/http.dart' as http;
import 'package:rsnaturopaty/widget/utils/CustomDialog.dart';

class ForgoutPassword extends StatefulWidget {
  const ForgoutPassword({super.key});

  @override
  State<ForgoutPassword> createState() => _ForgoutPasswordState();
}

class _ForgoutPasswordState extends State<ForgoutPassword> {
  TextEditingController otpController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = true;
  bool _obscureTextLogin = true;
  late ProgressDialog loading;

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
  }

  requestOTP() async {
    print(emailController.text);
    print(Endpoint.otp);
    try {
      var requestBody = jsonEncode({"username": emailController.text});
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

  forgotPassword() async {
    try {
      String username = emailController.text.toString().replaceAll(" ", "");
      String password = passwordController.text.toString().replaceAll(" ", "");
      String otp = otpController.text.toString().replaceAll(" ", "");

      final body = jsonEncode({
        'username': username,
        'new_password': password,
        'otp': otp,
      });
      final response = await http.post(Uri.parse(Endpoint.forgotPass),
          headers: <String, String>{
            "Content-Type": "application/json",
          },
          body: body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        print(responseJson);
        Navigator.of(context).pop();
        CustomDialog()
            .dialogSuksesMultiplePop(context, "Berhasil Mengganti Password", 1);
      } else if (response.statusCode == 401) {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        String errorMessage = errorJson["error"];
        CustomDialog().warning(context, '', errorMessage);
        //Login failed due to unauthorized access.
        print('Login failed: Unauthorized access');
        // Login failed. Display the response status code.
        print('Login failed with status code: ${response.statusCode}');
      } else if (response.statusCode == 404) {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        String errorMessage = errorJson["error"];
        // ignore: use_build_context_synchronously
        CustomDialog().warning(context, '', errorMessage);
        print('Login failed: $errorMessage');
        print('Login failed with status code: ${response.statusCode}');
      } else if (response.statusCode == 401) {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        String errorMessage = errorJson["error"];
        // ignore: use_build_context_synchronously
        CustomDialog().warning(context, '', errorMessage);
        print('Login failed: $errorMessage');
        print('Login failed with status code: ${response.statusCode}');
      } else {
        hideLoading();
        CustomDialog().warning(context, '', 'Error: ${response.reasonPhrase}');
        print('Login failed with status code: ${response.statusCode}');
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
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
                      "Forgot Password",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 50),
                    TextFormField(
                      controller: emailController,
                      style: const TextStyle(fontSize: 16.0),
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(top: 15, left: 15),
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
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      obscureText: _obscureTextLogin,
                      style: const TextStyle(fontSize: 16.0),
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(top: 15, left: 15),
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
                          onTap: lihatPassword,
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
                    ),
                    const SizedBox(height: 20),
                    Stack(
                      children: [
                        TextFormField(
                          controller: otpController,
                          style: const TextStyle(fontSize: 16.0),
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
                          keyboardType: TextInputType.phone,
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
                      width: MediaQuery.of(context).size.width,
                      color: Colors.green,
                      label: 'Kirim',
                      onPressed: () {
                        forgotPassword();
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

  void lihatPassword() {
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
}
