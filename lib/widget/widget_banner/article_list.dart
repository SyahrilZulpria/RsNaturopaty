import 'package:flutter/material.dart';
import 'package:rsnaturopaty/dummy.dart';
import 'package:rsnaturopaty/widget/widget_banner/article_list_item.dart';

class ArticleList extends StatelessWidget {
  const ArticleList({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => ArticleListItem(
          title: articleItems[index]['title']!,
          author: 'Testing Author',
          category: articleItems[index]['category']!,
          authorImagesAssetPath: '/assets/images/Product.png',
          imageAssetPath: 'assets/placeholder.png',
          date: DateTime.parse(articleItems[index]['date']!),
        ),
        childCount: articleItems.length,
      ),
    );
  }
}
