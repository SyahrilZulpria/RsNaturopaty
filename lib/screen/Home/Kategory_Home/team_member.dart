import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberTeam extends StatefulWidget {
  const MemberTeam({super.key});

  @override
  State<MemberTeam> createState() => _MemberTeamState();
}

class _MemberTeamState extends State<MemberTeam> {
  String token = "";
  List listCustomer = [];
  Map<String, dynamic> customerData = {};

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
    getDataCustomer();
  }

  getDataCustomer() async {
    try {
      final response = await http
          .get(Uri.parse(Endpoint.getCustomer), headers: <String, String>{
        //'Content-Type': 'application/json',
        'X-auth-token': token,
      }).timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        print('status code: ${response.statusCode}');
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());

        final Map<String, dynamic> dataCustomer = responseJson['content'];
        print(dataCustomer);
        setState(() {
          listCustomer = [dataCustomer];
          customerData = responseJson['content'];
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          "Manage Team",
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
        automaticallyImplyLeading: false,
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
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Text(
                          "Team Overview",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Spacer()
                      ],
                    ),
                    const SizedBox(height: 20),
                    Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/manage_user.png"),
                                fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: (size.width - 20) * 0.6,
                          child: const Column(
                            children: [
                              Text(
                                "Number of registered team accounts",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 5),
                              Text(
                                "0",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Number of Members who purchased RS`N products today",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 5),
                              Text(
                                "0",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                "Total Number of Members who have purchased RS`N products",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                                maxLines: 2,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 5),
                              Text(
                                "0",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
