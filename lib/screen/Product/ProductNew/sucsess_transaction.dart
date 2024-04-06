import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:http/http.dart' as http;
import 'package:rsnaturopaty/widget/utils/CustomDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuccsesTransaction extends StatefulWidget {
  const SuccsesTransaction({super.key, required this.salesId});
  final String salesId;

  @override
  State<SuccsesTransaction> createState() => _SuccsesTransactionState();
}

class _SuccsesTransactionState extends State<SuccsesTransaction> {
  String token = "";
  Map<String, dynamic> dataSales = {};
  dynamic dataContentSales;
  // Map<String, dynamic> dataContentSales = {};
  // List dataContentSales = [];
  bool isLoading = false;

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
    _showLoadingWithDelay();
    salesGetData();
  }

  Future<void> _showLoadingWithDelay() async {
    // Menunggu 3 detik sebelum menampilkan data
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      isLoading = false;
    });
  }

  salesGetData() async {
    setState(() {
      isLoading = true;
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
        isLoading = false;
      });
      CustomDialog().warning(context, '', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          "Successful transaction",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: isLoading
          ? Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.blue),
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    size: 100,
                    color: Colors.green,
                  ),
                  const Text(
                    'Payment Successful!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            const Text(
                              "Jumlah Transaksi",
                              style: TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              NumberFormat.decimalPattern().format(
                                int.parse(
                                  dataSales['tot_amt'].toString(),
                                ),
                              ),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text(
                              "Product",
                              style: TextStyle(fontSize: 12),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              dataSales['items'][0]['product'].toString(),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Cost :"),
                        Text(
                          NumberFormat.decimalPattern().format(
                            int.parse(
                              dataSales['costs'].toString(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("DIscount :"),
                        Text(
                          dataSales['discount'].toString(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Total :"),
                        Text(
                          NumberFormat.decimalPattern().format(
                            int.parse(
                              dataSales['total'].toString(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Tanggal :"),
                        Text(dataSales['dates']),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
