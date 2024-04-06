import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:rsnaturopaty/screen/Product/ProductNew/TransactionCheckout.dart';
import 'package:rsnaturopaty/screen/Product/ProductNew/checkout_row.dart';
import 'package:rsnaturopaty/web_view.dart';
import 'package:rsnaturopaty/widget/button_widget/ButtonOval.dart';
import 'package:rsnaturopaty/widget/utils/Colors.dart';
import 'package:rsnaturopaty/widget/utils/CustomDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({
    super.key,
    required this.salesId,
  });

  final String salesId;

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  String token = "";
  String? selectedPaymentMethod;
  List<String> paymentMethods = [];
  Map<String, dynamic> dataSales = {};
  List dataContentSales = [];
  bool isLoading = false;

  Future<void> _showLoadingWithDelay() async {
    // Menunggu 3 detik sebelum menampilkan data
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      isLoading = false; // Set isLoading to false after delay
    });
  }

  @override
  void initState() {
    super.initState();
    getSharedPref();
  }

  getSharedPref() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("token")!;
    });
    fetchPaymentMethods();
    _showLoadingWithDelay();
    salesGetData();
  }

  fetchPaymentMethods() async {
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
        Map<String, dynamic> responseData = json.decode(response.body);
        List<dynamic> result = responseData['content']['result'];
        setState(() {
          paymentMethods = result.map<String>((item) => item['name']).toList();
        });
      } else {
        // Jika panggilan API gagal, tangani kesalahan
        throw Exception(
            'Failed to load payment methods: ${response.statusCode}');
      }
    } catch (error) {
      // Handle error in API call
      print('Error fetching payment methods: $error');
    }
  }

  salesGetData() async {
    setState(() {
      isLoading = true; // Set isLoading true when fetching data
    });
    print(Endpoint.getTransactionDetail + widget.salesId);
    try {
      final response = await http.get(
        Uri.parse(Endpoint.getTransactionDetail + widget.salesId),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'X-auth-token': token,
        },
      ).timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        print('json print');
        print(responseData);
        print("==== data product ====");
        print(responseData['content']['items']);
        setState(() {
          dataSales = responseData['content'];
          dataContentSales = responseData['content']['items'];
        });
        print("======== Set state 1 =======");
        print(dataSales);
        print("======== Set state 2 =======");
        print(dataContentSales);
      } else {
        // Jika panggilan API gagal, tangani kesalahan
        throw Exception(
            'Failed to load payment methods: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Set isLoading false when error occurred
      });
      CustomDialog().warning(context, '', e.toString());
    }
  }

  salesUpdateItem() async {
    print("===================");
    print(paymentMethods);
    print("===================");
    print(selectedPaymentMethod);
    try {
      final response = await http.post(
          Uri.parse('${Endpoint.salesUpdate}/${widget.salesId}'),
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-auth-token': token,
          },
          body: {
            'cpayment':
                selectedPaymentMethod, //di get dari pemilihan data product
            'ccash': '0',
          }).timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        print(responseJson);
        //salesId = responseJson['content']['id'];
        CustomDialog().warning(context, '', responseJson["content"].toString());
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
    print('${Endpoint.checkoutProduct}${widget.salesId}');
    try {
      final response = await http.get(
          Uri.parse('${Endpoint.checkoutProduct}${widget.salesId}'),
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
        print(checkoutData);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewPage(
              checkoutData: urlCheckout,
              idTransaction: widget.salesId.toString(),
            ),
          ),
        );
      } else if (response.statusCode == 403) {
        print('${response.statusCode}');
        final Map<String, dynamic> errorJson =
            json.decode(response.body.toString());
        String errorMessage = errorJson["error"];
        CustomDialog().warning(context, '', errorMessage);
        await Future.delayed(const Duration(seconds: 5));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TransactionCheckout(),
          ),
        );
        //  print('Login failed: $errorMessage');110
        //  print('Login failed with status code: ${response.statusCode}');
      } else {
        print("Error Checkout status code: ${response.statusCode}");
      }
    } catch (e) {
      CustomDialog().warning(context, '', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: isLoading // Check if isLoading is true
          ? Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.blue),
              ),
            )
          : Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Checkout",
                          style: TextStyle(
                              color: Colors.purple,
                              fontSize: 28,
                              fontWeight: FontWeight.w700),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Image.asset(
                            "assets/close.png",
                            width: 15,
                            height: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.grey, height: 1),
                  CheckoutRowViwe(
                    title: "Product",
                    value: dataContentSales.isNotEmpty
                        ? dataContentSales[0]['product'].toString()
                        : '',
                  ),
                  const Divider(color: Colors.grey, height: 1),
                  CheckoutRowViwe(
                    title: "Total",
                    value: NumberFormat.decimalPattern().format(
                      int.parse(
                        dataSales['total'].toString(),
                      ),
                    ),
                  ),
                  const Divider(color: Colors.grey, height: 1),
                  CheckoutRowViwe(
                    title: "Tax",
                    value: NumberFormat.decimalPattern().format(
                      int.parse(
                        dataSales['tax'].toString(),
                      ),
                    ),
                  ),
                  const Divider(color: Colors.grey, height: 1),
                  CheckoutRowViwe(
                    title: "Discount",
                    value: dataSales['discount'].toString(),
                  ),
                  const Divider(color: Colors.grey, height: 1),
                  CheckoutRowViwe(
                    title: "Amount",
                    value: NumberFormat.decimalPattern().format(
                      int.parse(
                        dataSales['amount'].toString(),
                      ),
                    ),
                  ),
                  const Divider(color: Colors.grey, height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        const Text(
                          "Payment",
                          style: TextStyle(
                            color: darkGrey,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        DropdownButton<String>(
                          value: selectedPaymentMethod,
                          onChanged: (String? newValue) {
                            setState(
                              () {
                                selectedPaymentMethod = newValue;
                                print(selectedPaymentMethod);
                                salesUpdateItem();
                              },
                            );
                          },
                          items: paymentMethods.map<DropdownMenuItem<String>>(
                            (String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            },
                          ).toList(),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: Colors.grey, height: 1),
                  const SizedBox(height: 5),
                  RoundButton(
                    title: "Place Order",
                    onPressed: () {
                      chackoutSales();
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
