// import 'package:flutter/material.dart';

// class WProductMetaData extends StatelessWidget {
//   const WProductMetaData({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ///Price & Sale Price
//         Row(
//           children: [
//             ///Sale Tag
//             const SizedBox(width: 10),
//             Text(
//               '\$250',
//               style: Theme.of(context)
//                   .textTheme
//                   .titleSmall!
//                   .apply(decoration: TextDecoration.lineThrough),
//             ),
//             const SizedBox(width: 10),
//             const WProductPriceText(
//               price: '175',
//               isLarge: true,
//             ),

//             ///Price
//           ],
//         ),
//         const SizedBox(height: 16.0 / 1.5),

//         ///Title
//         const WProductTitleText(title: 'PSYCHEDELIC WATER'),
//         const SizedBox(height: 16.0 / 1.5),

//         ///Stock Status
//         Row(
//           children: [
//             const WProductTitleText(title: 'Status'),
//             const SizedBox(
//               width: 16,
//             ),
//             Text(
//               'In Stock',
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//           ],
//         ),
//         const SizedBox(height: 16.0 / 1.5),

//         ///Brand
//       ],
//     );
//   }
// }
