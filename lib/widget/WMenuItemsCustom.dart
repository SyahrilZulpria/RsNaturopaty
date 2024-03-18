import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MenuItemsCustom extends StatelessWidget {
  IconData icon;
  String text;
  Function() ontap;
  MenuItemsCustom({
    super.key,
    required this.icon,
    required this.text,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFF318E8C),
      ),
      title: Text(
        text,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 16.0,
        ),
      ),
      onTap: ontap,
    );
  }
}
