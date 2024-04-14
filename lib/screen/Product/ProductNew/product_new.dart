import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:http/http.dart' as http;
import 'package:rsnaturopaty/screen/Product/ProductNew/product_detail.dart';
import 'package:rsnaturopaty/widget/utils/CustomDialog.dart';

class ProductNew extends StatefulWidget {
  const ProductNew({super.key});

  @override
  State<ProductNew> createState() => _ProductNewState();
}

class _ProductNewState extends State<ProductNew> {
  List productList = [];

  @override
  void initState() {
    super.initState();
    getProdukList();
  }

  getProdukList() async {
    print(Endpoint.getProductList);
    try {
      var resBody =
          '{"limit": 30, "offset": 0, "orderby": "", "order": "asc", "pos":"0"}';
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
        centerTitle: true,
        automaticallyImplyLeading: false,
        //iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              //physics: const NeverScrollableScrollPhysics(),
              itemCount: productList.length,
              itemBuilder: (BuildContext context, int index) {
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
                                productList[index]['image'].toString(),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    productList[index]['name']
                                        .toString()
                                        .toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    NumberFormat.decimalPattern().format(
                                      int.parse(
                                        productList[index]['price'].toString(),
                                      ),
                                    ),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    productList[index]['shortdesc'],
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          CupertinoPageRoute(
                                            builder: (context) => ProductDetail(
                                              kodeProduct: productList[index]
                                                      ['sku']
                                                  .toString(),
                                              reg_id: productList[index]['id']
                                                  .toString(),
                                            ),
                                          ),
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
                                              "Detail",
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
