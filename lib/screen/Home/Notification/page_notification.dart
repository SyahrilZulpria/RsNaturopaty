import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rsnaturopaty/api/Endpoint.dart';
import 'package:rsnaturopaty/screen/Home/Notification/detail_notifikasi.dart';
import 'package:rsnaturopaty/widget/utils/CustomDialog.dart';
import 'package:rsnaturopaty/widget/utils/NavBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPages extends StatefulWidget {
  const NotificationPages({super.key});

  @override
  State<NotificationPages> createState() => _NotificationPagesState();
}

class _NotificationPagesState extends State<NotificationPages> {
  String token = "";
  List notifications = [];
  int _page = 0;
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

  notificationDetail(String id) async {
    try {
      setState(() {
        _isLoading = true;
      });
      final response = await http.get(
        Uri.parse(Endpoint.getDetailNotification + id),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'X-auth-token': token,
        },
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson =
            json.decode(response.body.toString());
        print(responseJson);
        CustomDialog().warning(context, '', 'Notification has been read');
        // setState(() {
        //   _isLoading = false;
        // Setelah mendapatkan detail notifikasi, set isLoading ke false
        // });
        // await notification();
        // setState(() {
        //   detailNotif = responseJson['content'];
        // });
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
        centerTitle: true,
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
                notificationDetail(item['id'].toString());
                // Navigator.of(context).push(
                //   CupertinoPageRoute(
                //     builder: (context) => DetailNotifikasi(
                //       notifId: item['id'].toString(),
                //     ),
                //   ),
                // );
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
