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
  List dataNotif = [];
  int _page = 0;
  bool _isLoading = false;
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getSharedPref();
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
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
          '{"type":"", "campaign":"", "read":"", "limit":"100", "offset":"$_page"}';
      final response = await http.post(Uri.parse(Endpoint.getNotification),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'X-auth-token': token,
          },
          body: resBody);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print("========== JUMLAH NOTIF ============");
        print(responseData['content'].length);
        final dataJson = responseData['content'] as List;
        setState(() {
          dataNotif = dataNotif + dataJson;
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

  Future<void> _scrollListener() async {
    if (_isLoading) return;
    if (scrollController.offset == scrollController.position.maxScrollExtent) {
      //&&  !_scrollController.position.outOfRange
      setState(() {
        _isLoading = true;
      });
      _page = _page + 1;
      await notification();
      setState(() {
        _isLoading = false;
      });
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
        padding: const EdgeInsets.all(10),
        controller: scrollController,
        itemCount: _isLoading ? dataNotif.length + 1 : dataNotif.length,
        itemBuilder: (context, index) {
          if (index < dataNotif.length) {
            final item = dataNotif[index];
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
      ),
    );
  }
}
