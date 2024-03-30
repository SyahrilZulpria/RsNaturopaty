import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:rsnaturopaty/screen/Home/Article_pages/pages_article.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({super.key});

  @override
  State<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  List listArticle = [];

  @override
  void initState() {
    super.initState();
    articleAnnouncement();
  }

  articleAnnouncement() async {
    print(Endpoint.categoryArticle);
    try {
      var resBody =
          '{ "category":28, "limit": 10, "offset": 0, "orderby": "", "order": "asc"}';
      final response = await http
          .post(Uri.parse(Endpoint.categoryArticle),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'X-auth-token': 'X-auth-token',
              },
              body: resBody)
          .timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        // final articlePromo1 = responseJson['content']['result'];
        final List<dynamic> articlePromo = responseJson['content']['result'];
        print("========= Article Home ============");
        print(articlePromo);
        setState(() {
          listArticle = List<Map<String, dynamic>>.from(articlePromo);
        });
      } else {
        //CustomDialog().warning(context, '', 'Error: ${response.reasonPhrase}');
        print('Login failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      //CustomDialog().warning(context, '', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Announcement",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.purple,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: listArticle.length,
                  itemBuilder: (BuildContext context, int index) {
                    final article = listArticle[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Image(
                                  height: 100,
                                  width: 100,
                                  image: NetworkImage(
                                    article['image'],
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        article['title']
                                            .toString()
                                            .toUpperCase(),
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        article['text'],
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        article['date'],
                                        style: const TextStyle(
                                            fontSize: 8,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      const SizedBox(height: 5),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      PagesArticle(
                                                        permaLink: article[
                                                            'permalink'],
                                                      )),
                                            );
                                            print("Tess Buy");
                                          },
                                          child: Container(
                                            height: 35,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "View",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                SizedBox(width: 5),
                                                Icon(
                                                  Icons.arrow_forward,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}
