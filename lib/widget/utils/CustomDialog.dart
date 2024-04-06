import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rsnaturopaty/login.dart';
import 'package:rsnaturopaty/screen/Setting/wallet_poiny/history_wallet.dart';
import 'package:rsnaturopaty/verify.dart';
import 'package:rsnaturopaty/widget/utils/Colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDialog {
  void dialogSukses(BuildContext context, String keterangan) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return CupertinoAlertDialog(
          content: Column(
            children: <Widget>[
              Image.asset(
                "assets/ic_success.png",
                width: 120,
                height: 120,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                keterangan,
                style: const TextStyle(height: 1.3),
              ),
            ],
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Container(
                      child: CupertinoDialogAction(
                        child: Text("Tutup",
                            style:
                                TextStyle(fontSize: 16, color: colorPrimary)),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void dialogSuksesDoublePop(BuildContext context, String keterangan) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return CupertinoAlertDialog(
          content: Column(
            children: <Widget>[
              Image.asset(
                "assets/ic_success.png",
                width: 120,
                height: 120,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                keterangan,
                style: const TextStyle(height: 1.3),
              ),
            ],
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Container(
                      child: CupertinoDialogAction(
                          child: const Text("Tutup",
                              style: TextStyle(
                                  fontSize: 16, color: headerBackground)),
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void dialogSuksesMultiplePop(
      BuildContext context, String keterangan, int loop) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return CupertinoAlertDialog(
          content: Column(
            children: <Widget>[
              Image.asset(
                "assets/ic_success.png",
                width: 120,
                height: 120,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                keterangan,
                style: const TextStyle(height: 1.3),
              ),
            ],
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Container(
                      child: CupertinoDialogAction(
                          child: const Text("Tutup",
                              style: TextStyle(
                                  fontSize: 16, color: headerBackground)),
                          onPressed: () {
                            for (int i = 0; i <= loop; i++) {
                              Navigator.of(context).pop();
                            }
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void dialogSuksesWithNavigator(
      BuildContext context, String keterangan, Future<dynamic> nav) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return CupertinoAlertDialog(
          content: Column(
            children: <Widget>[
              Image.asset(
                "assets/ic_registration_success.png",
                width: 120,
                height: 120,
              ),
              Text(
                keterangan,
                style: const TextStyle(height: 1.3),
              ),
            ],
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Container(
                      child: CupertinoDialogAction(
                        child: const Text("Tutup",
                            style: TextStyle(
                                fontSize: 16, color: headerBackground)),
                        onPressed: () {
                          nav;
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void warningVerify(BuildContext context, String title, String desc) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: title != ''
              ? Text(title, style: const TextStyle(fontWeight: FontWeight.w700))
              : const SizedBox(
                  height: 0,
                ),
          content: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              desc,
              style: const TextStyle(
                color: Colors.black,
                height: 1.4,
                fontSize: 16,
              ),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
                child: const Text("Tutup",
                    style: TextStyle(fontSize: 16, color: headerBackground)),
                onPressed: () {
                  Navigator.of(context).pushReplacement(CupertinoPageRoute(
                      builder: (context) => const VerifyPages()));
                }),
          ],
        );
      },
    );
  }

  void warning(BuildContext context, String title, String desc) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: title != ''
              ? Text(title, style: const TextStyle(fontWeight: FontWeight.w700))
              : const SizedBox(
                  height: 0,
                ),
          content: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              desc,
              style: const TextStyle(
                color: Colors.black,
                height: 1.4,
                fontSize: 16,
              ),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text("Tutup",
                  style: TextStyle(fontSize: 16, color: headerBackground)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void successWd(BuildContext context, String title, String desc) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: title != ''
              ? Text(title, style: const TextStyle(fontWeight: FontWeight.w700))
              : const SizedBox(
                  height: 0,
                ),
          content: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              desc,
              style: const TextStyle(
                color: Colors.black,
                height: 1.4,
                fontSize: 16,
              ),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text("Tutup",
                  style: TextStyle(fontSize: 16, color: headerBackground)),
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => const HistoryWallet(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void expiredTokens(BuildContext context, String title, String desc) {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: title != ''
              ? Text(title, style: const TextStyle(fontWeight: FontWeight.w700))
              : const SizedBox(
                  height: 0,
                ),
          content: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              desc,
              style: const TextStyle(
                color: Colors.black,
                height: 1.4,
                fontSize: 16,
              ),
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text("Tutup",
                  style: TextStyle(fontSize: 16, color: headerBackground)),
              onPressed: () => logout(context),
            ),
          ],
        );
      },
    );
  }

  logout(BuildContext context) async {
    final sp = await SharedPreferences.getInstance();

    sp.setString('is_login', '0');

    Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(pageBuilder: (_, __, ___) => const Login()),
        (Route<dynamic> route) => false);
  }
}
