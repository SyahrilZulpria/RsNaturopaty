import 'package:flutter/material.dart';

class WCircularImage extends StatelessWidget {
  const WCircularImage({
    super.key,
    this.width = 50,
    this.height = 50,
    this.backgroundColor,
    //this.onPressed,
    this.padding = 16,
    required this.image,
    this.isNetworkImage = false,
    this.overlayColor,
    this.fit = BoxFit.cover,
  });

  final double width, height, padding;
  final String image;
  final bool isNetworkImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  //final VoidCallback? onPressed;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100), color: backgroundColor),
        child: Center(
          child: Image(
            image: isNetworkImage
                ? NetworkImage(image)
                : AssetImage(image) as ImageProvider,
            fit: fit,
            color: overlayColor,
          ),
        ));
  }
}
