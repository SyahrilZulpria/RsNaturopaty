import 'package:flutter/material.dart';

class WCircularContainer extends StatelessWidget {
  const WCircularContainer(
      {super.key,
      this.width = 100,
      this.height = 100,
      this.radius = 200,
      this.padding = 0,
      this.margin,
      this.child,
      required this.backgroundColor});

  final double? width;
  final double? height;
  final double radius;
  final double padding;
  final EdgeInsets? margin;
  final Widget? child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: margin,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: backgroundColor,
      ),
      child: child,
    );
  }
}
