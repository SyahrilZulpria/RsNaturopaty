import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:rsnaturopaty/screen/Setting/SettingPages.dart';
import 'package:rsnaturopaty/widget/utils/Colors.dart';
import 'package:rsnaturopaty/widget/utils/CustomDialog.dart';
import 'package:rsnaturopaty/widget/utils/NavBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class NewRedeem extends StatefulWidget {
  const NewRedeem({super.key});

  @override
  State<NewRedeem> createState() => _NewRedeemState();
}

class _NewRedeemState extends State<NewRedeem> {
  String token = '';
  List listDompet = [];
  TextEditingController saldoController = TextEditingController();
  final TextEditingController _customAmountController = TextEditingController();
  double _selectedAmount = 0;
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
    saldoDompet();
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
        print('saldoPoint: ${response.statusCode}');
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        final Map<String, dynamic> content = responseJson['content'];
        final int balance = content['balance'];
        setState(() {
          listDompet = [balance.toString()];
        });
      } else {
        print('Login failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      //CustomDialog().warning(context, '', e.toString());
    }
  }

  postRedeem(String withdrawalAmount) async {
    print("===================");
    print(Endpoint.postRedeem);
    print("===================");
    // print(selectedPaymentMethod);
    print(withdrawalAmount);
    print(saldoController.text.toString());
    try {
      final response = await http
          .post(Uri.parse(Endpoint.postRedeem), headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
        'X-auth-token': token,
      }, body: {
        'amount': (withdrawalAmount.isNotEmpty)
            ? withdrawalAmount
            : saldoController.text.toString(),
      }).timeout(const Duration(seconds: 60));
      print(response.statusCode);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        print(responseJson);
        //salesId = responseJson['content']['id'];
        CustomDialog()
            .successWd(context, '', responseJson["content"].toString());
      } else if (response.statusCode == 403) {
        print('${response.statusCode}');
        final Map<String, dynamic> errorJson =
            json.decode(response.body.toString());
        String errorMessage = errorJson["error"];
        CustomDialog().warning(context, '', errorMessage);
      } else {
        print("Error salesUpdateItem status code: ${response.statusCode}");
        final Map<String, dynamic> errorJson =
            json.decode(response.body.toString());
        String errorMessage = errorJson["error"];
        CustomDialog().warning(context, '', errorMessage);
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
          'Redeem',
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
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
                                  listDompet.isNotEmpty
                                      ? NumberFormat.decimalPattern()
                                          .format(int.parse(listDompet.first))
                                      : " 0",
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                const SizedBox(height: 5),
                                const Divider(),
                                const Text(
                                  "Saldo Ku",
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
              const SizedBox(height: 20.0),
              const Text(
                'Pilih Jumlah Nominal',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10.0,
                childAspectRatio: 4 / 1,
                children: List.generate(
                  10,
                  (index) {
                    int amount = (index + 1) * 200000;
                    return ChoiceChip(
                      label: Text(NumberFormat.decimalPattern().format(amount)),
                      selected: _selectedAmount == amount,
                      onSelected: (bool selected) {
                        setState(
                          () {
                            if (selected) {
                              _selectedAmount = amount as double;
                            } else {
                              _selectedAmount = 0;
                            }
                            _customAmountController.clear();
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  minimumSize: MaterialStateProperty.all<Size>(
                    const Size.fromHeight(50),
                  ),
                ),
                onPressed: _selectedAmount == 0
                    ? null // Nonaktifkan tombol jika tidak ada jumlah nominal yang dipilih
                    : () async {
                        setState(() {
                          isLoading = true;
                        });
                        print('Withdrawal amount: $_selectedAmount');
                        await postRedeem(_selectedAmount.toString());
                        setState(() {
                          isLoading = false;
                        });
                      },
                // () async {
                //   setState(() {
                //     isLoading = true;
                //   });
                //   // double withdrawalAmount = _selectedAmount != 0
                //   //     ? _selectedAmount.toDouble()
                //   //     : double.tryParse(_customAmountController.text) ?? 0;
                //   print('Withdrawal amount: $_selectedAmount');
                //   await postRedeem(_selectedAmount.toString());
                //   setState(() {
                //     isLoading = false;
                //   });
                // },
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        'Withdraw',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
