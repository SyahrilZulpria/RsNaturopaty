import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:http/http.dart' as http;
import 'package:rsnaturopaty/widget/utils/CustomDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum EditType {
  Name,
  Address,
  Website,
  Instagram,
  Profession,
  Organization,
}

class EditDataPage extends StatefulWidget {
  var data;
  final String currentValue;
  final EditType editType;

  EditDataPage({
    super.key,
    required this.data,
    required this.currentValue,
    required this.editType,
  });

  @override
  _EditDataPageState createState() => _EditDataPageState();
}

class _EditDataPageState extends State<EditDataPage> {
  String token = '';
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentValue);
    getSharedPref();
  }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  //   getSharedPref();
  // }

  getSharedPref() async {
    final sp = await SharedPreferences.getInstance();

    setState(() {
      token = sp.getString("token")!;
    });
  }

  submitUpdateCustomer() async {
    print("======= Post =======");
    print(_controller);
    try {
      final response = await http
          .post(Uri.parse(Endpoint.uodateCustomer), headers: <String, String>{
        "Content-Type": "application/x-www-form-urlencoded",
        'X-auth-token': token
      }, body: {
        "tname": widget.editType == EditType.Name
            ? _controller.text
            : widget.data['fname'].toString(),
        "tphone1": widget.data['phone1'].toString(),
        "temail": widget.data['email'].toString(),
        "taddress": widget.editType == EditType.Address
            ? _controller.text
            : widget.data['address'].toString(),
        "ccity": widget.data['city'].toString(),
        "cdistrict": "0",
        "tzip": widget.data['zip'].toString(),
        "tnpwp": widget.data['npwp'].toString(),
        "twebsite": widget.editType == EditType.Website
            ? _controller.text
            : widget.data['website'].toString(),
        "tinstagram": widget.editType == EditType.Instagram
            ? _controller.text
            : widget.data['instagram'].toString(),
        "tprofession": widget.editType == EditType.Profession
            ? _controller.text
            : widget.data['profession'].toString(),
        "torganization": widget.editType == EditType.Organization
            ? _controller.text
            : widget.data['organization'].toString(),
        "taccname": widget.data['acc_name'].toString(),
        "taccno": widget.data['acc_no'].toString(),
        "taccbank": widget.data['acc_bank'].toString(),
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
        title: Text(_getTitle()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(labelText: _getInputLabel()),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Submit data saat tombol disimpan ditekan
                submitUpdateCustomer();
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  String _getTitle() {
    switch (widget.editType) {
      case EditType.Name:
        return 'Edit Name';
      case EditType.Address:
        return 'Edit Address';
      case EditType.Website:
        return 'Edit Website';
      case EditType.Instagram:
        return 'Edit Instagram';
      case EditType.Profession:
        return 'Edit Profession';
      case EditType.Organization:
        return 'Edit Organization';
      // Tambahkan judul lain sesuai dengan jenis data yang ingin diedit di sini
    }
  }

  String _getInputLabel() {
    switch (widget.editType) {
      case EditType.Name:
        return 'Name';
      case EditType.Address:
        return 'Address';
      case EditType.Website:
        return 'Website';
      case EditType.Instagram:
        return 'Instagram';
      case EditType.Profession:
        return 'Profession';
      case EditType.Organization:
        return 'Organization';
      // Tambahkan label lain sesuai dengan jenis data yang ingin diedit di sini
    }
  }
}
