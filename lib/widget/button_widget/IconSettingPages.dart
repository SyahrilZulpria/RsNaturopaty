import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WIconSetting extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;
  const WIconSetting({
    super.key,
    required this.title,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Icon(
            CupertinoIcons.chevron_forward,
            color: Colors.grey.shade400,
          )
        ],
      ),
    );
  }
}
