import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:rsnaturopaty/login.dart';
import 'package:rsnaturopaty/web_view.dart';
import 'package:rsnaturopaty/widget/utils/Colors.dart';
import 'package:rsnaturopaty/widget/utils/CustomDialog.dart';
import 'package:rsnaturopaty/widget/widget_all/WSectionHeding.dart';
import 'package:http/http.dart' as http;
import 'package:search_choices/search_choices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailPages extends StatefulWidget {
  const ProductDetailPages(
      {super.key, required this.kodeProduct, required this.reg_id});

  final String kodeProduct;
  final String reg_id;

  @override
  State<ProductDetailPages> createState() => _ProductDetailPagesState();
}

class _ProductDetailPagesState extends State<ProductDetailPages> {
  String token = '';
  String? salesId;

  List responseAdd = [];
  List responseItemAdd = [];
  List<Map<String, dynamic>> listPayment = [];
  // List transactionData = [];

  String? selectedPayment;
  String idPayment = "";
  String namaPayment = "";
  String imgPayment = "";

  late Map<String, dynamic> productData = {};
  late Map<String, dynamic> transactionData = {};
  late Map<String, dynamic> checkout = {};

  bool showBuyButton = true;
  bool showPaymentSelection = false;
  bool showTransactionDetails = false;

  @override
  void initState() {
    super.initState();
    getSharedPref();
    getProductDetail();
  }

  getSharedPref() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("token")!;
    });
    getPaymentType();
    getTransactionDetail();
  }

  salesAdd() async {
    print("Sales Add");
    print(Endpoint.createdSalesAdd);
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(Endpoint.createdSalesAdd),
      );
      request.headers['X-auth-token'] = token;
      request.fields['ccash'] = '0';
      final response = await request.send();
      final responseData = await response.stream.transform(utf8.decoder).join();
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = json.decode(responseData);
        Map<String, dynamic> content = responseJson['content'];
        salesId = content['id'].toString();
        print("Sales ID: $salesId");

        await salesAddItem();
        // Update visibility
        setState(() {
          showBuyButton = false;
          showPaymentSelection = true;
        });
      } else if (response.statusCode == 400) {
        final Map<String, dynamic> errorJson = json.decode(responseData);
        String errorMessage = errorJson["error"];
        CustomDialog().warning(context, '', errorMessage);
      } else if (response.statusCode == 401) {
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => const Login(),
          ),
        );
      } else {
        print("Error salesAdd status code: ${response.statusCode}");
      }
    } catch (e) {
      CustomDialog().warning(context, '', e.toString());
    }
  }

  getProductDetail() async {
    print("=========== Get Product ============");
    print('${Endpoint.getProductDetail}${widget.kodeProduct}/${widget.reg_id}');
    try {
      final response = await http.get(
          Uri.parse(
              '${Endpoint.getProductDetail}${widget.kodeProduct}/${widget.reg_id}'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'X-auth-token': 'X-auth-token',
          }).timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        print(responseJson);
        setState(() {
          productData = json.decode(response.body)['content'];
        });
        print("=====================");
        print(productData);
      } else {
        print("Error getProductDetail status code: ${response.statusCode}");
      }
    } catch (e) {
      CustomDialog().warning(context, '', e.toString());
    }
  }

  getTransactionDetail() async {
    print("=========== Get Transaction Data ============");
    //print('${Endpoint.getTransactionDetail}$salesId');
    print('${Endpoint.getTransactionDetail}32');
    try {
      final response = await http.get(
          Uri.parse('${Endpoint.getTransactionDetail}$salesId'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'X-auth-token': token,
          }).timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        print(responseJson);
        setState(() {
          transactionData = json.decode(response.body)['content'];
        });
        print("=====================");
        print(transactionData);
      } else {
        print("Error getTransactionDetail status code: ${response.statusCode}");
      }
    } catch (e) {
      CustomDialog().warning(context, '', e.toString());
    }
  }

  salesAddItem() async {
    print("SalesAddItem");
    print('${Endpoint.salesAddItem}$salesId');
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${Endpoint.salesAddItem}$salesId'),
      );
      request.headers['X-auth-token'] = token;
      request.fields['cproduct'] =
          productData['sku'].toString(); //di get dari pemilihan data product
      request.fields['ctax'] = '0';
      request.fields['tqty'] = '1';
      request.fields['tdiscount'] = '0';
      print("==================");
      print("========= Body Add Item ==========");
      print('Request Body: ${request.fields}');

      final response = await request.send();
      final responseData = await response.stream.transform(utf8.decoder).join();
      if (response.statusCode == 200) {
        print('${response.statusCode}');
        final Map<String, dynamic> responseJson = json.decode(responseData);
        String content = responseJson['content'];
        print(content);
        CustomDialog().warning(context, '', content);
        print("============== Item Add =================");
        print(responseJson);
      } else if (response.statusCode == 400) {
        print('${response.statusCode}');
        final Map<String, dynamic> errorJson = json.decode(responseData);
        String errorMessage = errorJson["error"];
        CustomDialog().warning(context, '', errorMessage);
      } else {
        print("Error salesAddItem status code: ${response.statusCode}");
      }
    } catch (e) {
      CustomDialog().warning(context, '', e.toString());
    }
  }

  salesUpdateItem() async {
    print("===================");
    print(namaPayment);
    try {
      final response = await http.post(
          Uri.parse('${Endpoint.salesUpdate}/$salesId'),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-auth-token': token,
          },
          body: {
            'cpayment': namaPayment, //di get dari pemilihan data product
            'ccash': '0',
          }).timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        print(responseJson);
        //salesId = responseJson['content']['id'];
        CustomDialog().warning(context, '', responseJson["content"].toString());
        setState(() {
          showPaymentSelection = false;
          showTransactionDetails = true;
        });
      } else {
        print("Error salesUpdateItem status code: ${response.statusCode}");
        final Map<String, dynamic> errorJson =
            json.decode(response.body.toString());
        String errorMessage = errorJson["error"];
        CustomDialog().warning(context, '', errorMessage);
      }
    } catch (e) {
      CustomDialog().warning(context, '', e.toString());
    }
  }

  chackoutSales() async {
    print("=========== Get Checkout Data ============");
    try {
      final response = await http.get(
          Uri.parse('${Endpoint.checkoutProduct}$salesId'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'X-auth-token': token,
          }).timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        print(response.statusCode);
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        final String urlCheckout = responseJson['content']['invoice_url'];
        print("=========== Checkout Body ==========");
        print(responseJson);
        print("=========== Checkout Content ==========");
        print(responseJson['content']);
        print("=========== Checkout ==========");
        print(urlCheckout);
        final Map<String, dynamic> checkoutData = {
          'url': urlCheckout,
        };
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewPage(
              checkoutData: urlCheckout,
              idTransaction: salesId.toString(),
            ),
          ),
        );
      } else if (response.statusCode == 403) {
        print('${response.statusCode}');
        final Map<String, dynamic> errorJson =
            json.decode(response.body.toString());
        String errorMessage = errorJson["error"];
        CustomDialog().warning(context, '', errorMessage);
        //  print('Login failed: $errorMessage');
        //  print('Login failed with status code: ${response.statusCode}');
      } else {
        print("Error Checkout status code: ${response.statusCode}");
      }
    } catch (e) {
      CustomDialog().warning(context, '', e.toString());
    }
  }

  getPaymentType() async {
    print("========= Get Payment =============");
    print(Endpoint.getPaymentType);
    try {
      final response = await http.get(
        Uri.parse(Endpoint.getPaymentType),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'X-auth-token': token,
        },
      ).timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = json.decode(response.body);
        print(responseJson);
        setState(() {
          listPayment = List<Map<String, dynamic>>.from(
            responseJson['content']['result'].map((pay) =>
                {'id': pay['id'], 'name': pay['name'], 'image': pay['image']}),
          );
        });
        print("==================");
        print(listPayment);
      } else if (response.statusCode == 401) {
        print('Login failed with : Unauthorized access');
      } else if (response.statusCode == 403) {
        CustomDialog()
            .expiredTokens(context, 'Token Expired', "Harap Login Kembali!");
      } else {
        print("Error getPaymentType status code: ${response.statusCode}");
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
          "Product Detail",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 400,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: Image(
                    image: NetworkImage('assets/product/psychedelic_grape.png'),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [BoxShadow(color: decColors)]),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            //"Psychedelic Water"
                            productData.isNotEmpty
                                ? productData['name'].toString().toUpperCase()
                                : 'Name Not Available',
                            style: GoogleFonts.getFont(
                              'Source Sans 3', // Ganti dengan nama font Google yang Anda inginkan
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            productData.isNotEmpty
                                ? NumberFormat.currency(
                                    locale: 'id',
                                    symbol: 'Rp',
                                  ).format(productData['price'])
                                : 'Price Not Available',
                            style: GoogleFonts.getFont(
                              'Source Sans 3', // Ganti dengan nama font Google yang Anda inginkan
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        const WSectionHeding(
                            title: 'Description', showActionButton: false),
                        const SizedBox(height: 5),
                        ReadMoreText(
                          productData['description'] ??
                              'Description Not Available'.toString(),
                          trimLines: 3,
                          trimMode: TrimMode.Line,
                          trimCollapsedText: ' Show more',
                          trimExpandedText: 'Less',
                          moreStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w800),
                          lessStyle: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Visibility(
                visible: showBuyButton,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () async {
                      await salesAdd();
                    },
                    child: const Text(
                      'Buy',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: showPaymentSelection,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Type Payment",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: formBorder)),
                                child: SearchChoices.single(
                                  underline: const SizedBox(
                                    height: 0,
                                  ),
                                  displayClearIcon: false,
                                  closeButton: "Tutup",
                                  isExpanded: true,
                                  iconSize: 25,
                                  padding:
                                      const EdgeInsets.only(right: 5, left: 10),
                                  value: selectedPayment,
                                  items: listPayment.map((item) {
                                    return DropdownMenuItem(
                                        value: "${item['id']}-${item['name']}",
                                        child: Row(
                                          children: [
                                            Text(
                                              item['name'],
                                              style: const TextStyle(
                                                  fontSize: 16.0),
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          ],
                                        ));
                                  }).toList(),
                                  hint: const Text(
                                    "Select Payment",
                                    style: TextStyle(color: Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  searchHint: "Select Payment",
                                  onChanged: (newVal) async {
                                    FocusScope.of(context).requestFocus(
                                        FocusNode()); // <--- add this biar ga balik fokus ke textfield
                                    setState(() {
                                      selectedPayment = newVal;

                                      if (newVal != null) {
                                        idPayment = newVal.split('-')[0];
                                        namaPayment = newVal.split('-')[1];
                                        print("name $namaPayment");
                                      }
                                    }); //await salesUpdateItem();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () async {
                          await salesUpdateItem();
                        },
                        child: const Text(
                          'Save Type Payment',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Visibility(
                visible: showTransactionDetails,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [BoxShadow(color: decColors)]),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Your Transaction Details",
                              style: GoogleFonts.getFont(
                                'Source Sans 3', // Ganti dengan nama font Google yang Anda inginkan
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Costs : ${transactionData['costs'].toString()}",
                              style: GoogleFonts.getFont(
                                'Source Sans 3', // Ganti dengan nama font Google yang Anda inginkan
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Amount : ${transactionData['amount'].toString()}",
                              style: GoogleFonts.getFont(
                                'Source Sans 3', // Ganti dengan nama font Google yang Anda inginkan
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Payment type : ${transactionData['payment_type'].toString()}",
                              style: GoogleFonts.getFont(
                                'Source Sans 3', // Ganti dengan nama font Google yang Anda inginkan
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () async {
                            await chackoutSales();
                          },
                          child: const Text(
                            'Checkout',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
