import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:rsnaturopaty/screen/Home/Notification/detail_notifikasi.dart';
import 'package:rsnaturopaty/widget/utils/CustomDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPages extends StatefulWidget {
  const NotificationPages({super.key});

  @override
  State<NotificationPages> createState() => _NotificationPagesState();
}

class _NotificationPagesState extends State<NotificationPages> {
  String token = "";
  List notifications = [];
  int _page = 1;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getSharedPref();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  getSharedPref() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      token = sp.getString("token")!;
    });
    notification();
  }

  notification() async {
    try {
      setState(() {
        _isLoading = true;
      });
      var resBody =
          '{	"type":"", "campaign":"", "read":"", "limit":"50", "offset":"(_page - 1) * 10"}';
      final response = await http.post(Uri.parse(Endpoint.getNotification),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'X-auth-token': token,
          },
          body: resBody);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        setState(() {
          notifications.addAll(responseData['content']);
          _isLoading = false;
          _page++;
        });
      }
    } catch (e) {
      CustomDialog().warning(context, '', e.toString());
    }
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      notification();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notification",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.purple,
      ),
      body: ListView.builder(
        itemCount: notifications.length + (_isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < notifications.length) {
            final item = notifications[index];
            final bool isRead = item['reading'] == '1';
            return InkWell(
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => DetailNotifikasi(
                      notifId: item['id'].toString(),
                    ),
                  ),
                );
                print(item['id']);
              },
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      item['subject'],
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                              isRead ? FontWeight.normal : FontWeight.bold),
                    ),
                    subtitle: Text(
                      item['type'],
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isRead ? FontWeight.normal : FontWeight.bold),
                    ),
                    trailing: Text(
                      item['created'].toString(),
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isRead ? FontWeight.normal : FontWeight.bold),
                    ),
                  ),
                  const Divider(),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        controller: _scrollController,
      ),
    );
  }
}
