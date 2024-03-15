import 'package:flutter/material.dart';

class ProductPages extends StatefulWidget {
  const ProductPages({super.key});

  @override
  State<ProductPages> createState() => _ProductPagesState();
}

class _ProductPagesState extends State<ProductPages> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:rsnaturopaty/widget/product_widget/VCardVerticalProduct.dart';
// import 'package:rsnaturopaty/widget/widget_all/WCilcularImage.dart';
// import 'package:rsnaturopaty/widget/widget_all/WGridLayout.dart';
// import 'package:rsnaturopaty/widget/widget_all/WRoundedContainer.dart';

// class ProductPages extends StatefulWidget {
//   const ProductPages({super.key});

//   @override
//   State<ProductPages> createState() => _ProductPagesState();
// }

// class _ProductPagesState extends State<ProductPages> {
//   TextEditingController cariController = TextEditingController();

//   // void search(String keyword) {
//   //   List results = [];
//   //   if (keyword.isEmpty) {
//   //     results = listData;
//   //   } else {
//   //     results = listData
//   //         .where((barang) =>
//   //             barang['no_polisi'].toLowerCase().contains(keyword.toLowerCase()))
//   //         .toList();
//   //   }

//   //   setState(() {
//   //     searchData = results;
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Store",
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.purple,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             const SizedBox(height: 16),
//             WRoundedContainer(
//               padding: const EdgeInsets.all(8),
//               showBorder: true,
//               backgroundColor: Colors.transparent,
//               child: Row(
//                 children: [
//                   /// Icon
//                   const WCircularImage(
//                     image: 'assets/images/nophoto.jpg',
//                     isNetworkImage: false,
//                     backgroundColor: Colors.transparent,
//                   ),
//                   const SizedBox(
//                     width: 16 / 2,
//                   ),
//                   Column(
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             "Psychedelic",
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                             style: Theme.of(context).textTheme.labelMedium,
//                           ),
//                           const SizedBox(height: 6),
//                         ],
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             WGridLayout(
//               itemCount: 5,
//               itemBuilder: (BuildContext, int) => const VCardVerticalProduct(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
