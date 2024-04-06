import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:rsnaturopaty/widget/button_widget/ButtonOval.dart';
import 'package:rsnaturopaty/widget/utils/Colors.dart';
import 'package:rsnaturopaty/widget/utils/CustomDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetBonus extends StatefulWidget {
  const SetBonus({super.key, required this.salesId});

  final String salesId;

  @override
  State<SetBonus> createState() => _SetBonusState();
}

//getTransactionDetail

class _SetBonusState extends State<SetBonus> {
  String token = "";
  Map<String, dynamic> dataSales = {};
  List dataContentSales = [];
  String selectedBonus = "";

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
    salesGetData();
  }

  salesGetData() async {
    print(Endpoint.getTransactionDetail + widget.salesId);
    try {
      final response = await http.get(
        Uri.parse(Endpoint.getTransactionDetail + widget.salesId),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'X-auth-token': token,
        },
      ).timeout(const Duration(seconds: 60));
      print(response.statusCode);
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
      } else {
        // Jika panggilan API gagal, tangani kesalahan
        // throw Exception(
        //     'Failed to load payment methods: ${response.statusCode}');
      }
    } catch (e) {
      CustomDialog().warning(context, '', e.toString());
    }
  }

  setBonusCustomer() async {
    print("=========== Get Checkout Data ============");
    print('${Endpoint.setBonus + widget.salesId}/$selectedBonus');
    try {
      final response = await http.get(
          Uri.parse('${Endpoint.setBonus + widget.salesId}/$selectedBonus'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'X-auth-token': token,
          }).timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        print(response.statusCode);
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        print(responseJson);
        Navigator.of(context).pop();
        CustomDialog()
            .dialogSuksesMultiplePop(context, "Berhasil Memilih Bonus", 1);
      } else if (response.statusCode == 403) {
        print('${response.statusCode}');
        final Map<String, dynamic> errorJson =
            json.decode(response.body.toString());
        String errorMessage = errorJson["error"];
        CustomDialog().warning(context, '', errorMessage);
        //  print('Login failed: $errorMessage');
        //  print('Login failed with status code: ${response.statusCode}');
      } else {
        print("Error Checkout status code: ${response.statusCode}");
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
          "View Transaction",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.purple,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: shadow,
                        blurRadius: 5.0,
                      )
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "View Transaction",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    RowData1(
                      parameter: "Product",
                      value: dataContentSales.isNotEmpty
                          ? dataContentSales[0]['product'].toString()
                          : '',
                    ),
                    RowData1(
                      parameter: "Total",
                      value: dataSales['total'].toString(),
                    ),
                    RowData1(
                      parameter: "Tax",
                      value: dataSales['tax'].toString(),
                    ),
                    RowData1(
                      parameter: "Discount",
                      value: dataSales['discount'].toString(),
                    ),
                    RowData1(
                      parameter: "Amount",
                      value: dataSales['tot_amt'].toString(),
                    ),
                    Row(
                      children: [
                        const Expanded(
                          flex: 3,
                          child: Text(
                            "select bonus",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        //Expanded(flex: 1, child: Text("   ")),
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Radio(
                                      activeColor: colorPrimary,
                                      value: "wallet",
                                      groupValue: selectedBonus,
                                      onChanged: (newValue) => setState(() {
                                        print(newValue);
                                        selectedBonus = newValue.toString();
                                      }),
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                  const Text("Wallet"),
                                ],
                              ),
                              const SizedBox(width: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Radio(
                                      activeColor: colorPrimary,
                                      value: "point",
                                      groupValue: selectedBonus,
                                      onChanged: (newValue) => setState(() {
                                        print(newValue);
                                        selectedBonus = newValue.toString();
                                      }),
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                  const Text("Point"),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(width: 20),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Text(''),
                        ),
                        Expanded(
                          flex: 1,
                          child: ButtonOval(
                            label: "Kirim",
                            onPressed: () {
                              print(widget.salesId);
                              setBonusCustomer();
                              //alertKonfirmasi();
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RowData1 extends StatelessWidget {
  final String parameter;
  final String value;

  const RowData1({
    super.key,
    required this.parameter,
    required this.value,
  });

  @override
  Widget build(BuildContext) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Text(parameter,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 15))),
          const Expanded(flex: 0, child: Text(":   ")),
          Expanded(
              flex: 6,
              child: Text(value,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}
