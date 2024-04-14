import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:rsnaturopaty/forgot_pass.dart';
import 'package:rsnaturopaty/registrasi.dart';
import 'package:rsnaturopaty/verify.dart';
import 'package:rsnaturopaty/widget/button_widget/ButtonOval.dart';
import 'package:rsnaturopaty/widget/utils/Colors.dart';
import 'package:rsnaturopaty/widget/utils/CustomDialog.dart';
import 'package:rsnaturopaty/widget/utils/NavBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  static const String routeName = '/login';
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscureTextLogin = true;
  String ip = "";
  late ProgressDialog loading;
  List listData = [];

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

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  login() async {
    if (usernameController.text.toString().replaceAll(" ", "") == "" ||
        passwordController.text.toString().replaceAll(" ", "") == "") {
      CustomDialog().warning(context, '', "Harap Lengkapi Data");
    } else {
      try {
        loading.show();

        String username =
            usernameController.text.toString().replaceAll(" ", "");
        String password =
            passwordController.text.toString().replaceAll(" ", "");

        print("pr1$username");
        print("pr2$password");

        final headers = {'Content-Type': 'application/json'};
        final body = jsonEncode(
            {'username': username, 'password': password, "device": ""});

        final http.Response response = await http
            .post(Uri.parse(Endpoint.login), headers: headers, body: body);

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseJson =
              json.decode(response.body.toString());
          // print(responseJson);
          var token = responseJson["content"]["token"].toString();
          tokenGk(responseJson);
          // print(token); // Assuming the API response returns the token
          final authorizedHeaders = {
            'Content-Type': 'application/json',
            'X-auth-token': token,
          };
          const DecodeUrl =
              'https://api.rsnaturopaty.com/customer/decode_token';
          final apiResponse =
              await http.get(Uri.parse(DecodeUrl), headers: authorizedHeaders);
          // print('API Response: ${apiResponse.statusCode}');
          // print('API Response Body: ${apiResponse.body}');
          final Map<String, dynamic> getContent =
              jsonDecode(apiResponse.body.toString());
          dataLoginToSP(getContent['content']);
        } else if (response.statusCode == 300) {
          final Map<String, dynamic> responseJson =
              jsonDecode(response.body.toString());
          // print(responseJson);
          // Simpan data responsenya ke dalam SharedPreferences
          dataRegistrasiToSP(responseJson["content"]);
        } else if (response.statusCode == 401) {
          final Map<String, dynamic> errorJson = json.decode(response.body);
          String errorMessage = errorJson["error"];
          CustomDialog().warning(context, '', errorMessage);
          //Login failed due to unauthorized access.
          //  print('Login failed: Unauthorized access');
          // Login failed. Display the response status code.
          //  print('Login failed with status code: ${response.statusCode}');
        } else if (response.statusCode == 404) {
          final Map<String, dynamic> errorJson = json.decode(response.body);
          String errorMessage = errorJson["error"];
          // ignore: use_build_context_synchronously
          CustomDialog().warning(context, '', errorMessage);
          //  print('Login failed: $errorMessage');
          //  print('Login failed with status code: ${response.statusCode}');
        } else {
          hideLoading();
          CustomDialog()
              .warning(context, '', 'Error: ${response.reasonPhrase}');
          //  print('Login failed with status code: ${response.statusCode}');
        }
      } catch (e) {
        hideLoading();
        CustomDialog().warning(context, '', e.toString());
      }
    }
  }

  dataRegistrasiToSP(var data) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString('userId', data["id"].toString());
    sp.setString('email', data["username"].toString());
    sp.setString('noPhone', data["phone"].toString());
    sp.setString('status', data["status"].toString());

    if (data['status'].toString() == "1") {
      Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: (context) => const NavCustomButton()));
    } else if (data['status'].toString() == "0") {
      Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: (context) => const VerifyPages()));
    } else {
      Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: (context) => const NavCustomButton()));
    }
  }

  tokenGk(var data) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString('token', data['content']['token'].toString());

    Navigator.of(context).pushReplacement(
        CupertinoPageRoute(builder: (context) => const NavCustomButton()));
  }

  dataLoginToSP(var data) async {
    final sp = await SharedPreferences.getInstance();

    sp.setString('userId', data['userid'].toString());
    sp.setString('name', data['name'].toString());
    sp.setString('email', data['username'].toString());
    sp.setString('noPhone', data['phone'].toString());
    sp.setString('log', data['log'].toString());
    sp.setString('status', data['status'].toString());

    // Navigator.of(context).pushReplacement(
    //     CupertinoPageRoute(builder: (context) => const VerifyPages()));

    if (data['status'].toString() == "1") {
      Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: (context) => const NavCustomButton()));
    } else if (data['status'].toString() == "0") {
      Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: (context) => const VerifyPages()));
    } else {
      Navigator.of(context).pushReplacement(
          CupertinoPageRoute(builder: (context) => const NavCustomButton()));
    }
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: SizedBox(
            //height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                Image.asset(
                  "assets/icons/LogoRS'n.png",
                  width: 200,
                ),
                const SizedBox(height: 100),
                Text("Log in",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.lato(
                        fontSize: 30, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                TextFormField(
                  controller: usernameController,
                  style: const TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(top: 15, left: 15),
                    labelText: 'Username',
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
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => const Registrasi(),
                          ),
                        );
                      },
                      child: const Text(
                        "Regist Now",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => const ForgoutPassword(),
                          ),
                        );
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ButtonOval(
                  color: Colors.blue,
                  width: MediaQuery.of(context).size.width,
                  label: "Masuk",
                  //NavCustomeButton
                  onPressed: () {
                    FocusScope.of(context)
                        .unfocus(); // <--- add this biar ga balik fokus ke textfield
                    login();
                    // Navigator.of(context).pushReplacement(
                    //     CupertinoPageRoute(
                    //         builder: (context) =>
                    //             const NavCustomButton()));
                  },
                ),
                const SizedBox(height: 30),
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
}
