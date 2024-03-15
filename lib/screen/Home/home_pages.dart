import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:rsnaturopaty/widget/utils/Colors.dart';
import 'package:rsnaturopaty/widget/utils/CustomDialog.dart';
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

  List listImgSlider = [];

  final controller = CarouselController();

  @override
  void initState() {
    super.initState();

    getSharedPref();
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
        setState(() {
          listImgSlider = responseJson['content']['result'];
        });
        print(listImgSlider);
      } else {
        print("Get data failed with status code: ${response.statusCode}");
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
                    name,
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
                        const Column(
                          children: [
                            Text(
                              "Saldo Ku",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Rp 100.000",
                              style: TextStyle(
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
                                const Text(
                                  "100.000",
                                  style: TextStyle(
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
            const SizedBox(height: 20),
            // ?
            Container(
              color: Colors.amber,
              width: double.infinity,
              height: 200,
            ),
            Container(
              //color: Colors.cyan,
              margin: const EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  SizedBox(
                    //height: Get.height * 0.35,
                    width: double.infinity,
                    //color: Colors.pink,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 25),
                          height: 180,
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
                                  title: 'Dhasboard',
                                  icon: 'assets/icon/trend.png',
                                  onPressed: () {
                                    print("Dhasboard");
                                  },
                                ),
                                const SizedBox(width: 10),
                                WMenuKategori(
                                  title: 'Documentasi',
                                  icon: 'assets/icon/search-file.png',
                                  onPressed: () {
                                    print("Documentasi");
                                  },
                                ),
                                const SizedBox(width: 10),
                                WMenuKategori(
                                  title: 'Data Master',
                                  icon: 'assets/icon/Data_Master.png',
                                  onPressed: () {
                                    print("Data Master");
                                  },
                                ),
                                const SizedBox(width: 10),
                                WMenuKategori(
                                  title: 'Documentasi',
                                  icon: 'assets/icon/documentasi.png',
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
            SizedBox(
              height: MediaQuery.of(context).size.height - 200,
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
                          name,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
