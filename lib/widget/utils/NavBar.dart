import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rsnaturopaty/screen/Home/Article_pages/discover_article.dart';
import 'package:rsnaturopaty/screen/Home/home_pages.dart';
import 'package:rsnaturopaty/screen/MembersAdd/AddMamber.dart';
import 'package:rsnaturopaty/screen/Product/ProductNew/product_new.dart';
import 'package:rsnaturopaty/screen/Setting/SettingPages.dart';
import 'package:rsnaturopaty/widget/utils/Colors.dart';

class NavCustomButton extends StatefulWidget {
  static const String routeName = '/signUp';
  const NavCustomButton({super.key});

  @override
  State<NavCustomButton> createState() => _NavCustomButtonState();
}

class _NavCustomButtonState extends State<NavCustomButton> {
  //String token = "";
  int index = 2;
  bool loggedIn = false;

  final screens = [
    const AddMembers(),
    const ProductNew(),
    const HomePages(),
    //const TransactionCheckout(),
    const ArticleDiscover(),
    const SettingPages(),
  ];

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
      body: IndexedStack(index: index, children: screens),
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.white,
        buttonBackgroundColor: headerBackground,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        items: items,
        index: index,
        height: 60,
        onTap:
            //navigateToIndex,
            (index) => setState(() => this.index = index),
      ),
    );
  }
}
