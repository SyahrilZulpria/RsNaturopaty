import 'package:flutter/material.dart';
import 'package:rsnaturopaty/widget/utils/Colors.dart';

class ButtonOval extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final double? width;
  final double? height;
  final Color? color;
  final Color? textColor;
  final double? radius;

  const ButtonOval({
    super.key,
    required this.label,
    required this.onPressed,
    this.width,
    this.height,
    this.color,
    this.textColor,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 40,
      width: width ?? 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius ?? 50),
        gradient: LinearGradient(
          colors: [color ?? colorPrimary, color ?? colorPrimary],
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: onPressed,
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  color: textColor ?? Colors.white,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}

class RoundButton extends StatelessWidget {
  final String title;
  final Color? bgColor;
  final VoidCallback onPressed;
  const RoundButton(
      {super.key, required this.title, this.bgColor, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      height: 60,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
      minWidth: double.maxFinite,
      elevation: 0.1,
      color: bgColor ?? Colors.green,
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }
}
