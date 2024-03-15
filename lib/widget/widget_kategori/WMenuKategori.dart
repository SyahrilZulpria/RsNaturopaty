import 'package:flutter/material.dart';

class WMenuKategori extends StatelessWidget {
  const WMenuKategori(
      {super.key,
      required this.title,
      required this.icon,
      required this.onPressed});

  final String title;
  final String icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: Image.asset(
              icon,
              fit: BoxFit.cover,
              //scale: 13,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
