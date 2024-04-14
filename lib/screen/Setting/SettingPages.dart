import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:rsnaturopaty/login.dart';
import 'package:rsnaturopaty/screen/Home/Kategory_Home/team_member.dart';
import 'package:rsnaturopaty/screen/MembersAdd/AddMamber.dart';
import 'package:rsnaturopaty/screen/MembersAdd/AddMemberSettings.dart';
import 'package:rsnaturopaty/screen/Product/PosProduct/productposview.dart';
import 'package:rsnaturopaty/screen/Product/ProductNew/TransactionCheckout.dart';
import 'package:rsnaturopaty/screen/Setting/bank/pilihBank.dart';
import 'package:rsnaturopaty/screen/Setting/profile/profile_pages.dart';
import 'package:rsnaturopaty/screen/Setting/redeem/newRedeem.dart';
import 'package:rsnaturopaty/screen/Setting/team/list_bonus.dart';
import 'package:rsnaturopaty/screen/Setting/wallet_poiny/history_point.dart';
import 'package:rsnaturopaty/screen/Setting/wallet_poiny/history_wallet.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:rsnaturopaty/screen/Setting/wallet_poiny/history_point.dart';
//import 'package:rsnaturopaty/screen/Setting/wallet_poiny/history_wallet.dart';
import 'package:rsnaturopaty/widget/button_widget/IconSettingPages.dart';
import 'package:rsnaturopaty/widget/utils/Colors.dart';
import 'package:rsnaturopaty/widget/utils/CustomDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SettingPages extends StatefulWidget {
  const SettingPages({super.key});
  @override
  State<SettingPages> createState() => _SettingPagesState();
}

class _SettingPagesState extends State<SettingPages> {
  String token = "";
  String userId = "";
  String name = "";
  String email = "";
  String noPhone = "";
  String log = "";

  List listDompet = [];
  List listPoint = [];
  List listCustomer = [];

  @override
  void initState() {
    super.initState();
    getSharedPref();
  }

  getSharedPref() async {
    final sp = await SharedPreferences.getInstance();

    setState(() {
      token = sp.getString("token")!;
      userId = sp.getString("userId")!;
      name = sp.getString("name")!;
      email = sp.getString("email")!;
      noPhone = sp.getString("noPhone")!;
      log = sp.getString("log")!;
    });
    //decodeToken();
    saldoDompet();
    saldoPoint();
    getDataCustomer();
  }

  // decodeToken() async {
  //   print("--- Page Setting ----");
  //   print(Endpoint.decodeToken);
  //   try {
  //     final response = await http.post(
  //       Uri.parse(Endpoint.decodeToken),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //         'X-auth-token': token,
  //       },
  //     ).timeout(const Duration(seconds: 60));

  //     if (response.statusCode != 200) {
  //       print("gagal login : ${response.statusCode}");
  //       Navigator.of(context)
  //           .push(MaterialPageRoute(builder: (context) => const Login()));
  //       // final Map<String, dynamic> responseJson =
  //       //     json.decode(response.body.toString());
  //       // print(responseJson);
  //     } else {
  //       print("Suksess Login: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     CustomDialog().warning(context, '', e.toString());
  //   }
  // }

  getDataCustomer() async {
    try {
      final response = await http
          .get(Uri.parse(Endpoint.getCustomer), headers: <String, String>{
        //'Content-Type': 'application/json',
        'X-auth-token': token,
      }).timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        // print('status code: ${response.statusCode}');
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());

        final Map<String, dynamic> dataCustomer = responseJson['content'];
        // print(dataCustomer);
        setState(() {
          listCustomer = [dataCustomer];
        });
        // print("============Hasil Get data listCustomer===========");
        // print(listCustomer);
      } else {
        //CustomDialog().warning(context, '', 'Error: ${response.reasonPhrase}');
        print('Login failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      //CustomDialog().warning(context, '', e.toString());
    }
  }

  saldoDompet() async {
    print(Endpoint.getDompet);
    try {
      var resBody = '{"limit":"100", "offset": "0"}';
      final response = await http
          .post(Uri.parse(Endpoint.getDompet),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'X-auth-token': token,
              },
              body: resBody)
          .timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        //  print(responseJson);
        //List<dynamic> dataDompet = responseJson['content'];
        final Map<String, dynamic> content = responseJson['content'];
        final int balance = content['balance'];
        setState(() {
          listDompet = [balance.toString()];
        });
        //  print("============Hasil Get data===========");
        //  print(listDompet);
        //  print("========================");
      } else {
        //CustomDialog().warning(context, '', 'Error: ${response.reasonPhrase}');
        print('Login failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      //CustomDialog().warning(context, '', e.toString());
    }
  }

  saldoPoint() async {
    print(Endpoint.getDompet);
    try {
      var resBody = '{"limit":"100", "offset": "0"}';
      final response = await http
          .post(Uri.parse(Endpoint.getPoint),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'X-auth-token': token,
              },
              body: resBody)
          .timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        //  print(responseJson);
        // List<dynamic> dataDompet = responseJson['content'];
        final Map<String, dynamic> content = responseJson['content'];
        final int balance = content['balance'];
        setState(() {
          listPoint = [balance.toString()];
        });
        //  print("============Hasil Get data===========");
        //  print(listPoint);
        //  print("========================");
      } else {
        // CustomDialog().warning(context, '', 'Error: ${response.reasonPhrase}');
        print('Login failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      // CustomDialog().warning(context, '', e.toString());
    }
  }

  logOutApi() async {
    print(token);
    try {
      final response = await http.get(
        Uri.parse(Endpoint.logOut),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'X-auth-token': token,
        },
      ).timeout(const Duration(seconds: 60));

      if (response.statusCode == 200) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        print(responseJson);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
          (Route<dynamic> route) => false,
        );
      } else if (response.statusCode == 400) {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        String errorMessage = errorJson["error"];
        CustomDialog().warning(context, '', errorMessage);
        print('Logout failed: $errorMessage');
        print('Logout failed with status code: ${response.statusCode}');
      } else {
        //CustomDialog().warning(context, '', 'Error: ${response.reasonPhrase}');
        print('Logout failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Setting",
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
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
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 15, right: 20, left: 20),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: listCustomer.isNotEmpty &&
                                        listCustomer[0]['image'] != null
                                    ? NetworkImage(listCustomer[0]['image'])
                                    : const AssetImage(
                                            'assets/images/nophoto.jpg')
                                        as ImageProvider,
                                fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: (size.width - 20) * 0.6,
                          child: Column(
                            children: [
                              Text(
                                name = name.isNotEmpty
                                    ? name[0].toUpperCase() + name.substring(1)
                                    : "Guest",
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                listCustomer[0]['type'] ?? "-",
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            print("Wallet");
                            if (listDompet.isNotEmpty) {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => const HistoryWallet(),
                                ),
                              );
                            } else {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => const Login(),
                                ),
                              );
                            }
                          },
                          child: Column(
                            children: [
                              const Text(
                                "Wallet",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                listDompet.isNotEmpty
                                    ? NumberFormat.decimalPattern()
                                        .format(int.parse(listDompet.first))
                                    : " 0",
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 0.5,
                          height: 40,
                          color: Colors.black,
                        ),
                        InkWell(
                          onTap: () {
                            print("Point");
                            if (listPoint.isNotEmpty) {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => const HistoryPoint(),
                                ),
                              );
                            } else {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => const Login(),
                                ),
                              );
                            }
                          },
                          child: Column(
                            children: [
                              const Text(
                                "Point",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/icons/reward.png",
                                    width: 20,
                                    height: 20,
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    listPoint.isNotEmpty
                                        ? NumberFormat.decimalPattern()
                                            .format(int.parse(listPoint.first))
                                        : " 0",
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(height: 5, color: Colors.grey),
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
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "My Team",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Divider(color: Colors.black),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        WIconSetting(
                          title: "Invite Friends",
                          color: Colors.orange,
                          icon: CupertinoIcons.person_add_solid,
                          onTap: () {
                            if (listCustomer.isNotEmpty &&
                                listCustomer[0]['image'] != null) {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      const AddMembersSeting(),
                                ),
                              );
                            } else {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => const Login(),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    WIconSetting(
                      title: "Team Report",
                      color: Colors.green,
                      icon: CupertinoIcons.person_3_fill,
                      onTap: () {
                        if (listCustomer.isNotEmpty &&
                            listCustomer[0]['image'] != null) {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => const MemberTeam(),
                            ),
                          );
                        } else {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => const Login(),
                            ),
                          );
                        }
                      },
                    ),
                    WIconSetting(
                      title: "Set Bonus",
                      color: Colors.deepPurple,
                      icon: CupertinoIcons.star_circle,
                      onTap: () {
                        if (listCustomer.isNotEmpty &&
                            listCustomer[0]['image'] != null) {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => const ListBonus(),
                            ),
                          );
                        } else {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => const Login(),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "POS",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Divider(color: Colors.black),
                    const SizedBox(height: 10),
                    WIconSetting(
                      title: "Product",
                      color: Colors.orange,
                      icon: CupertinoIcons.archivebox,
                      onTap: () {
                        if (listCustomer.isNotEmpty &&
                            listCustomer[0]['image'] != null) {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => const ProductPosNew(),
                            ),
                          );
                        } else {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => const Login(),
                            ),
                          );
                        }
                      },
                    ),
                    WIconSetting(
                      title: "History",
                      color: Colors.green,
                      icon: CupertinoIcons.doc_checkmark,
                      onTap: () {
                        if (listCustomer.isNotEmpty &&
                            listCustomer[0]['image'] != null) {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => const ListBonus(),
                            ),
                          );
                        } else {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => const Login(),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Settings",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Divider(color: Colors.black),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        WIconSetting(
                          title: "My Profile",
                          color: Colors.amber,
                          icon: CupertinoIcons.person_alt_circle_fill,
                          onTap: () {
                            if (listCustomer.isNotEmpty &&
                                listCustomer[0]['image'] != null) {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => const ProfilePage(),
                                ),
                              );
                            } else {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => const Login(),
                                ),
                              );
                            }
                          },
                        ),
                        WIconSetting(
                          title: "Reedem",
                          color: Colors.green,
                          icon: CupertinoIcons.archivebox,
                          onTap: () {
                            if (listCustomer.isNotEmpty &&
                                listCustomer[0]['image'] != null) {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => const NewRedeem(),
                                ),
                              );
                            } else {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => const Login(),
                                ),
                              );
                            }
                          },
                        ),
                        WIconSetting(
                          title: "History Transaction",
                          color: Colors.blue,
                          icon: CupertinoIcons.doc_checkmark,
                          onTap: () {
                            if (listCustomer.isNotEmpty &&
                                listCustomer[0]['image'] != null) {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      //const HistoryTransaction(),
                                      const TransactionCheckout(),
                                ),
                              );
                            } else {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => const Login(),
                                ),
                              );
                            }
                          },
                        ),
                        WIconSetting(
                          title: "Bank Account",
                          color: Colors.brown,
                          icon: Icons.account_balance,
                          onTap: () {
                            if (listCustomer.isNotEmpty &&
                                listCustomer[0]['image'] != null) {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => PilihBankPages(
                                    data: listCustomer[0],
                                  ),
                                ),
                              );
                            } else {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => const Login(),
                                ),
                              );
                            }
                          },
                        ),
                        WIconSetting(
                          title: "Contact Information",
                          color: Colors.cyan,
                          icon: CupertinoIcons.phone_circle_fill,
                          onTap: () {
                            String whatsappUrl =
                                "https://wa.me/689685517574?text=Hallo,%20Rumah%20Sehat%20Naturopaty%20";
                            launch(whatsappUrl);
                          },
                        ),
                        WIconSetting(
                          title: "LogOut",
                          color: Colors.red,
                          icon: CupertinoIcons.ellipsis_vertical_circle_fill,
                          onTap: () {
                            if (listCustomer.isNotEmpty &&
                                listCustomer[0]['image'] != null) {
                              alertLogout(context);
                            } else {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => const Login(),
                                ),
                              );
                            }
                          },
                        ),
                      ],
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

  void alertLogout(BuildContext context) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text("Yakin ingin keluar?",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              )),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text("Tidak",
                  style: TextStyle(
                    fontSize: 16,
                    color: headerBackground,
                  )),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoDialogAction(
              child: const Text("Ya",
                  style: TextStyle(
                    fontSize: 16,
                    color: headerBackground,
                  )),
              onPressed: () => logOutApi(),
            ),
          ],
        );
      },
    );
  }
}
