import 'package:flutter/material.dart';

class ViewBanner extends StatelessWidget {
  final VoidCallback? onPressed;
  final String imageUrl;
  const ViewBanner({super.key, required this.imageUrl, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
