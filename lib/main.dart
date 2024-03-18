import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rsnaturopaty/login.dart';
// import 'package:rsnaturopaty/login.dart';
// import 'package:rsnaturopaty/screen/LoadingPages.dart';
// import 'package:rsnaturopaty/screen/Home/home_pages.dart';
import 'package:rsnaturopaty/widget/utils/NavBar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Widget page = const LoadingPage();
  //final storage = const FlutterSecureStorage();
  @override
  // void initState() {
  //   super.initState();
  //   checkLogin();
  // }

  // void checkLogin() async {
  //   String? token = await storage.read(key: "token");
  //   if (token != null) {
  //     setState(() {
  //       page = const NavCustomButton();
  //     });
  //   } else {
  //     setState(() {
  //       page = const Login();
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rumah Sehat Naturopaty',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.openSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const Login(),
      // const NavCustomButton(),
    );
  }
}
