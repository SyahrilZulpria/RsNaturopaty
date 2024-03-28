import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:rsnaturopaty/widget/utils/CustomDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryTransaction extends StatefulWidget {
  const HistoryTransaction({super.key});

  @override
  State<HistoryTransaction> createState() => _HistoryTransactionState();
}

class _HistoryTransactionState extends State<HistoryTransaction> {
  String token = "";
  List hasilTransaksi = [];
  int currentPage = 1;
  late int? totalPages;

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
          '{"limit":"10", "offset":"${(currentPage - 1) * 10}", "branch":"",  "confirm":"1", "paid":"1", "customer":"", "date":""}';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'History Transaction',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
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
            await getHasilTransaksi();
            refreshController.loadComplete();
          },
          child: ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: hasilTransaksi.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {},
                child: ListTile(
                  title: Text(hasilTransaksi[index]['package'].toString()),
                  subtitle: Text(hasilTransaksi[index]['created'].toString()),
                  trailing: Text(
                    hasilTransaksi[index]['amount'].toString(),
                    style: const TextStyle(color: Colors.green, fontSize: 15),
                  ),
                ),
              );
            },
          ),
        ));
  }
}
