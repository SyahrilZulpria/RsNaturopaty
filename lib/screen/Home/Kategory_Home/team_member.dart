import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:rsnaturopaty/screen/Home/Kategory_Home/viewTreeReportMember.dart';
import 'package:rsnaturopaty/widget/utils/Colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MemberTeam extends StatefulWidget {
  const MemberTeam({super.key});

  @override
  State<MemberTeam> createState() => _MemberTeamState();
}

class _MemberTeamState extends State<MemberTeam> {
  String token = "";
  List listCustomer = [];
  Map<String, dynamic> customerData = {};
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
    getDataCustomer();
    _showLoadingWithDelay();
  }

  Future<void> _showLoadingWithDelay() async {
    // Menunggu 3 detik sebelum menampilkan data
    await Future.delayed(const Duration(seconds: 0));
    setState(() {
      isLoading = false; // Set isLoading to false after delay
    });
  }

  getDataCustomer() async {
    setState(() {
      isLoading = true;
    });
    print("=== Team Member ===");
    print("API");
    print(Endpoint.getCustomer);
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

        final Map<String, dynamic> dataCustomer =
            responseJson['content']['team'];
        print("Team Customer");
        print(dataCustomer);
        print("Costumer Json");
        print(responseJson['content']);
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
      body: isLoading
          ? Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.blue),
              ),
            )
          : SingleChildScrollView(
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
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              const Row(
                                children: [
                                  Text(
                                    "Team Overview",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
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
                                          image: AssetImage(
                                              "assets/images/manage_user.png"),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  SizedBox(
                                    width: (size.width - 20) * 0.6,
                                    child: Column(
                                      children: [
                                        const Text(
                                          "Number of registered team accounts",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          NumberFormat.decimalPattern().format(
                                            int.parse(
                                              customerData['team']
                                                      ['number_of_teams']
                                                  .toString(),
                                            ),
                                          ),
                                          style: const TextStyle(
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
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        const Text(
                                          "Number of Members who have not purchased RS`N products",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black),
                                          maxLines: 3,
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          NumberFormat.decimalPattern().format(
                                            int.parse(
                                              customerData['team']
                                                      ['failed_trans']
                                                  .toString(),
                                            ),
                                          ),
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 50),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        const Text(
                                          "Total Number of Members who have purchased RS`N products",
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black),
                                          maxLines: 3,
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          NumberFormat.decimalPattern().format(
                                            int.parse(
                                              customerData['team']
                                                      ['success_trans']
                                                  .toString(),
                                            ),
                                          ),
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              TextButton(
                                onPressed: () {
                                  String whatsappUrl = customerData['team']
                                          ['tree_chart']
                                      .toString();
                                  launch(whatsappUrl);
                                },
                                child: const Text("View In Browser"),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ViewTreeReportMember(
                                        urlMember: customerData['team']
                                                ['tree_chart']
                                            .toString(),
                                      ),
                                    ),
                                  );
                                  // Aksi yang ingin dilakukan saat tombol ditekan
                                }, // Teks tombol
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue),
                                child: const Text(
                                  'View Detail Member',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewTreeReportMember(
                            urlMember:
                                customerData['team']['tree_chart'].toString(),
                          ),
                        ),
                      );
                    }, // Teks tombol
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text(
                      'Get Bonus Member',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
