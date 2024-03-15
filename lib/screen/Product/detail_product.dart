import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rsnaturopaty/widget/product_widget/WAtributProduct.dart';
import 'package:rsnaturopaty/widget/widget_all/WImagesProductSlider.dart';

class ProductDetailPages extends StatefulWidget {
  const ProductDetailPages({super.key});

  @override
  State<ProductDetailPages> createState() => _ProductDetailPagesState();
}

class _ProductDetailPagesState extends State<ProductDetailPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //bottomNavigationBar: const WButtomAddCart(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Product Images Slaider
            const WImagesProductSlider(),

            /// Product Detail
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  /// - Ratting & Share Button
                  //const WRattingAndShare(),

                  /// Price, Title, Stock, and Brand
                  //const WProductMetaData(),

                  /// Atribut
                  const WProductAttributes(),
                  const SizedBox(height: 16.0),

                  // /// Description
                  // const WSectionHeding(
                  //     title: 'Description', showActionButton: false),
                  // const SizedBox(height: 20.0),
                  // const ReadMoreText(
                  //   "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                  //   trimLines: 2,
                  //   trimMode: TrimMode.Line,
                  //   trimCollapsedText: ' Show more',
                  //   trimExpandedText: 'Less',
                  //   moreStyle:
                  //       TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  //   lessStyle:
                  //       TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                  // ),
                  const SizedBox(height: 16),

                  /// Checkout Button
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {}, child: const Text('Checkout'))),
                  const SizedBox(height: 16.0),

                  /// Reviews
                  // const Divider(),
                  // const SizedBox(height: 16),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     const WSectionHeding(
                  //         title: "Reviews (141)", showActionButton: false),
                  //     IconButton(
                  //       onPressed: () {},
                  //       icon: const Icon(
                  //         Iconsax.arrow_right_3,
                  //         size: 18,
                  //         color: Colors.black,
                  //       ),
                  //     )
                  //   ],
                  // ),
                  // const SizedBox(height: 16),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
