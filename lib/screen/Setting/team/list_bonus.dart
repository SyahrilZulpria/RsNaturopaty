import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:rsnaturopaty/screen/Setting/team/set_bonus.dart';
//import 'package:rsnaturopaty/widget/button_widget/ButtonOval.dart';
import 'package:rsnaturopaty/widget/utils/CustomDialog.dart';
import 'package:rsnaturopaty/widget/utils/NavBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListBonus extends StatefulWidget {
  const ListBonus({super.key});

  @override
  State<ListBonus> createState() => _ListBonusState();
}

class _ListBonusState extends State<ListBonus> {
  String token = '';
  List<dynamic>? bonusOrders;
  // List<dynamic> bonusOrders = [];
  //String? selectedBonus;

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
    getListBonus();
  }

  getListBonus() async {
    print("=========== Get Checkout Data ============");
    print(Endpoint.getListBonus);
    try {
      final response = await http
          .get(Uri.parse(Endpoint.getListBonus), headers: <String, String>{
        'Content-Type': 'application/json',
        'X-auth-token': token,
      }).timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        print(response.statusCode);
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        setState(() {
          bonusOrders = responseData['content']['result'];
        });
      } else if (response.statusCode == 403) {
        print('${response.statusCode}');
        final Map<String, dynamic> errorJson =
            json.decode(response.body.toString());
        String errorMessage = errorJson["error"];
        CustomDialog().warning(context, '', errorMessage);
      } else {
        print("Error Checkout status code: ${response.statusCode}");
      }
    } catch (e) {
      CustomDialog().warning(context, '', e.toString());
    }
  }

  String getStatus(String bonusType) {
    if (bonusType == "wallet" || bonusType == "point") {
      return "Successful set bonus";
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Set Bonus',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
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
      ),
      body: bonusOrders != null && bonusOrders!.isNotEmpty
          ? ListView.separated(
              itemCount: bonusOrders!.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final order = bonusOrders![index];
                return SingleChildScrollView(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order['customer'].toString(),
                              style: GoogleFonts.openSans(fontSize: 16),
                            ),
                            Text(
                              order['dates'].toString(),
                              style: GoogleFonts.openSans(fontSize: 16),
                            ),
                            Text(
                              getStatus(
                                order['bonus_type'] ??
                                    "No Set bonus yet".toString(),
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
                              order['amount'].toString(),
                              style: GoogleFonts.openSans(
                                  color: Colors.green,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(CupertinoPageRoute(
                                      builder: (context) => SetBonus(
                                          salesId: order['id'].toString())));
                                  //  pilihBonus(order['id'].toString());
                                  print(order['id'].toString());
                                },
                                child: const Text("set bonus"))
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : const Center(
              child: Text('Tidak Ada Transaksi'),
            ),
    );
  }
}
