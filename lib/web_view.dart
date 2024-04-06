import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:rsnaturopaty/screen/Product/ProductNew/TransactionCheckout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:rsnaturopaty/screen/Product/history_transaction.dart';
import 'package:rsnaturopaty/widget/utils/CustomDialog.dart';

class WebViewPage extends StatefulWidget {
  final String checkoutData;
  final String idTransaction;
  const WebViewPage(
      {super.key, required this.checkoutData, required this.idTransaction});

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late Timer _timer;
  String token = '';
  late Map<String, dynamic> transactionData = {};
  bool showIframe = true;
  html.IFrameElement? iframe;

  @override
  void initState() {
    super.initState();
    createIFrame();
    getSharedPref();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      getTransactionDetail();
    });
  }

  getSharedPref() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("token")!;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    // Remove the iframe when disposing the widget
    iframe?.remove();
  }

  getTransactionDetail() async {
    print("=========== Get Transaction Data ============");
    //print('${Endpoint.getTransactionDetail}$salesId');
    print(Endpoint.getTransactionDetail + widget.idTransaction);
    try {
      final response = await http.get(
          Uri.parse(Endpoint.getTransactionDetail + widget.idTransaction),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'X-auth-token': token,
          }).timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        print(responseJson);
        setState(() {
          transactionData = responseJson['content'];
        });
        print("==================");
        print(transactionData);
        print("======== Paid_Date ==========");
        print(transactionData['paid_date']);
        if (transactionData['paid_date'] != null &&
            transactionData['paid_date'] != "null") {
          // Jika paid_date terisi, navigasikan ke halaman TestingDataPost
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const TransactionCheckout(),
              //const HistoryTransaction(),
            ),
          );
          iframe?.remove();
          _timer.cancel(); // Hentikan timer setelah navigasi
        }
        print("=====================");
        print(transactionData);
      } else {
        print("Error getProductDetail status code: ${response.statusCode}");
      }
    } catch (e) {
      CustomDialog().warning(context, '', e.toString());
    }
  }

  void createIFrame() {
    // Create an iframe element
    iframe = html.IFrameElement()
      ..width = '400' // Adjust width
      ..height = '300' // Adjust height
      ..src = widget.checkoutData
          .toString(); // Provide the URL of the content to embed

    // Set position and style properties
    iframe!.style
      ..position = 'absolute'
      ..top = '0'
      ..left = '0'
      ..width = '100%'
      ..height = '100%'
      ..border = 'none';

    // Add the iframe to the HTML body
    html.document.body?.append(iframe!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Payment",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (showIframe)
              const HtmlElementView(
                viewType: 'iframeElement',
              ),
          ],
        ),
      ),
    );
  }
}
