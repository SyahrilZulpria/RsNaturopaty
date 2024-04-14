import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:rsnaturopaty/widget/utils/CustomDialog.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPoint extends StatefulWidget {
  const HistoryPoint({super.key});

  @override
  State<HistoryPoint> createState() => _HistoryPointState();
}

class _HistoryPointState extends State<HistoryPoint> {
  String token = "";
  List customerPoint = [];
  //List historyPoint = [];
  List<dynamic>? historyPoint;
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
    getHistoryPoint();
  }

  getHistoryPoint() async {
    print(Endpoint.getPoint);
    try {
      setState(() {
        _isLoading = true;
      });
      var resBody = '{"limit": "100", "offset": "0"}';
      final response = await http
          .post(Uri.parse(Endpoint.getPoint),
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
        print("Point");
        print(balance);
        print("Point Content");
        print(content);
        setState(() {
          customerPoint = [balance.toString()];
          historyPoint = responseData['content']['result'];
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
          "History Point",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.purple,
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
                                customerPoint.isNotEmpty
                                    ? NumberFormat.decimalPattern()
                                        .format(int.parse(customerPoint.first))
                                    : "0",
                                style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 5),
                              const Divider(),
                              const Text(
                                "Point",
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
                child: historyPoint == null || historyPoint!.isEmpty
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
                        itemCount: historyPoint!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              ListTile(
                                title: Text(
                                  historyPoint![index]['code'].toString(),
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  historyPoint![index]['date'] ??
                                      ' '.toString() +
                                          historyPoint![index]['time'] ??
                                      ' '.toString(),
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: Text(
                                  NumberFormat.decimalPattern()
                                      .format(historyPoint![index]['amount']),
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
