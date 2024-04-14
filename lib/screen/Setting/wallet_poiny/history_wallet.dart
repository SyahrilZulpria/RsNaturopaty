import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:http/http.dart' as http;
import 'package:rsnaturopaty/widget/utils/CustomDialog.dart';
import 'package:rsnaturopaty/widget/utils/NavBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryWallet extends StatefulWidget {
  const HistoryWallet({super.key});

  @override
  State<HistoryWallet> createState() => _HistoryWalletState();
}

class _HistoryWalletState extends State<HistoryWallet> {
  String token = "";
  List customerWallet = [];
  //List historyWallet = [];
  List<dynamic>? historyWallet;
  bool _isLoading = false;

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
    getHistoryWallet();
  }

  getHistoryWallet() async {
    print(Endpoint.getDompet);
    try {
      setState(() {
        _isLoading = true;
      });
      var resBody = '{"limit": "100", "offset": "0"}';
      final response = await http
          .post(Uri.parse(Endpoint.getDompet),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'X-auth-token': token,
              },
              body: resBody)
          .timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
            json.decode(response.body.toString());
        final Map<String, dynamic> content = responseData['content'];
        final int balance = content['balance'];
        print("=========");
        print(content);
        print("=========");
        print(balance);
        setState(() {
          customerWallet = [balance.toString()];
          historyWallet = responseData['content']['result'];
          _isLoading = false;
        });
      }
    } catch (e) {
      CustomDialog().warning(context, '', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "History Wallet",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.purple,
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
              child: Column(
                children: [
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        SizedBox(
                          width: (size.width - 20) * 0.6,
                          child: Column(
                            children: [
                              Text(
                                customerWallet.isNotEmpty
                                    ? NumberFormat.decimalPattern()
                                        .format(int.parse(customerWallet.first))
                                    : "0",
                                style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 5),
                              const Divider(),
                              const Text(
                                "Wallet",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 5,
              color: Colors.grey,
            ),
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade400, blurRadius: 3),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  print("object");
                },
                child: historyWallet == null || historyWallet!.isEmpty
                    ? const Center(
                        child: Text(
                          'No transactions',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: historyWallet!.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              ListTile(
                                title: Text(
                                  historyWallet![index]['code'].toString(),
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  historyWallet![index]['date'].toString() +
                                      historyWallet![index]['time'].toString(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: Text(
                                  NumberFormat.decimalPattern().format(
                                    historyWallet![index]['amount'],
                                  ),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const Divider(),
                            ],
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
