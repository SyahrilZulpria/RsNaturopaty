import 'package:flutter/material.dart';

class WSectionHeding extends StatelessWidget {
  const WSectionHeding(
      {super.key,
      this.textColor,
      this.showActionButton = true,
      required this.title,
      this.buttonTitle = 'View All',
      this.onPressed});

  final Color? textColor;
  final bool showActionButton;
  final String title, buttonTitle;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: textColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,

          // Theme.of(context)
          //     .textTheme
          //     .headlineSmall!
          //     .apply(color: textColor)
        ),
        if (showActionButton)
          TextButton(
            onPressed: onPressed,
            child: Text(buttonTitle),
          ),
      ],
    );
  }
}
