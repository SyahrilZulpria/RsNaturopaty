import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:rsnaturopaty/login.dart';
import 'package:rsnaturopaty/screen/Home/Article_pages/discover_article_view.dart';
import 'package:rsnaturopaty/screen/Home/Article_pages/pages_article.dart';
import 'package:rsnaturopaty/screen/Home/Kategory_Home/about_as.dart';
import 'package:rsnaturopaty/screen/Home/Kategory_Home/announcement.dart';
import 'package:rsnaturopaty/screen/Home/Notification/page_notification.dart';
import 'package:rsnaturopaty/screen/Home/Kategory_Home/team_member.dart';
import 'package:rsnaturopaty/screen/Setting/profile/editProfile/editFotoProfile.dart';
import 'package:rsnaturopaty/screen/Setting/wallet_poiny/history_point.dart';
import 'package:rsnaturopaty/screen/Setting/wallet_poiny/history_wallet.dart';
import 'package:rsnaturopaty/widget/utils/Colors.dart';
import 'package:rsnaturopaty/widget/utils/CustomDialog.dart';
import 'package:rsnaturopaty/widget/utils/ImagesContainer.dart';
import 'package:rsnaturopaty/widget/widget_all/WSectionHeding.dart';
import 'package:rsnaturopaty/widget/widget_banner/SliderViewBanner.dart';
import 'package:rsnaturopaty/widget/widget_kategori/WMenuKategori.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
  List jumlahNotif = [];
  int activeIndex = 0;

  int _notificationCount = 0;

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
    await decodeToken();
    await saldoDompet();
    await saldoPoint();
    await getNotification();
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
        List<dynamic> imagesData = responseJson['content']['result'];
        setState(() {
          listImgSlider = imagesData
              .map((imageData) => imageData['image'].toString())
              .toList();
        });
        print("----- IMG ----------");
        print(listImgSlider.toString());
      } else {
        print("Get data failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      CustomDialog().warning(context, '', e.toString());
    }
  }

  decodeToken() async {
    print('========= Decode =========');
    print(Endpoint.decodeToken);
    try {
      final response = await http.post(
        Uri.parse(Endpoint.decodeToken),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'X-auth-token': token,
        },
      ).timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        print('decodeToken : ${response.statusCode}');
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        print(responseJson);
      }
    } catch (e) {
      CustomDialog().warning(context, '', e.toString());
    }
  }

  getNotification() async {
    print(Endpoint.getNotification);
    try {
      var notifBody =
          '{"type":"", "campaign":"", "read":"0", "limit":"50", "offset":"0"}';
      final response = await http
          .post(Uri.parse(Endpoint.getNotification),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'X-auth-token': token,
              },
              body: notifBody)
          .timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        print('getNotification : ${response.statusCode}');
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        setState(() {
          _notificationCount = responseJson['content'].length;
        });
        // print("============= TOTAL DATA ============");
        // print(_notificationCount);
      } else {
        print("Get data Notif failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      //CustomDialog().warning(context, '', e.toString());
    }
  }

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
        print('saldoPoint: ${response.statusCode}');
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        final Map<String, dynamic> content = responseJson['content'];
        final int balance = content['balance'];
        setState(() {
          listDompet = [balance.toString()];
        });
      } else {
        //CustomDialog().warning(context, '', 'Error: ${response.reasonPhrase}');
        print('Login failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      //CustomDialog().warning(context, '', e.toString());
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
        print('saldoPoint: ${response.statusCode}');
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        final Map<String, dynamic> content = responseJson['content'];
        final int balance = content['balance'];
        setState(() {
          listPoint = [balance.toString()];
        });
      } else {
        //CustomDialog().warning(context, '', 'Error: ${response.reasonPhrase}');
        print('Login failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      // CustomDialog().warning(context, '', e.toString());
    }
  }

  articlePermalink() async {
    print(Endpoint.categoryArticle);
    try {
      var resBody =
          '{ "category":27, "limit": 10, "offset": 0, "orderby": "", "order": "asc"}';
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
        final articlePromo = responseJson['content']['result'];
        print("========= Article Home ============");
        print(articlePromo);
        setState(() {
          listArticle = List.from(articlePromo);
        });
      } else {
        //CustomDialog().warning(context, '', 'Error: ${response.reasonPhrase}');
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
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications),
                color: Colors.white,
                onPressed: () {
                  if (_notificationCount != 0) {
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => const NotificationPages()));
                  } else {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const Login()));
                  }
                },
              ),
              _notificationCount != 0
                  ? Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: Text(
                          _notificationCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
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
                    "Hi, ",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    name = name.isNotEmpty
                        ? name[0].toUpperCase() + name.substring(1)
                        : "Guest",
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  top: 20, right: 20, left: 20, bottom: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade400, blurRadius: 3),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 15, right: 20, left: 20),
                child: Column(
                  children: [
                    // const Row(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     Icon(Icons.more_vert),
                    //   ],
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            print("Wallet");
                            if (listDompet.isNotEmpty) {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => const HistoryWallet(),
                                ),
                              );
                            } else {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => const Login(),
                                ),
                              );
                            }
                          },
                          child: Column(
                            children: [
                              const Text(
                                "Wallet",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                listDompet.isNotEmpty
                                    ? NumberFormat.decimalPattern()
                                        .format(int.parse(listDompet.first))
                                    : " 0",
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 0.5,
                          height: 40,
                          color: Colors.black,
                        ),
                        InkWell(
                          onTap: () {
                            print("Point");
                            if (listPoint.isNotEmpty) {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => const HistoryPoint(),
                                ),
                              );
                            } else {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => const Login(),
                                ),
                              );
                            }
                          },
                          child: Column(
                            children: [
                              const Text(
                                "Point",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/icons/reward.png", // Ganti dengan path gambar poin Anda
                                    width: 20,
                                    height: 20,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    listPoint.isNotEmpty
                                        ? NumberFormat.decimalPattern()
                                            .format(int.parse(listPoint.first))
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
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10),
              child: listImgSlider.isNotEmpty
                  ? SlideViewBanner(
                      banners: listImgSlider,
                    )
                  : const CircularProgressIndicator(),
            ),
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
                                  title: 'Team',
                                  icon: 'assets/icons/developers.png',
                                  onPressed: () {
                                    if (listDompet.isNotEmpty) {
                                      Navigator.of(context).push(
                                        CupertinoPageRoute(
                                          builder: (context) =>
                                              const MemberTeam(),
                                        ),
                                      );
                                      print("Team");
                                    } else {
                                      Navigator.of(context).push(
                                        CupertinoPageRoute(
                                          builder: (context) => const Login(),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(width: 10),
                                WMenuKategori(
                                  title: 'Announcement',
                                  icon: 'assets/icons/announcement.png',
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      CupertinoPageRoute(
                                        builder: (context) =>
                                            const AnnouncementPage(),
                                      ),
                                    );
                                    print("Announcement");
                                  },
                                ),
                                // const SizedBox(width: 10),
                                // WMenuKategori(
                                //   title: 'tes foto',
                                //   icon: 'assets/icons/announcement.png',
                                //   onPressed: () {
                                //     Navigator.of(context).push(
                                //       CupertinoPageRoute(
                                //         builder: (context) =>
                                //             const EditFotoProfile(),
                                //       ),
                                //     );
                                //     print("Announcement");
                                //   },
                                // ),
                                const SizedBox(width: 10),
                                WMenuKategori(
                                  title: 'About us',
                                  icon: 'assets/icons/letter-i.png',
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      CupertinoPageRoute(
                                        builder: (context) =>
                                            const AbaoutAsPage(),
                                      ),
                                    );
                                    print("Abaout US");
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
                  Navigator.of(context).push(CupertinoPageRoute(
                      builder: (context) => const ArticleDiscoverView()));
                  print("test");
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: listArticle.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: 250,
                    //MediaQuery.of(context).size.width * 0.5,
                    margin: const EdgeInsets.only(right: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => PagesArticle(
                              permaLink:
                                  listArticle[index]['permalink'].toString(),
                            ),
                          ),
                        );
                        print("Cek Article");
                        print(listArticle[index]['image'].toString());
                        print(listArticle[index]['permalink'].toString());
                        print("Cek Article");
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ImagesContainer(
                            width: 180,
                            height: 120,
                            imageUrl: listArticle[index]['image'].toString(),
                            borderRadius: 15,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            listArticle[index]['title'].toString(),
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            listArticle[index]['text'].toString(),
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700]),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                listArticle[index]['date'].toString(),
                                style: const TextStyle(
                                    fontSize: 8, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 5),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
