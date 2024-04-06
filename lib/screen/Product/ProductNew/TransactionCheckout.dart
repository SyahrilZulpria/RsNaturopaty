import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:rsnaturopaty/screen/Product/ProductNew/checkout_view.dart';
import 'package:rsnaturopaty/screen/Product/ProductNew/pay_detail_view.dart';
import 'package:rsnaturopaty/screen/Product/ProductNew/sucsess_transaction.dart';
import 'package:rsnaturopaty/web_view.dart';
import 'package:rsnaturopaty/widget/utils/CustomDialog.dart';
import 'package:rsnaturopaty/widget/utils/NavBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionCheckout extends StatefulWidget {
  const TransactionCheckout({super.key});

  @override
  State<TransactionCheckout> createState() => _TransactionCheckoutState();
}

class _TransactionCheckoutState extends State<TransactionCheckout> {
  String token = "";
  List hasilTransaksi = [];
  int currentPage = 1;
  late int? totalPages;
  bool isLoading = false;

  final RefreshController refreshController =
      RefreshController(initialRefresh: true);

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
    getHasilTransaksi();
  }

  getHasilTransaksi({bool isRefresh = false}) async {
    print("===========================");
    print(Endpoint.getHistoryTransaction);
    if (isRefresh) {
      currentPage = 1;
    }
    try {
      var transaksiBody =
          '{"limit":"100", "offset":"${(currentPage - 1) * 10}", "branch":"",  "confirm":"", "paid":"", "customer":"", "date":""}';
      final response = await http
          .post(Uri.parse(Endpoint.getHistoryTransaction),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'X-auth-token': token,
              },
              body: transaksiBody)
          .timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        final transksi = responseJson['content'];
        print("============= Data Transaksi ============");
        print(transksi);
        print("============= Data Json ============");
        print(responseJson);
        setState(() {
          if (isRefresh) {
            hasilTransaksi.clear(); // Clear existing data when refreshing
          }
          hasilTransaksi.addAll(responseJson['content']['result']);
        });
        currentPage++;
        totalPages = (responseJson['content']['record'] / 10).ceil();
      } else {
        print(
            "Get data Hasil Transaction failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      CustomDialog().warning(context, '', e.toString());
    }
  }

  chackoutSales(String salesId) async {
    print("=========== Get Checkout Data ============");
    print('${Endpoint.checkoutProduct}$salesId');
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
        print(checkoutData);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewPage(
              checkoutData: urlCheckout,
              idTransaction: salesId,
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

  String getStatus(String posted, String paidStatus) {
    if (posted == "0" && paidStatus == "C") {
      return "Status: Waiting";
    } else if (posted == "1" && paidStatus == "C") {
      return "Status: Waiting Payment";
    } else if (posted == "1" && paidStatus == "S") {
      return "Status: Success";
    } else {
      return "";
    }
  }

  Color getStatusColor(String posted, String paidStatus) {
    if (posted == "0" && paidStatus == "C") {
      return Colors.red; // Jika status waiting, maka teks berwarna merah
    } else if (posted == "1" && paidStatus == "S") {
      return Colors.green; // Jika status success, maka teks berwarna hijau
    } else {
      return Colors.black; // Jika status lain, gunakan warna default
    }
  }

  void getActionButton(String posted, String paidStatus, int index) {
    if (posted == "0" && paidStatus == "C") {
      return
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 8),
          //   child: ElevatedButton(
          //     onPressed: () {
          handleCheckout(index);
      // print(hasilTransaksi[0]['id']);
      //     },
      //     style: ElevatedButton.styleFrom(
      //       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      //     ),
      //     child: const Text(
      //       'Checkout',
      //       style: TextStyle(fontSize: 12),
      //     ),
      //   ),
      // );
    } else if (posted == "1" && paidStatus == "C") {
      return
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 8),
          //   child: ElevatedButton(
          //     // onPressed: () {
          //     //   handlePay(index);
          //     // },
          //     onPressed: () {
          handlePay(index);
      // print(hasilTransaksi[0]['id']);
      //     },
      //     style: ElevatedButton.styleFrom(
      //       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      //     ),
      //     child: const Text(
      //       'Pay',
      //       style: TextStyle(fontSize: 12),
      //     ),
      //   ),
      // ); // Empty container if no action needed
    } else if (posted == "1" && paidStatus == "S") {
      return
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 8),
          //   child: ElevatedButton(
          //     onPressed: () {
          handleViewDetail(index);
      //     },
      //     style: ElevatedButton.styleFrom(
      //       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      //     ),
      //     child: const Text(
      //       'View',
      //       style: TextStyle(fontSize: 12),
      //     ),
      //   ),
      // ); // Empty container if no action needed
    }
  }

  void handleCheckout(int index) {
    setState(() {
      isLoading = true;
    });
    String salesId = hasilTransaksi[index]['id'].toString();
    print(salesId);
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return CheckoutView(salesId: salesId);
      },
    );
    setState(() {
      isLoading = false;
    });
  }

  void handlePay(int index) {
    setState(() {
      isLoading = true;
    });
    String salesId = hasilTransaksi[index]['id'].toString();
    print(salesId);
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return PayDetailView(salesId: salesId);
      },
    );
    setState(() {
      isLoading = false;
    });
  }

  void handleViewDetail(int index) {
    setState(() {
      isLoading = true;
    });
    String salesId = hasilTransaksi[index]['id'].toString();
    print(salesId);
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => SuccsesTransaction(
          salesId: salesId,
        ),
      ),
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'History Transaction',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => const NavCustomButton(),
              ),
            );
          },
        ),
        backgroundColor: Colors.purple,
      ),
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        onRefresh: () async {
          currentPage = 1; // Reset currentPage on refresh
          await getHasilTransaksi(isRefresh: true);
          refreshController.refreshCompleted();
        },
        onLoading: () async {
          if (currentPage <= totalPages!) {
            // Load more data if there are more pages to fetch
            await getHasilTransaksi();
            refreshController.loadComplete();
          } else {
            // No more pages to load, mark as completed
            refreshController.loadNoData();
          }
        },
        child: ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          itemCount: hasilTransaksi.length,
          itemBuilder: (context, index) {
            return SingleChildScrollView(
              // scrollDirection: Axis.horizontal,
              child: GestureDetector(
                onTap: () {
                  getActionButton(hasilTransaksi[index]['posted'],
                      hasilTransaksi[index]['paid_status'], index);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hasilTransaksi[index]['package'].toString(),
                            style: GoogleFonts.openSans(fontSize: 16),
                          ),
                          Text(
                            hasilTransaksi[index]['created'].toString(),
                            style: GoogleFonts.openSans(fontSize: 12),
                          ),
                          Text(
                            getStatus(
                              hasilTransaksi[index]['posted'],
                              hasilTransaksi[index]['paid_status'],
                            ),
                            style: GoogleFonts.openSans(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            NumberFormat.decimalPattern().format(
                              int.parse(
                                hasilTransaksi[index]['amount'].toString(),
                              ),
                            ),
                            style: GoogleFonts.openSans(
                                color: getStatusColor(
                                  hasilTransaksi[index]['posted'],
                                  hasilTransaksi[index]['paid_status'],
                                ),
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
