import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:rsnaturopaty/widget/utils/Colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMembers extends StatefulWidget {
  const AddMembers({super.key});

  @override
  State<AddMembers> createState() => _AddMembersState();
}

class _AddMembersState extends State<AddMembers> {
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
    // var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          "Invite Friends",
          style: TextStyle(color: Colors.white),
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
                          "Roles Invite Friends",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Spacer()
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          const Text(
                            "Undang teman untuk bergabung, anda akan mendapat komisi tinggi.",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 10),
                          const Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "> ",
                                  style: TextStyle(
                                    color: Colors
                                        .blue, // Warna untuk panah atau penanda titik
                                    fontSize: 15,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "Saat produk di beli oleh tingkatan Pertama anda menghasilkan pendapatan. anda akan mendapatkan 10% dari hasil pembelian produk bawahan.",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 10),
                          const Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "> ",
                                  style: TextStyle(
                                    color: Colors
                                        .blue, // Warna untuk panah atau penanda titik
                                    fontSize: 15,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "Saat produk di beli oleh tingkatan Kedua anda menghasilkan pendapatan. anda akan mendapatkan 4% dari hasil pembelian produk bawahan.",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 10),
                          const Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "> ",
                                  style: TextStyle(
                                    color: Colors
                                        .blue, // Warna untuk panah atau penanda titik
                                    fontSize: 15,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "Saat produk di beli oleh tingkatan Ketiga anda menghasilkan pendapatan. anda akan mendapatkan 2% dari hasil pembelian produk bawahan.",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 80),
                          const SizedBox(height: 80),
                          _buildCopyButton(
                              customerData['code'] ??
                                  "Harap Login Terlebih dahulu",
                              customerData['code'] ??
                                  "Harap Login Terlebih dahulu"),
                          const SizedBox(height: 10),
                          // _buildCopyButton(
                          //     customerData['url_referal'] ??
                          //         "Harap Login Terlebih dahulu",
                          //     customerData['url_referal'] ??
                          //         "Harap Login Terlebih dahulu"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCopyButton(String text, String hintText) {
    return Stack(
      children: [
        TextFormField(
          enabled: false,
          style: const TextStyle(fontSize: 16.0),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(
              top: 15,
              left: 15,
              right: 80,
            ),
            labelText: text,
            labelStyle: const TextStyle(color: Colors.black),
            filled: true,
            fillColor: formColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: formBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: formBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: formBorder),
            ),
            prefixIcon: const Icon(
              Icons.person_outline,
              color: Colors.black26,
            ),
          ),
        ),
        Positioned(
          bottom: 5,
          top: 5,
          right: 0,
          child: ElevatedButton(
            onPressed: () {
              _copyToClipboard(text, hintText);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                ),
              ),
            ),
            child: const Text(
              'Copy',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  void _copyToClipboard(String text, String hintText) {
    Clipboard.setData(ClipboardData(text: hintText));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('$text copied to clipboard'),
      duration: const Duration(seconds: 2),
    ));
  }
}
