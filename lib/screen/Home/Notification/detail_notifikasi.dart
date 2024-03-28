import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:rsnaturopaty/widget/utils/CustomDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailNotifikasi extends StatefulWidget {
  const DetailNotifikasi({super.key, required this.notifId});

  final String notifId;

  @override
  State<DetailNotifikasi> createState() => _DetailNotifikasiState();
}

class _DetailNotifikasiState extends State<DetailNotifikasi> {
  String token = "";
  bool _isLoading = false;
  Map<String, dynamic> detailNotif = {};

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
    notificationDetail();
  }

  notificationDetail() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final response = await http.get(
        Uri.parse(Endpoint.getDetailNotification + widget.notifId),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'X-auth-token': token,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        print(responseJson);
        setState(() {
          detailNotif = responseJson['content'];
        });
      }
    } catch (e) {
      CustomDialog().warning(context, '', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Detail'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              detailNotif['subject'],
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Created: ${detailNotif['created']}',
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Content:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              parseHtmlString(detailNotif['content']),
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String parseHtmlString(String htmlString) {
    // Here you can implement your logic to parse HTML string,
    // currently, it just removes HTML tags and returns plain text.
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }
}
