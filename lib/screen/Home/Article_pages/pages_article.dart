import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:rsnaturopaty/widget/utils/CustomDialog.dart';
import 'package:rsnaturopaty/widget/utils/ImagesContainer.dart';

class PagesArticle extends StatefulWidget {
  const PagesArticle({
    super.key,
    required this.permaLink,
  });
  final String permaLink;

  @override
  State<PagesArticle> createState() => _PagesArticleState();
}

class _PagesArticleState extends State<PagesArticle> {
  Map<String, dynamic> listArticle = {};

  @override
  void initState() {
    super.initState();
    getArticleDetail();
  }

  getArticleDetail() async {
    print(listArticle);
    print("======== Link ========");
    print('${Endpoint.getArticlePermalink}${widget.permaLink}');
    try {
      final response = await http.get(
        Uri.parse('${Endpoint.getArticlePermalink}${widget.permaLink}'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'X-auth-token': 'X-auth-token',
        },
      ).timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        print("=========== get article detail ===========");
        print(responseJson);
        setState(() {
          listArticle = responseJson['content'];
        });
      }
    } catch (e) {
      CustomDialog().warning(context, '', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Article",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: listArticle.isNotEmpty
          ? ListView(
              padding: EdgeInsets.zero,
              children: [
                ArticleImagesHead(
                  imageUrl: listArticle['image'].toString(),
                  categoryArticle: listArticle['category'].toString(),
                  dateArticle: listArticle['date'].toString(),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: Colors.white),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        listArticle['title'].toString(),
                        // "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        listArticle['text'].toString(),
                        //"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w300),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                )
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

//ArticleImagesHead

class ArticleImagesHead extends StatelessWidget {
  const ArticleImagesHead({
    super.key,
    required this.imageUrl,
    required this.categoryArticle,
    required this.dateArticle,
  });
  final String imageUrl;
  final String categoryArticle;
  final String dateArticle;

  @override
  Widget build(BuildContext context) {
    return ImagesContainer(
      height: MediaQuery.of(context).size.height * 0.45,
      width: double.infinity,
      imageUrl: imageUrl,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const SizedBox(width: 10),
              CustomTag(
                backgroundColor: Colors.black.withOpacity(0.5),
                children: [
                  Text(
                    categoryArticle,
                    style: const TextStyle(color: Colors.white),
                  )
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              CustomTag(
                backgroundColor: Colors.grey.withOpacity(0.5),
                children: [
                  const Icon(Icons.calendar_month, color: Colors.black),
                  const SizedBox(width: 10),
                  Text(
                    dateArticle,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w700),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class CustomTag extends StatelessWidget {
  const CustomTag(
      {super.key, required this.backgroundColor, required this.children});

  final Color backgroundColor;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
