import 'package:flutter/material.dart';
import 'package:rsnaturopaty/widget/utils/app_date_formatters.dart';

class ArticleListItem extends StatelessWidget {
  final String title;
  final String author;
  final String category;
  final String authorImagesAssetPath;
  final String imageAssetPath;
  final DateTime date;

  const ArticleListItem(
      {super.key,
      required this.title,
      required this.author,
      required this.category,
      required this.authorImagesAssetPath,
      required this.imageAssetPath,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              imageAssetPath,
              width: 120,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category),
                const SizedBox(width: 10),
                Text(title),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(authorImagesAssetPath),
                      radius: 15,
                    ),
                    // Image.asset(authorImagesAssetPath), //images publisher
                    const SizedBox(width: 8),
                    Text('$author - ${AppDateFormatters.mdY(date)}'),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
