import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rsnaturopaty/controller/home_controller.dart';
import 'package:rsnaturopaty/widget/widget_banner/WCircularContainer.dart';
import 'package:rsnaturopaty/widget/widget_banner/banner.dart';

class SlideViewBanner extends StatelessWidget {
  const SlideViewBanner({
    super.key,
    required this.banners,
  });

  final List<String> banners;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Column(
      children: [
        CarouselSlider.builder(
          options: CarouselOptions(
            viewportFraction: 1,
            onPageChanged: (index, _) => controller.updatePageIndicator(index),
            //autoplay: true, // Tambahkan opsi autoplay di sini
            autoPlayInterval: const Duration(seconds: 4),
          ),

          itemCount: banners.length,
          itemBuilder: (context, index, realIndex) {
            final imageUrl = banners[index];
            return ViewBanner(imageUrl: imageUrl);
          },
          //items: banners.map((url) => ViewBanner(imageUrl: url)).toList(),
        ),
        const SizedBox(height: 10),
        Obx(
          () => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < banners.length; i++)
                WCircularContainer(
                    width: 20,
                    height: 4,
                    margin: const EdgeInsets.only(right: 10),
                    backgroundColor: controller.carousalCurrentIndex.value == i
                        ? Colors.green
                        : Colors.grey),
            ],
          ),
        ),
      ],
    );
  }
}
