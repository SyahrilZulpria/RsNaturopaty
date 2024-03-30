import 'package:flutter/material.dart';
import 'package:rsnaturopaty/widget/utils/Colors.dart';

class CheckoutRow extends StatelessWidget {
  const CheckoutRow(
      {super.key,
      required this.title,
      required this.value,
      required this.onPressed});

  final String title;
  final String value;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      color: darkGrey,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                Expanded(
                  child: Text(
                    value,
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                        color: darkGrey,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(width: 15),
                Image.asset(
                  "assets/right.png",
                  width: 15,
                  height: 15,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CheckoutRowViwe extends StatelessWidget {
  const CheckoutRowViwe({
    super.key,
    required this.title,
    required this.value,
  });
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                    color: darkGrey, fontSize: 15, fontWeight: FontWeight.w600),
              ),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
