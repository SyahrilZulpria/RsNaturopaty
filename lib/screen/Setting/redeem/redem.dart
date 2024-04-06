import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rsnaturopaty/screen/Setting/SettingPages.dart';
import 'package:rsnaturopaty/widget/utils/Colors.dart';

class Redeem extends StatefulWidget {
  const Redeem({super.key});

  @override
  State<Redeem> createState() => _RedeemState();
}

class _RedeemState extends State<Redeem> {
  TextEditingController saldoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Redeem'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => const SettingPages(),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text("Saldo saat ini : 315151"),
            const SizedBox(height: 10),
            TextFormField(
              controller: saldoController,
              style: const TextStyle(fontSize: 16.0),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(top: 15, left: 15),
                labelText: 'Redeem',
                labelStyle: const TextStyle(color: Colors.black),
                filled: true,
                fillColor: formColor,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: formBorder)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: formBorder)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: formBorder)),
                prefixIcon: const Icon(
                  Icons.price_change_sharp,
                  color: Colors.black26,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
