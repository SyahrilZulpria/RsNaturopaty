import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:rsnaturopaty/screen/Setting/SettingPages.dart';
import 'package:rsnaturopaty/widget/utils/CustomDialog.dart';
import 'package:rsnaturopaty/widget/utils/NavBar.dart';
import 'package:rsnaturopaty/widget/utils/inputanFormCustome.dart';
import 'package:search_choices/search_choices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PilihBankPages extends StatefulWidget {
  var data;
  PilihBankPages({
    super.key,
    required this.data,
  });

  @override
  State<PilihBankPages> createState() => _PilihBankPagesState();
}

class _PilihBankPagesState extends State<PilihBankPages> {
  String token = "";
  String? selectedBank;
  String idBank = "";
  String namaBank = "";
  List<Map<String, dynamic>> listBank = [];
  TextEditingController namaBankController = TextEditingController();
  TextEditingController noRekBankController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getSharedPref();
    getDataBank();
  }

  getSharedPref() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("token")!;
    });
  }

  getDataBank() async {
    try {
      final response = await http.get(
        Uri.parse(Endpoint.bankList),
        headers: <String, String>{
          'Content-Type': 'application/json',
          //'X-auth-token': token,
        },
      ).timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        setState(() {
          listBank = List<Map<String, dynamic>>.from(
            responseJson['content']['result']
                .map((bank) => {'id': bank['id'], 'code': bank['code']}),
          );
        });
      } else if (response.statusCode == 401) {
        print('Login failed with : Unauthorized access');
      } else if (response.statusCode == 403) {
        CustomDialog()
            .expiredTokens(context, 'Token Expired', "Harap Login Kembali!");
      } else {
        print("Get data failed with status code: ${response.statusCode}");
      }
    } catch (e) {
      CustomDialog().warning(context, '', e.toString());
    }
  }

  submitUpdateCustomer() async {
    try {
      final response = await http
          .post(Uri.parse(Endpoint.uodateCustomer), headers: <String, String>{
        "Content-Type": "application/x-www-form-urlencoded",
        'X-auth-token': token
      }, body: {
        "tname": widget.data['fname'].toString(),
        "tphone1": widget.data['phone1'].toString(),
        "temail": widget.data['email'].toString(),
        "taddress": widget.data['address'].toString(),
        "ccity": widget.data['city'].toString(),
        "cdistrict": "0",
        "tzip": widget.data['zip'].toString(),
        "tnpwp": widget.data['npwp'].toString(),
        "twebsite": widget.data['website'].toString(),
        "tinstagram": widget.data['instagram'].toString(),
        "tprofession": widget.data['profession'].toString(),
        "torganization": widget.data['organization'].toString(),
        "taccname": (namaBankController.text.isNotEmpty)
            ? namaBankController.text
            : widget.data['acc_name'],
        "taccno": (noRekBankController.text.isNotEmpty)
            ? noRekBankController.text
            : widget.data['acc_no'],
        "taccbank": (namaBank.isNotEmpty) ? namaBank : widget.data['acc_bank'],
      }).timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        print('API request successful');
        print(response.body);
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        print(responseJson);
        CustomDialog().dialogSuksesMultiplePop(
            context, "Berhasil Melakukan Edit Data", 1);
      } else if (response.statusCode == 400) {
        // Bad request, handle the error response
        final Map<String, dynamic> responseJson = json.decode(response.body);
        String errorMessage = responseJson['error'];
        CustomDialog().warning(context, 'Error', errorMessage);
      } else if (response.statusCode == 401) {
        CustomDialog()
            .expiredTokens(context, 'Token Expired', "Harap Login Kembali!");
      } else {
        // Failed request
        print('API request failed with status code: ${response.statusCode}');
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
          "Pilih Bank",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Text(
                      "Nama Rekening",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InputText(
                      label: widget.data['acc_name'] ?? " ".toString(),
                      controller: namaBankController,
                      keyboard: TextInputType.text,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Text(
                      "Bank",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey)),
                      child: SearchChoices.single(
                        underline: const SizedBox(
                          height: 0,
                        ),
                        displayClearIcon: false,
                        closeButton: "Tutup",
                        isExpanded: true,
                        iconSize: 25,
                        padding: 5,
                        value: selectedBank,
                        items: listBank.map((item) {
                          return DropdownMenuItem(
                            value: "${item['id']}-${item['code']}",
                            child: Text(
                              item['code'],
                              style: const TextStyle(fontSize: 16.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        hint: Text(
                          widget.data['acc_bank'].toString(),
                          //"Nama Bank Sebelumnya",
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        searchHint: "Select Bank",
                        onChanged: (newVal) {
                          FocusScope.of(context).requestFocus(
                            FocusNode(),
                          ); // <--- add this biar ga balik fokus ke textfield
                          setState(
                            () {
                              selectedBank = newVal;
                              if (newVal != null) {
                                idBank = newVal.split('-')[0];
                                namaBank = newVal.split('-')[1];
                                print("code$namaBank");
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Text(
                      "No Rekening",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InputDecimal(
                      label: widget.data['acc_no'] ?? " ".toString(),
                      controller: noRekBankController,
                      keyboard: TextInputType.number,
                      maxLength: 30,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () {
                  submitUpdateCustomer();
                },
                child: const Text(
                  'Withdraw',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
