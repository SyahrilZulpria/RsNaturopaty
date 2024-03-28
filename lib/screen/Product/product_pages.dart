import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:rsnaturopaty/screen/Product/detail_product.dart';
//import 'package:rsnaturopaty/screen/Product/product_detail_pages.dart';
import 'package:rsnaturopaty/widget/utils/Colors.dart';
import 'package:http/http.dart' as http;
import 'package:rsnaturopaty/widget/utils/CustomDialog.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class ProductPages extends StatefulWidget {
  const ProductPages({super.key});

  @override
  State<ProductPages> createState() => _ProductPagesState();
}

class _ProductPagesState extends State<ProductPages> {
  List productList = [];

  @override
  void initState() {
    super.initState();
    getProdukList();
  }

  // getSharedPref() async {
  //   final sp = await SharedPreferences.getInstance();

  //   setState(() {});

  //   getProdukList();
  // }

  getProdukList() async {
    print(Endpoint.getProductList);
    try {
      var resBody =
          '{ "limit": 30, "offset": 0, "orderby": "", "order": "asc", "pos":"0"}';
      final response = await http
          .post(Uri.parse(Endpoint.getProductList),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'X-auth-token': 'X-auth-token',
              },
              body: resBody)
          .timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        //print(responseJson);
        //List<dynamic> content = responseJson['content']['result'];
        setState(() {
          productList = responseJson['content']['result'];
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
        title: const Text(
          "Store",
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Product RS NATUROPATY',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: productList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) => ProductDetailPages(
                                kodeProduct:
                                    productList[index]['sku'].toString(),
                                reg_id: productList[index]['id'].toString(),
                              )));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(color: shadow, blurRadius: 0.5),
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            //mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    //'/assets/images/Indonesia_map.png',
                                    productList[index]['image'].toString(),
                                    //width: 60,
                                    //height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      productList[index]['name']
                                          .toString()
                                          .toUpperCase(),
                                      style: GoogleFonts.getFont(
                                        'Source Sans 3', // Ganti dengan nama font Google yang Anda inginkan
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      productList[index]['shortdesc']
                                          .toString(),
                                      style: GoogleFonts.getFont(
                                        'Source Sans 3', // Ganti dengan nama font Google yang Anda inginkan
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    // Text(
                                    //   "Shortdesc : ${productList[index]['shortdesc']}",
                                    //   style: const TextStyle(
                                    //     fontWeight: FontWeight.bold,
                                    //     fontSize: 12,
                                    //   ),
                                    //   maxLines: 2,
                                    //   overflow: TextOverflow.ellipsis,
                                    // ),
                                    const SizedBox(height: 5),
                                    Text(
                                      //"Price : ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp').format(productList[index]['price'])}",
                                      NumberFormat.currency(
                                              locale: 'id_ID', symbol: 'Rp')
                                          .format(productList[index]['price']),
                                      style: GoogleFonts.getFont(
                                        'Source Sans 3', // Ganti dengan nama font Google yang Anda inginkan
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
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
                })
          ],
        ),
      ),
    );
  }
}
