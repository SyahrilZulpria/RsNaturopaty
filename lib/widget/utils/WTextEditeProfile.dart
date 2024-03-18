import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WTextEditeProfile extends StatelessWidget {
  const WTextEditeProfile(
      {super.key,
      this.icon = CupertinoIcons.chevron_forward,
      required this.onPressed,
      required this.title,
      required this.value});

  final IconData icon;
  final VoidCallback onPressed;
  final String title, value;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                '$title:',
                style: TextStyle(
                    fontWeight: FontWeight.w100,
                    color: Colors.grey.shade500,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      value,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    icon,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
