import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:rsnaturopaty/login.dart';
import 'package:rsnaturopaty/screen/Product/ProductNew/checkout_view.dart';
import 'package:rsnaturopaty/widget/button_widget/ButtonOval.dart';
import 'package:rsnaturopaty/widget/utils/CustomDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailProduckPos extends StatefulWidget {
  const DetailProduckPos({
    super.key,
    required this.kodeProduct,
    required this.reg_id,
  });
  final String kodeProduct;
  final String reg_id;

  @override
  State<DetailProduckPos> createState() => _DetailProduckPosState();
}

class _DetailProduckPosState extends State<DetailProduckPos> {
  String token = "";
  String? salesId;

  String? selectedPayment;
  String idPayment = "";
  String namaPayment = "";
  String imgPayment = "";

  late Map<String, dynamic> productData = {};
  late Map<String, dynamic> transactionData = {};

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
      print("get product : ${response.statusCode}");
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        print(responseJson);
        setState(() {
          productData = json.decode(response.body)['content'];
        });
        print("========== Image ===========");
        print(productData['image'].toString());
      } else {
        print("Error getProductDetail status code: ${response.statusCode}");
      }
    } catch (e) {
      CustomDialog().warning(context, '', e.toString());
    }
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
      print("sales add : ${response.statusCode}");
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = json.decode(responseData);
        Map<String, dynamic> content = responseJson['content'];
        salesId = content['id'].toString();
        print("Sales ID: $salesId");

        await salesAddItem();
        // Update visibility

        // setState(() {
        //   showBuyButton = false;
        //   showPaymentSelection = true;
        // });
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

  salesAddItem() async {
    print("SalesAddItem");
    print('${Endpoint.salesAddItem}$salesId');
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${Endpoint.salesAddItem}$salesId'),
      );
      request.headers['X-auth-token'] = token;
      request.fields['cproduct'] = productData['sku'].toString();
      request.fields['ctax'] = '0';
      request.fields['tqty'] = '1';
      request.fields['tdiscount'] = '0';
      print("==================");
      print("========= Body Add Item ==========");
      print('Request Body: ${request.fields}');

      final response = await request.send();
      final responseData = await response.stream.transform(utf8.decoder).join();
      print("sales Add Item : ${response.statusCode}");
      if (response.statusCode == 200) {
        print('${response.statusCode}');
        final Map<String, dynamic> responseJson = json.decode(responseData);
        String content = responseJson['content'];
        print(content);
        //CustomDialog().warning(context, '', content);
        print("============== Item Add =================");
        print(responseJson);
      } else if (response.statusCode == 400) {
        print('${response.statusCode}');
        final Map<String, dynamic> errorJson = json.decode(responseData);
        String errorMessage = errorJson["error"];
        print(errorMessage);
        //CustomDialog().warning(context, '', errorMessage);
      } else {
        print("Error salesAddItem status code: ${response.statusCode}");
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
          "Product Detail",
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
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          ProductImagesHead(imageUrl: productData['image'].toString()),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.grey[400]),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      productData.isNotEmpty
                          ? productData['name'].toString().toUpperCase()
                          : 'Name Not Available',
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(
                  productData['description'].toString(),
                  style: const TextStyle(fontSize: 15, color: Colors.black),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Tooltip(
                      message: 'Add to Cart',
                      child: ButtonOval(
                        color: Colors.blue,
                        label: "Checkout",
                        onPressed: () async {
                          await salesAdd();
                          if (salesId != null && salesId!.isNotEmpty) {
                            showCheckout();
                          } else {
                            // Zeigen Sie eine Fehlermeldung an oder nehmen Sie eine andere Aktion vor, wenn salesId leer ist.
                            // Beispiel: ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sales ID is empty')));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void showCheckout() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return CheckoutView(salesId: salesId!);
      },
    );
  }
}

class ProductImagesHead extends StatelessWidget {
  const ProductImagesHead({
    super.key,
    required this.imageUrl,
  });
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: ImageProduct(
        imageUrl: imageUrl,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomTag(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  children: const [
                    SizedBox(width: 10),
                    Text(
                      "About AS",
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class ImageProduct extends StatelessWidget {
  const ImageProduct({
    super.key,
    //required this.height,
    this.borderRadius = 20,
    //required this.width,
    required this.imageUrl,
    this.padding,
    this.margin,
    this.child,
  });

  //final double width;
  //final double height;
  final String imageUrl;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double borderRadius;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
        ),
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
        children: children,
      ),
    );
  }
}
