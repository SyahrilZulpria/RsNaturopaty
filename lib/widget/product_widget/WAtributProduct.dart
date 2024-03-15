import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:readmore/readmore.dart';
import 'package:rsnaturopaty/widget/widget_all/WRoundedContainer.dart';
import 'package:rsnaturopaty/widget/widget_all/WSectionHeding.dart';

class WProductAttributes extends StatelessWidget {
  const WProductAttributes({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        /// Selected Attribute Pricing & Description
        WRoundedContainer(
          padding: EdgeInsets.all(10.0),
          backgroundColor: Colors.grey,
          child: Column(
            children: [
              /// Title
              Row(
                children: [
                  WSectionHeding(title: 'Description', showActionButton: false),
                  SizedBox(width: 16),
                  //   Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Row(
                  //         children: [
                  //           const WProductTitleText(
                  //               title: 'Price', smallSize: true),
                  //           const SizedBox(width: 16.0),

                  //           /// Actual Price
                  //           Text(
                  //             '\$25',
                  //             style: Theme.of(context)
                  //                 .textTheme
                  //                 .titleSmall!
                  //                 .apply(decoration: TextDecoration.lineThrough),
                  //           ),
                  //           const SizedBox(width: 16.0),

                  //           /// Sale Price
                  //           const WProductPriceText(price: '20'),
                  //         ],
                  //       ),

                  //       /// Stock
                  //       Row(
                  //         children: [
                  //           const WProductTitleText(
                  //               title: 'Stock', smallSize: true),
                  //           const SizedBox(width: 16.0),
                  //           Text(
                  //             'In Stock',
                  //             style: Theme.of(context).textTheme.titleMedium,
                  //           )
                  //         ],
                  //       ),
                  //     ],
                  //   )
                ],
              ),

              /// Variantion Description
              ReadMoreText(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                trimLines: 2,
                trimMode: TrimMode.Line,
                trimCollapsedText: ' Show more',
                trimExpandedText: 'Less',
                moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                lessStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.0),

        // /// Attributes
        // Wrap(
        //   spacing: 8,
        //   children: [
        //     const WSectionHeding(title: 'Flavor'),
        //     const SizedBox(height: 16.0 / 2),
        //     WChoiceChip(text: 'Green', selected: false, onSelected: (value) {}),
        //     WChoiceChip(text: 'Orange', selected: true, onSelected: (value) {}),
        //     WChoiceChip(
        //         text: 'Yellow', selected: false, onSelected: (value) {}),
        //   ],
        // ),
      ],
    );
  }
}
