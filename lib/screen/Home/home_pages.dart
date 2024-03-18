import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:rsnaturopaty/screen/Home/Article_pages/article_pages.dart';
import 'package:rsnaturopaty/widget/utils/Colors.dart';
import 'package:rsnaturopaty/widget/utils/CustomDialog.dart';
import 'package:rsnaturopaty/widget/widget_all/WSectionHeding.dart';
import 'package:rsnaturopaty/widget/widget_banner/SliderViewBanner.dart';
import 'package:rsnaturopaty/widget/widget_kategori/WMenuKategori.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePages extends StatefulWidget {
  const HomePages({
    super.key,
  });

  @override
  State<HomePages> createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  String token = "";
  String userId = "";
  String name = "";
  String email = "";
  String noPhone = "";
  String log = "";
  String status = "";

  List<String> listImgSlider = [];
  List listDompet = [];
  List hasilTransksiDompet = [];
  List listPoint = [];
  List listArticle = [];
  int activeIndex = 0;

  //final storage = const FlutterSecureStorage();

  final urlImages = [
    'assets/images/Indonesia_map.png',
    "assets/images/Product.png",
    'assets/images/Indonesia_map.png',
  ];
  final iklanCategory = ['Testing', 'Product', 'Maps'];
  final titleIklan = [
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ',
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. ',
    'Lorem ipsum dolor sit amet, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
  ];
  final mediaIklan = ['CNN', 'DETIK', 'LIPUTAN'];

  final controller = CarouselController();

  @override
  void initState() {
    super.initState();

    getSharedPref();
    articlePermalink();
    imgSlider();
  }

  getSharedPref() async {
    final sp = await SharedPreferences.getInstance();

    setState(() {
      token = sp.getString("token")!;
      userId = sp.getString("userId")!;
      name = sp.getString("name") ?? "Guest";
      email = sp.getString("email")!;
      noPhone = sp.getString("noPhone")!;
      log = sp.getString("log")!;
    });
    saldoDompet();
    saldoPoint();
  }

  imgSlider() async {
    try {
      final response = await http.get(
        Uri.parse(Endpoint.imgSlider),
        headers: <String, String>{
          'Content-Type': 'application/json',
          //'X-auth-token': token,
        },
      ).timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());

        print(responseJson['content']);
        List<dynamic> imagesData = responseJson['content']['result'];
        setState(() {
          listImgSlider = imagesData
              .map((imageData) => imageData['image'].toString())
              .toList();
        });
        print("=========================");
        print(imagesData);
        print("=========================");
        print(listImgSlider);
        print("=========================");
        print("=========== IMAGE ==============");
      } else {
        print("Get data failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      CustomDialog().warning(context, '', e.toString());
    }
  }

  // decodeToken() async {
  //   print(Endpoint.decodeToken);
  //   try {
  //     final response = await http.post(
  //       Uri.parse(Endpoint.decodeToken),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //         'X-auth-token': token,
  //       },
  //     ).timeout(const Duration(seconds: 60));

  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> responseJson =
  //           json.decode(response.body.toString());
  //       dataLoginToSP(responseJson['content']);
  //     }
  //   } catch (e) {
  //     CustomDialog().warning(context, '', e.toString());
  //   }
  // }

  // dataLoginToSP(var data) async {
  //   final sp = await SharedPreferences.getInstance();

  //   print("----================--------");
  //   print("Data Reg");
  //   //print(data['userid']);
  //   print(data['name']);
  //   print(data['username'].toString());
  //   print(data['phone'].toString());
  //   print(data['log'].toString());
  //   print(data['status'].toString());
  //   print("----================--------");

  //   sp.setString('userId', data['userid'].toString());
  //   sp.setString('name', data['name'].toString());
  //   sp.setString('email', data['username'].toString());
  //   sp.setString('noPhone', data['phone'].toString());
  //   sp.setString('log', data['log'].toString());
  //   sp.setString('status', data['status'].toString());
  // }

  saldoDompet() async {
    print(Endpoint.getDompet);
    try {
      var resBody = '{"limit":"100", "offset": "0"}';
      final response = await http
          .post(Uri.parse(Endpoint.getDompet),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'X-auth-token': token,
              },
              body: resBody)
          .timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        print(responseJson);
        //List<dynamic> dataDompet = responseJson['content'];
        final Map<String, dynamic> content = responseJson['content'];
        final int balance = content['balance'];
        setState(() {
          listDompet = [balance.toString()];
        });
        print("============Hasil Get data===========");
        print(listDompet);
        print("========================");
      } else {
        CustomDialog().warning(context, '', 'Error: ${response.reasonPhrase}');
        print('Login failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      CustomDialog().warning(context, '', e.toString());
    }
  }

  saldoPoint() async {
    print(Endpoint.getDompet);
    try {
      var resBody = '{"limit":"100", "offset": "0"}';
      final response = await http
          .post(Uri.parse(Endpoint.getPoint),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'X-auth-token': token,
              },
              body: resBody)
          .timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        print(responseJson);
        //List<dynamic> dataDompet = responseJson['content'];
        final Map<String, dynamic> content = responseJson['content'];
        final int balance = content['balance'];
        setState(() {
          listPoint = [balance.toString()];
        });
        print("============Hasil Get data===========");
        print(listPoint);
        print("========================");
      } else {
        CustomDialog().warning(context, '', 'Error: ${response.reasonPhrase}');
        print('Login failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      CustomDialog().warning(context, '', e.toString());
    }
  }

  articlePermalink() async {
    print(Endpoint.getArticlePermalink);
    try {
      final response = await http.get(
        Uri.parse(Endpoint.getArticlePermalink),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'X-auth-token': 'X-auth-token',
        },
      ).timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        final Map<String, dynamic> articlePromo = responseJson['content'];
        print(articlePromo);
        setState(() {
          listArticle = [articlePromo];
        });
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Image.asset(
            "assets//icons/LogoRS'n.png",
            fit: BoxFit.contain,
            width: 120,
            height: 50,
          ),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: Colors.white,
            onPressed: () {
              // Tambahkan logika notifikasi di sini
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 20),
              child: Row(
                children: [
                  const Text(
                    "Hi... ",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    name.isNotEmpty ? name : "Guest",
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10, left: 20, right: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 20, right: 20, left: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            const Text(
                              "Saldo Ku",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              listDompet.isNotEmpty
                                  ? "Rp ${listDompet.first}"
                                  : "Rp 0",
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                            )
                          ],
                        ),
                        Container(
                          width: 0.5,
                          height: 40,
                          color: Colors.black38,
                        ),
                        Column(
                          children: [
                            const Text(
                              "Point Ku",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/icons/reward.png",
                                  width: 30,
                                  height: 30,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  listPoint.isNotEmpty
                                      ? " ${listPoint.first}"
                                      : " 0",
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            CarouselSlider.builder(
              itemCount: listImgSlider.length,
              itemBuilder: (context, index, realIndex) {
                final urlImage = listImgSlider[index];

                return buildImage(urlImage);
              },
              options: CarouselOptions(
                  // height: 200,
                  autoPlay: true,
                  enableInfiniteScroll: false,
                  autoPlayAnimationDuration: const Duration(seconds: 5),
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) =>
                      setState(() => activeIndex = index)),
            ),
            const SizedBox(height: 12),
            buildIndicator(),
            const SizedBox(height: 20),
            // Padding(
            //   padding: const EdgeInsets.all(10),
            //   child: SlideViewBanner(
            //     banners: [listImgSlider.toString()],
            //   ),
            // ),
            const SizedBox(height: 20),
            Container(
              //color: Colors.cyan,
              margin: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  SizedBox(
                    //width: double.infinity,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 25),
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            boxShadow: [
                              BoxShadow(color: shadow, blurRadius: 5.0)
                            ],
                            gradient: const LinearGradient(
                              colors: [Colors.white, Colors.white],
                            ),
                          ),
                          child: Column(children: [
                            const SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(width: 10),
                                WMenuKategori(
                                  title: 'Our Package',
                                  icon: 'assets/icons/box1.png',
                                  onPressed: () {
                                    print("product");
                                  },
                                ),
                                const SizedBox(width: 10),
                                WMenuKategori(
                                  title: 'Team',
                                  icon: 'assets/icons/developers.png',
                                  onPressed: () {
                                    print("Team");
                                  },
                                ),
                                const SizedBox(width: 10),
                                WMenuKategori(
                                  title: 'Announcement',
                                  icon: 'assets/icons/announcement.png',
                                  onPressed: () {
                                    print("Announcement");
                                  },
                                ),
                                const SizedBox(width: 10),
                                WMenuKategori(
                                  title: 'About me',
                                  icon: 'assets/icons/letter-i.png',
                                  onPressed: () {
                                    print("Documentasi");
                                  },
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(height: 3, color: Colors.grey[300]),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: WSectionHeding(
                title: "Article",
                showActionButton: true,
                onPressed: () {
                  print("test");
                },
              ),
            ),
            const SizedBox(height: 20),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: listArticle.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => const ArticleHomePages()));
                      print("object pages");
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: shadow,
                                blurRadius: 5.0,
                              )
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  listArticle[index]['image'],
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      listArticle[index]['title'],
                                      style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      listArticle[index]['text']!,
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
            const SizedBox(height: 20),
            Container(
              color: Colors.amber,
              width: double.infinity,
              height: 200,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height - 200,
              child: Column(
                children: [
                  Container(
                    color: Colors.blue,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIndicator() => AnimatedSmoothIndicator(
        onDotClicked: animateToSlide,
        effect: const ExpandingDotsEffect(
            dotWidth: 15, activeDotColor: headerBackground),
        activeIndex: activeIndex,
        count: urlImages.length,
      );

  void animateToSlide(int index) => controller.animateToPage(index);

  Widget buildImage(String urlImage) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30), // Atur radius sesuai kebutuhan
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Image.network(urlImage, fit: BoxFit.cover),
        ],
      ),
    );
  }
}
