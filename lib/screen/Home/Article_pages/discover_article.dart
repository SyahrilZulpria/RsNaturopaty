import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:rsnaturopaty/screen/Home/Article_pages/pages_article.dart';
import 'package:rsnaturopaty/widget/utils/CustomDialog.dart';
import 'package:http/http.dart' as http;
import 'package:rsnaturopaty/widget/utils/ImagesContainer.dart';

class ArticleDiscover extends StatefulWidget {
  const ArticleDiscover({super.key});

  @override
  State<ArticleDiscover> createState() => _ArticleDiscoverState();
}

class _ArticleDiscoverState extends State<ArticleDiscover> {
  List<Map<String, dynamic>> subCategoryArticle = [];
  List itemArticle = [];
  int tabLength = 0;

  @override
  void initState() {
    super.initState();

    getCategoryArticle();
  }

  getCategoryArticle() async {
    print(Endpoint.getArticleCategory);
    try {
      var bodyArticle = '{ "limit": 10, "offset": 0,}';
      final response = await http
          .post(Uri.parse(Endpoint.getArticleCategory),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'X-auth-token': 'X-auth-token',
              },
              body: bodyArticle)
          .timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        print(response.statusCode);
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        final List<dynamic> subCategory = responseJson['content']['result'];
        setState(() {
          subCategoryArticle = subCategory.cast<Map<String, dynamic>>();
          tabLength = subCategoryArticle.length;
          getArticleForInitialCategory(); // call getArticleForInitialCategory after setting subCategoryArticle
        });
      } else {
        CustomDialog().warning(context, '', 'Error: ${response.reasonPhrase}');
        print('Login failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      CustomDialog().warning(context, '', e.toString());
    }
  }

  Future<void> getArticleForInitialCategory() async {
    if (subCategoryArticle.isNotEmpty) {
      int initialCategoryId = subCategoryArticle.first['id'];
      await getArticle(initialCategoryId);
    }
  }

  Future<void> getArticle(int categoryId) async {
    print(Endpoint.categoryArticle);
    try {
      var bodyArticle =
          '{"category":$categoryId, "limit": 10, "offset": 0, "orderby": "", "order": "asc"}';
      final response = await http
          .post(Uri.parse(Endpoint.categoryArticle),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'X-auth-token': 'X-auth-token',
              },
              body: bodyArticle)
          .timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        print(response.statusCode);
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        final contentArticle = responseJson['content']['result'];
        setState(() {
          itemArticle = List.from(contentArticle);
        });
        //print("============ TEST =================");
        //print(itemArticle);
      } else {
        CustomDialog().warning(context, '', 'Error: ${response.reasonPhrase}');
        print('Login failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      CustomDialog().warning(context, '', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabLength,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Article Discover',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.purple,
          elevation: 0,
        ),
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            Column(
              children: [
                const SizedBox(height: 20),
                if (subCategoryArticle.isNotEmpty)
                  CategoryArticle(
                    subCategoryArticle: subCategoryArticle,
                    onCategorySelected: (categoryId) async {
                      await getArticle(categoryId);
                    },
                    itemArticle: itemArticle,
                  ),
                // CategoryArticle(
                //   subCategoryArticle: subCategoryArticle,
                //   onCategorySelected: (categoryId) async {
                //     await getArticle(categoryId);
                //   },
                //   itemArticle: itemArticle,
                // )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CategoryArticle extends StatefulWidget {
  const CategoryArticle(
      {super.key,
      required this.subCategoryArticle,
      required this.onCategorySelected,
      required this.itemArticle});

  final List<Map<String, dynamic>> subCategoryArticle;
  final Function(int) onCategorySelected;
  final List itemArticle;

  @override
  State<CategoryArticle> createState() => _CategoryArticleState();
}

class _CategoryArticleState extends State<CategoryArticle> {
  int _selectedCategoryId = -1;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          isScrollable: true,
          indicatorColor: Colors.black,
          tabs: widget.subCategoryArticle
              .map(
                (category) => Tab(
                  icon: Text(
                    category['name'][0].toUpperCase() +
                        category['name'].substring(1),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              )
              .toList(),
          onTap: (index) {
            setState(() {
              _selectedCategoryId = widget.subCategoryArticle[index]['id'];
              print("======== TAP Kedua Cek ID =========");
              print(_selectedCategoryId);
              isLoading = true;
            });
            widget.onCategorySelected(_selectedCategoryId);
            setState(() {
              isLoading = false;
            });
          },
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : TabBarView(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: widget.itemArticle.length,
                      itemBuilder: ((context, index) {
                        final articleData = widget.itemArticle[index];
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => PagesArticle(
                                  permaLink:
                                      articleData['permalink'].toString(),
                                ),
                              ),
                            );
                            print("Open Article In Discover");
                          },
                          child: Row(
                            children: [
                              ImagesContainer(
                                width: 80,
                                height: 80,
                                margin: const EdgeInsets.all(10.0),
                                borderRadius: 5,
                                imageUrl: articleData['image'],
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      articleData['name'],
                                      maxLines: 2,
                                      overflow: TextOverflow.clip,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_month_outlined,
                                          size: 15,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          articleData['date'],
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
        )
      ],
    );
  }
}
