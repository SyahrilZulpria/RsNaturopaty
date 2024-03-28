// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:rsnaturopaty/screen/Product/detail_product.dart';
// import 'package:rsnaturopaty/widget/product_widget/WProduct_title_text.dart';
// import 'package:rsnaturopaty/widget/widget_all/WRoundedContainer.dart';
// import 'package:rsnaturopaty/widget/widget_all/WRoundedImages.dart';

// class VCardVerticalProduct extends StatelessWidget {
//   const VCardVerticalProduct({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => Get.to(() => const ProductDetailPages()),
//       child: Container(
//         width: 90,
//         padding: const EdgeInsets.only(top: 5),
//         decoration: BoxDecoration(boxShadow: const [
//           BoxShadow(
//             color: Colors.white,
//             blurRadius: 50,
//             spreadRadius: 1,
//             offset: Offset(0, 2),
//           )
//         ], borderRadius: BorderRadius.circular(16.0), color: Colors.orange),
//         child: Column(
//           children: [
//             WRoundedContainer(
//               height: 190,
//               padding: const EdgeInsets.all(10),
//               backgroundColor: Colors.white,
//               child: Stack(
//                 children: [
//                   // thumbnail image
//                   const WRoundedImages(
//                     imageUrl: "assets/product/psychedelic_grape.png",
//                     applyImageRadius: true,
//                   ),
//                   //pack sale
//                   Positioned(
//                     top: 10,
//                     left: 5,
//                     child: WRoundedContainer(
//                       radius: 8.0,
//                       backgroundColor: Colors.green,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 8.0, vertical: 4.0),
//                       child: Text(
//                         "25%",
//                         style: Theme.of(context)
//                             .textTheme
//                             .labelLarge!
//                             .apply(color: Colors.black),
//                       ),
//                     ),
//                   ),
//                   // Favourite icon button
//                   // const Positioned(
//                   //   top: 0,
//                   //   right: 0,
//                   //   child: WCircularIcon(
//                   //     icon: Iconsax.heart5,
//                   //     color: Colors.red,
//                   //   ),
//                   // ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16.0 / 2),
//             Padding(
//               padding: const EdgeInsets.only(left: 8.0),
//               child: Column(
//                 children: [
//                   const WProductTitleText(
//                     title: "Psychedelic Grape",
//                     smallSize: true,
//                   ),
//                   const SizedBox(
//                     height: 16.0 / 2,
//                   ),
//                   Row(
//                     children: [
//                       Text(
//                         "Psychedelic",
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 1,
//                         style: Theme.of(context).textTheme.labelMedium,
//                       ),
//                       const SizedBox(height: 6),
//                       const Icon(
//                         Iconsax.verify5,
//                         color: Colors.blue,
//                         size: 15,
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         '\$ 35.5',
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         style: Theme.of(context).textTheme.headlineMedium,
//                       ),
//                       Container(
//                         decoration: const BoxDecoration(
//                           color: Colors.black,
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                             bottomRight: Radius.circular(10),
//                           ),
//                         ),
//                         child: const SizedBox(
//                           width: 25,
//                           height: 30,
//                           child: Center(
//                             child: Icon(
//                               Iconsax.add,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
