import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';

class WButtonSearch extends StatelessWidget {
  const WButtonSearch(
      {super.key,
      required this.text,
      this.icon = Iconsax.search_normal,
      this.onTap,
      this.showBackground = true,
      this.showBorder = true,
      this.padding = const EdgeInsets.symmetric(horizontal: 5.0)});

  final String text;
  final IconData? icon;
  final VoidCallback? onTap;
  final bool showBackground, showBorder;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: showBackground ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: showBorder ? Border.all(color: Colors.grey) : null),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.grey,
              ),
              const SizedBox(width: 16),
              Text(
                text,
                style: Theme.of(context).textTheme.bodySmall,
              )
            ],
          ),
        ),
      ),
    );
  }
}
