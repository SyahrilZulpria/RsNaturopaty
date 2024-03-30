import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:rsnaturopaty/login.dart';
import 'package:rsnaturopaty/screen/Home/home_pages.dart';
import 'package:rsnaturopaty/screen/MembersAdd/AddMamber.dart';
import 'package:rsnaturopaty/screen/Product/ProductNew/product_new.dart';
import 'package:rsnaturopaty/screen/Product/history_transaction.dart';
import 'package:http/http.dart' as http;
import 'package:rsnaturopaty/screen/Setting/SettingPages.dart';
import 'package:rsnaturopaty/widget/utils/Colors.dart';
import 'package:rsnaturopaty/widget/utils/CustomDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavCustomButton extends StatefulWidget {
  const NavCustomButton({super.key});

  @override
  State<NavCustomButton> createState() => _NavCustomButtonState();
}

class _NavCustomButtonState extends State<NavCustomButton> {
  String token = "";
  int index = 2;

  final screens = [
    const AddMembers(),
    const ProductNew(),
    const HomePages(),
    const HistoryTransaction(),
    const SettingPages(),
  ];

  getSharedPref() async {
    final sp = await SharedPreferences.getInstance();

    setState(() {
      token = sp.getString("token")!;
    });
  }

  decodeToken() async {
    print(Endpoint.decodeToken);
    try {
      final response = await http.post(
        Uri.parse(Endpoint.decodeToken),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'X-auth-token': token,
        },
      ).timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        print(responseJson);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      CustomDialog().warning(context, '', e.toString());
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      const Icon(Icons.groups, size: 30),
      const Icon(Icons.indeterminate_check_box_outlined, size: 30),
      const Icon(Icons.home, size: 30),
      const Icon(Icons.checklist_sharp, size: 30),
      const Icon(Icons.settings, size: 30),
    ];
    return Scaffold(
      body: IndexedStack(
        index: index,
        children: screens,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.white,
        buttonBackgroundColor: headerBackground,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        items: items,
        index: index,
        height: 60,
        onTap: (index) => setState(() => this.index = index),
      ),
    );
  }
}
