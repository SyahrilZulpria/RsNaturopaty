// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rsnaturopaty/api/ReferalRegist/auth/sign_up.dart';
import 'package:rsnaturopaty/login.dart';
import 'dart:html' as html;

import 'package:rsnaturopaty/widget/utils/NavBar.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const NavCustomButton(),
        '/register': (context) => const SignUpView(
              referrarCode: '',
            ),
        // Add more routes as needed for other deep links
      },
      builder: (context, widget) {
        html.window.onPopState.listen((event) {
          handleDeepLink(html.window.location.pathname!);
        });
        return widget!;
      },
    );
  }

  void handleDeepLink(String path) {
    switch (path) {
      case '/':
        runApp(const MaterialApp(home: NavCustomButton()));
        break;
      case '/register':
        runApp(const MaterialApp(
            home: SignUpView(
          referrarCode: '',
        )));
        break;
      // Add more cases for other deep links
      default:
        runApp(const MaterialApp(home: Login()));
        break;
    }
  }
}

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Rumah Sehat Naturopaty',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         scaffoldBackgroundColor: Colors.white,
//         textTheme: GoogleFonts.openSansTextTheme(
//           Theme.of(context).textTheme,
//         ),
//       ),
//       home:
//           //const Login(),
//           const NavCustomButton(),
//     );
//   }
// }
