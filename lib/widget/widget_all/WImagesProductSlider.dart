import 'package:flutter/material.dart';
import 'package:rsnaturopaty/widget/widget_all/WAppBar.dart';
import 'package:rsnaturopaty/widget/widget_all/WCurvedEdges.dart';
import 'package:rsnaturopaty/widget/widget_all/WRoundedImages.dart';

class WImagesProductSlider extends StatelessWidget {
  const WImagesProductSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedEdgesWidget(
      child: Container(
        color: Colors.grey.shade400,
        child: Stack(
          children: [
            const SizedBox(
              height: 400,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Image(
                    image: AssetImage("assets/product/psychedelic_grape.png"),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 10,
              bottom: 25,
              left: 23,
              child: SizedBox(
                height: 80,
                child: ListView.separated(
                  itemCount: 5,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(),
                  separatorBuilder: (_, __) => const SizedBox(
                    width: 16.0,
                  ),
                  itemBuilder: (_, index) => WRoundedImages(
                      width: 80,
                      backgroundColor: Colors.white,
                      border: Border.all(color: Colors.black),
                      padding: const EdgeInsets.all(8.0),
                      imageUrl: "assets/product/1/1.psychedelic.png"),
                ),
              ),
            ),
            const WAppBar(
              showBackArrow: true,
              actions: [
                // WCircularIcon(
                //   icon: Iconsax.heart5,
                //   color: Colors.red,
                // )
              ],
            )
          ],
        ),
      ),
    );
  }
}
