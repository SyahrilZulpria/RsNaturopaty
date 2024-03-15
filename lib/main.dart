import 'package:flutter/material.dart';
import 'package:rsnaturopaty/login.dart';
// import 'package:rsnaturopaty/screen/Home/home_pages.dart';
// import 'package:rsnaturopaty/widget/utils/NavBar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rumah Sehat Naturopaty',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
          //const HomePages()

          ///const NavCustomButton()
          const Login(),
      //SplashScreen(),
    );
  }
}
